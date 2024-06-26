//
//  FavoritesViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 22.06.2024.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - UI
    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: K.quoteTitle, at: 0, animated: true)
        segment.insertSegment(withTitle: K.jokesTitle, at: 1, animated: true)
        segment.insertSegment(withTitle: K.chuckNorrisTitle, at: 2, animated: true)
        segment.selectedSegmentTintColor = UIColor(resource: .snow)
        segment.addTarget(self, action: #selector(segmentValueDidChanged), for: .valueChanged)
        return segment
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 176
        tableView.separatorStyle = .none
        tableView.register(QuoteCell.self, forCellReuseIdentifier: K.quoteReuseIdentifier)
        tableView.backgroundColor = UIColor(resource: .snow)
        return tableView
    }()
    
    // MARK: - View Model
    private let viewModel = FavoritesViewModel()
    private let storage = QuoteManager.shared
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        setupDeligates()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Set Views
    private func setupUI() {
        view.addSubview(segmentControl)
        view.addSubview(tableView)
    }
}

// MARK: - Configure UI
extension FavoritesViewController {
    private func configureUI() {
        view.backgroundColor = UIColor(resource: .snow)
        segmentControl.selectedSegmentIndex = 0
    }
}

// MARK: - Fetch Data
extension FavoritesViewController {
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchQuotes {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchJokes {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchChuckJokes {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Fetch Quotes
    private func fetchQuotes(completion: @escaping () -> Void) {
        storage.fetchQuotes { [weak self] result in
            defer { completion() }
            
            do {
                let quotes = try result.get()
                self?.viewModel.quotes = quotes
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch Jokes
    private func fetchJokes(completion: @escaping () -> Void) {
        defer { completion() }
        
        storage.fetchJokes { [weak self] result in
            do {
                let jokes = try result.get()
                self?.viewModel.jokes = jokes
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Fetch C.N. Jokes
    private func fetchChuckJokes(completion: @escaping () -> Void) {
        defer { completion() }
        
        storage.fetchChuckJokes { [weak self] result in
            do {
                let chuckJokes = try result.get()
                print(chuckJokes.count)
                self?.viewModel.chuckJokes = chuckJokes
            } catch {
                print(error.localizedDescription)
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
        tableView.delegate = self
    }
}

// MARK: - Actions
extension FavoritesViewController {
    @objc private func segmentValueDidChanged(_ sender: UISegmentedControl) {
        guard let section = SectionType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        
        viewModel.sectionType = section
        tableView.reloadData()
    }
}

// MARK: - Setup Constraints
extension FavoritesViewController {
    private func setupConstraints() {
        setupSegmentControlConstraints()
        setupTableViewConstraints()
    }
    
    private func setupSegmentControlConstraints() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

fileprivate struct Metrics {
    static let sectionImageHeight: CGFloat = 85.0
    
    static let quotesTitleOffsetTop: CGFloat = -18
    static let jokesTitleOffsetTop: CGFloat = -12
    static let chuckTitleOffsetTop: CGFloat = -4
    
    private init () {}
}
