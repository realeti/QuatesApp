//
//  MainView.swift
//  QuatesApp
//
//  Created by Apple M1 on 29.06.2024.
//

import UIKit

final class MainView: UIView {
    // MARK: - UI
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = K.searchPlaceholder
        return searchBar
    }()
    
    lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: K.quoteTitle, at: 0, animated: true)
        segment.insertSegment(withTitle: K.jokesTitle, at: 1, animated: true)
        segment.insertSegment(withTitle: K.chuckNorrisTitle, at: 2, animated: true)
        segment.selectedSegmentTintColor = UIColor(resource: .snow)
        return segment
    }()
    
    let sectionImageView = UIImageView()
    let sectionLabel = UILabel(
        text: K.quoteSectionTitle,
        textColor: .dark,
        font: UIFont(name: K.fontMontserrat400, size: 32),
        lines: 2
    )
    
    let pickerView = UIPickerView()
    
    lazy var fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemCyan.cgColor
        return button
    }()
    
    let emptyContentStackView = UIStackView(
        axis: .vertical,
        spacing: 8,
        isHidden: true
    )
    
    lazy var notFoundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .turtle)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let notFoundLabel = UILabel(
        text: K.notFound,
        textColor: .heavyGray.withAlphaComponent(0.8),
        alignment: .center,
        font: UIFont(name: K.fontMontserrat400, size: 16)
    )
    
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
        addSubview(searchBar)
        addSubview(segmentControl)
        addSubview(sectionImageView)
        addSubview(sectionLabel)
        addSubview(pickerView)
        addSubview(fetchButton)
        addSubview(emptyContentStackView)
        emptyContentStackView.addArrangedSubview(notFoundImageView)
        emptyContentStackView.addArrangedSubview(notFoundLabel)
    }
}

// MARK: - Configure UI
extension MainView {
    private func configureUI() {
        backgroundColor = UIColor(resource: .snow)
        segmentControl.selectedSegmentIndex = 0
    }
}

// MARK: - Setup Constraints
extension MainView {
    private func setupConstraints() {
        setupSearchBarConstraints()
        setupSegmentControlConstraints()
        setupSectionImageViewConstraints()
        setupSectionLabelConstraints()
        setupPickerViewConstraints()
        setupEmptyContentViewConstraints()
        setupNotFoundImageViewConstraints()
        setupFetchButtonConstraints()
    }
    
    private func setupSearchBarConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(Metrics.searchBarHeight)
        }
    }
    
    private func setupSegmentControlConstraints() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupSectionImageViewConstraints() {
        sectionImageView.snp.makeConstraints { make in
            make.top.equalTo(segmentControl.snp.bottom).offset(10)
            make.leading.equalTo(sectionLabel.snp.leading).offset(22)
            make.width.height.equalTo(Metrics.sectionImageHeight)
        }
    }
    
    private func setupSectionLabelConstraints() {
        sectionLabel.snp.makeConstraints { make in
            make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.quotesTitleOffsetTop)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(25)
        }
    }
    
    func updateSectionLabelConstraints(for section: SectionType) {
        sectionLabel.snp.updateConstraints { make in
            switch section {
            case .quote:
                make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.quotesTitleOffsetTop)
            case .joke:
                make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.jokesTitleOffsetTop)
            case .chucknorris:
                make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.chuckTitleOffsetTop)
            }
        }
    }
    
    private func setupPickerViewConstraints() {
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(10)
            make.height.equalTo(Metrics.pickerViewHeight)
        }
    }
    
    private func setupEmptyContentViewConstraints() {
        emptyContentStackView.snp.makeConstraints { make in
            make.center.equalTo(pickerView)
        }
    }
    
    private func setupNotFoundImageViewConstraints() {
        notFoundImageView.snp.makeConstraints { make in
            make.height.equalTo(Metrics.notFoundImageHeight)
        }
    }
    
    private func setupFetchButtonConstraints() {
        fetchButton.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(15)
            make.leading.trailing.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(Metrics.fetchButtonHeight)
        }
    }
}

extension MainView {
    struct Metrics {
        static let searchBarHeight: CGFloat = 44.0
        static let pickerViewHeight: CGFloat = 216.0
        static let sectionImageHeight: CGFloat = 85.0
        static let notFoundImageHeight: CGFloat = 50.0
        static let fetchButtonHeight: CGFloat = 50.0
        
        static let quotesTitleOffsetTop: CGFloat = -18
        static let jokesTitleOffsetTop: CGFloat = -12
        static let chuckTitleOffsetTop: CGFloat = -4
        
        private init () {}
    }
}
