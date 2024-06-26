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
        //
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

// MARK: - TableView Data Source
extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: K.quoteReuseIdentifier,
            for: indexPath
        ) as? QuoteCell else {
            return UITableViewCell()
        }
        
        cell.configure(text: "The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.", author: "Lorem Ipsum")
        return cell
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
