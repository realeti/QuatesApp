//
//  FavoritesViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 22.06.2024.
//

import UIKit

final class FavoritesViewController: UIViewController {
    // MARK: - Private Properties
    private var favoritesView: FavoritesView!
    
    // MARK: - View Model
    private let viewModel = FavoritesViewModel()
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        
        favoritesView = FavoritesView()
        view = favoritesView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupDeligates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
}

// MARK: - Configure UI
extension FavoritesViewController {
    private func configureUI() {
        setupTapGesture()
        
        favoritesView.segmentControl.addTarget(self, action: #selector(segmentValueDidChanged), for: .valueChanged)
    }
}

// MARK: - Setup Tap Gesture
extension FavoritesViewController {
    private func setupTapGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        favoritesView.tableView.addGestureRecognizer(longPress)
    }
}

// MARK: - Fetch Data
extension FavoritesViewController {
    private func fetchData() {
        viewModel.fetchData { [weak self] in
            DispatchQueue.main.async {
                self?.favoritesView.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView Data Source
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.sectionType {
        case .quote:
            return viewModel.quotes.count
        case .joke:
            return viewModel.jokes.count
        case .chucknorris:
            return viewModel.chuckJokes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: K.quoteReuseIdentifier,
            for: indexPath
        ) as? QuoteCell else {
            return UITableViewCell()
        }
        
        let text = cellData(for: indexPath.row).text
        let author = cellData(for: indexPath.row).author
        
        cell.configure(text: text, author: author)
        return cell
    }
    
    private func cellData(for row: Int) -> (text: String, author: String) {
        switch viewModel.sectionType {
        case .quote:
            let quotes = viewModel.quotes
            return (quotes[row].quote, quotes[row].author)
        case .joke:
            let jokes = viewModel.jokes
            return (jokes[row].joke, K.authorRandomJoke)
        case .chucknorris:
            let chuckJokes = viewModel.chuckJokes
            return (chuckJokes[row].joke, K.authorChuckNorrisJoke)
        }
    }
}

// MARK: - TableView Delegate
extension FavoritesViewController: UITableViewDelegate {
    /// Custom Header View
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = QuoteHeaderView()
        let sectionType = viewModel.sectionType
        let headerImage = fetchHeaderElements(for: sectionType).image
        let headerTitle = fetchHeaderElements(for: sectionType).title
        headerView.configureUI(image: headerImage, title: headerTitle, section: sectionType)
        return headerView
    }
    
    private func fetchHeaderElements(for section: SectionType) -> (image: UIImage, title: String) {
        switch section {
        case .quote:
            return (image: .quote, title: K.favoriteQuotes)
        case .joke:
            return (image: .joke, title: K.favoriteJokes)
        case .chucknorris:
            return (image: .chuck, title: K.favoriteChuckNorris)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
}

// MARK: - Setup Delegates
extension FavoritesViewController {
    private func setupDeligates() {
        viewModel.delegate = self
        favoritesView.tableView.delegate = self
        favoritesView.tableView.dataSource = self
    }
}

// MARK: - Favorites ViewModel Delegate
extension FavoritesViewController: FavoritesViewModelDelegate {
    func didFailFetching(_ error: any Error) {
        DispatchQueue.main.async { [weak self] in
            self?.presentAlertContoller(error)
        }
    }
    
    func didFailDeleting(_ error: any Error) {
        DispatchQueue.main.async { [weak self] in
            self?.presentAlertContoller(error)
        }
    }
}

// MARK: - Present Error
extension FavoritesViewController {
    private func presentAlertContoller(_ error: Error) {
        let alert = UIAlertController(title: K.alertError, message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: K.alertOk, style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Actions
extension FavoritesViewController {
    @objc private func segmentValueDidChanged(_ sender: UISegmentedControl) {
        guard let section = SectionType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        
        viewModel.sectionType = section
        favoritesView.tableView.reloadData()
    }
    
    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        guard sender.state == .began else { return }
        let touchPoint = sender.location(in: favoritesView.tableView)
        
        guard let indexPath = favoritesView.tableView.indexPathForRow(at: touchPoint) else { return }
        
        let sectionType = viewModel.sectionType
        let currentElementId = getElementId(for: indexPath.row, section: sectionType)
        
        presentDeleteAlert(for: currentElementId, at: indexPath)
    }
    
    private func getElementId(for row: Int, section: SectionType) -> String {
        switch section {
        case .quote:
            return viewModel.quotes[row].quote.hashed()
        case .joke:
            return viewModel.jokes[row].joke.hashed()
        case .chucknorris:
            return viewModel.chuckJokes[row].joke.hashed()
        }
    }
    
    private func presentDeleteAlert(for id: String, at indexPath: IndexPath) {
        let alert = UIAlertController(title: K.favoriteDeleteMessage, message: K.favoriteDelete, preferredStyle: .alert)
        let actionDone = UIAlertAction(title: K.alertYes, style: .default) { [weak self] _ in
            self?.viewModel.deleteData(withId: id) {
                DispatchQueue.main.async { [weak self] in
                    self?.removeElement(from: indexPath)
                }
            }
        }
        
        let actionCancel = UIAlertAction(title: K.alertCancel, style: .cancel)
        alert.addAction(actionDone)
        alert.addAction(actionCancel)
        present(alert, animated: true)
    }
    
    private func removeElement(from indexPath: IndexPath) {
        let sectionType = viewModel.sectionType
        switch sectionType {
        case .quote:
            guard !viewModel.quotes.isEmpty else { return }
            viewModel.quotes.remove(at: indexPath.row)
        case .joke:
            guard !viewModel.jokes.isEmpty else { return }
            viewModel.jokes.remove(at: indexPath.row)
        case .chucknorris:
            guard !viewModel.chuckJokes.isEmpty else { return }
            viewModel.chuckJokes.remove(at: indexPath.row)
        }
        deleteTableRows(at: indexPath)
    }
    
    private func deleteTableRows(at indexPath: IndexPath) {
        favoritesView.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
