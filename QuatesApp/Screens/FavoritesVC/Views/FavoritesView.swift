//
//  FavoritesView.swift
//  QuatesApp
//
//  Created by Apple M1 on 29.06.2024.
//

import UIKit

final class FavoritesView: UIView {
    // MARK: - UI
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: K.quoteTitle, at: 0, animated: true)
        segment.insertSegment(withTitle: K.jokesTitle, at: 1, animated: true)
        segment.insertSegment(withTitle: K.chuckNorrisTitle, at: 2, animated: true)
        segment.selectedSegmentTintColor = UIColor(resource: .snow)
        return segment
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 176
        tableView.separatorStyle = .none
        tableView.register(QuoteCell.self, forCellReuseIdentifier: K.quoteReuseIdentifier)
        tableView.backgroundColor = UIColor(resource: .snow)
        return tableView
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set Views
    private func setupUI() {
        addSubview(segmentControl)
        addSubview(tableView)
    }
}

// MARK: - Configure UI
extension FavoritesView {
    private func configureUI() {
        backgroundColor = UIColor(resource: .snow)
        segmentControl.selectedSegmentIndex = 0
    }
}

// MARK: - Setup Constraints
extension FavoritesView {
    private func setupConstraints() {
        setupSegmentControlConstraints()
        setupTableViewConstraints()
    }
    
    private func setupSegmentControlConstraints() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupTableViewConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.bottom.equalTo(safeAreaLayoutGuide)
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
