//
//  MainViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - UI
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = K.searchPlaceholder
        return searchBar
    }()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: K.quoteTitle, at: 0, animated: true)
        segment.insertSegment(withTitle: K.jokesTitle, at: 1, animated: true)
        segment.insertSegment(withTitle: K.chuckNorrisTitle, at: 2, animated: true)
        segment.selectedSegmentTintColor = UIColor(resource: .snow)
        segment.addTarget(self, action: #selector(segmentValueDidChanged), for: .valueChanged)
        return segment
    }()
    
    private let sectionImageView = UIImageView()
    
    private let sectionLabel = UILabel(
        text: K.quoteSectionTitle,
        font: UIFont(name: K.fontMontserrat400, size: 32),
        lines: 2
    )
    
    private let pickerView = UIPickerView()
    
    private lazy var fetchButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemCyan.cgColor
        button.addTarget(self, action: #selector(fetchButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private let emptyContentStackView = UIStackView(
        axis: .vertical,
        spacing: 8,
        isHidden: true
    )
    
    private lazy var notFoundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(resource: .turtle)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let notFoundLabel = UILabel(
        text: K.notFound,
        textColor: .heavyGray.withAlphaComponent(0.8),
        alignment: .center,
        font: UIFont(name: K.fontMontserrat400, size: 16)
    )
    
    // MARK: - Private Properties
    private var isSearchBarHidden: Bool = false {
        didSet {
            searchBar.snp.updateConstraints { make in
                make.height.equalTo(isSearchBarHidden ? 0 : Metrics.searchBarHeight)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private var isPickerViewHidden: Bool = false {
        didSet {
            pickerView.snp.updateConstraints { make in
                make.height.equalTo(isPickerViewHidden ? 0 : Metrics.pickerViewHeight)
            }
            
            if !viewModel.categories.isEmpty {
                pickerView.isHidden = (isPickerViewHidden ? true : false)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - View Model
    private let viewModel = CategoryViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        setupDelegates()
        setupConstraints()
        setupTapGesture()
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Set Views
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(segmentControl)
        view.addSubview(sectionImageView)
        view.addSubview(sectionLabel)
        view.addSubview(pickerView)
        view.addSubview(fetchButton)
        view.addSubview(emptyContentStackView)
        emptyContentStackView.addArrangedSubview(notFoundImageView)
        emptyContentStackView.addArrangedSubview(notFoundLabel)
    }
}

// MARK: - Configure UI
extension MainViewController {
    private func configureUI() {
        view.backgroundColor = UIColor(resource: .snow)
        segmentControl.selectedSegmentIndex = 0
        
        configureSectionImageView(image: .quote)
        setCustomButtonTitle(title: K.fetchButtonQuoteTitle)
    }
    
    private func configureSectionImageView(image: UIImage) {
        let image = image
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.heavyGray.withAlphaComponent(0.12))
        
        sectionImageView.image = image
        sectionImageView.contentMode = .scaleAspectFit
    }
    
    private func setCustomButtonTitle(title: String) {
        fetchButton.customizeTitle(
            title: title,
            font: UIFont(name: K.fontMontserrat400, size: 18),
            foregroundColor: UIColor.white,
            shadowColor: UIColor.systemCyan,
            shadowRadius: 5
        )
    }
}

// MARK: - Configure UI For Section
extension MainViewController {
    private func configureUI(for section: SectionType) {
        let configuration: SectionConfiguration
        
        switch section {
        case .quote:
            let isEmptyContentHidden = !viewModel.categories.isEmpty
            configuration = SectionConfiguration(
                image: .quote,
                title: K.quoteSectionTitle,
                buttonTitle: K.fetchButtonQuoteTitle,
                isSearchBarHidden: false,
                isPickerViewHidden: false,
                isEmptyContentViewHidden: isEmptyContentHidden
            )
        case .joke:
            configuration = SectionConfiguration(
                image: .joke,
                title: K.jokesSectionTitle,
                buttonTitle: K.fetchButtonJokeTitle,
                isSearchBarHidden: true,
                isPickerViewHidden: true,
                isEmptyContentViewHidden: true
            )
        case .chucknorris:
            configuration = SectionConfiguration(
                image: .chuck,
                title: K.chuckSectionTitle,
                buttonTitle: K.fetchButtonChuckTitle,
                isSearchBarHidden: true,
                isPickerViewHidden: true,
                isEmptyContentViewHidden: true
            )
        }
        
        applyConfiguration(configuration)
        updateSectionLabelConstraints()
    }
    
    private func applyConfiguration(_ config: SectionConfiguration) {
        configureSectionImageView(image: config.image)
        sectionLabel.text = config.title
        setCustomButtonTitle(title: config.buttonTitle)
        isSearchBarHidden = config.isSearchBarHidden
        isPickerViewHidden = config.isPickerViewHidden
        emptyContentStackView.isHidden = config.isEmptyContentViewHidden
    }
}

// MARK: - Setup Delegates
extension MainViewController {
    private func setupDelegates() {
        viewModel.delegate = self
        searchBar.delegate = self
        pickerView.delegate = self
    }
}

// MARK: - PickerView DataSource & Delegate
extension MainViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedCategory = viewModel.categories[row]
    }
}

// MARK: - SearchBar Delegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCategories(with: searchText)
        
        if viewModel.categories.isEmpty {
            pickerView.isHidden = true
            emptyContentStackView.isHidden = false
        } else {
            pickerView.isHidden = false
            emptyContentStackView.isHidden = true
        }
    }
}

// MARK: - Category ViewModel Delegate
extension MainViewController: CategoryViewModelDelegate {
    func didUpdateCategories() {
        pickerView.reloadAllComponents()
    }
}

// MARK: - Actions
extension MainViewController {
    @objc private func hideKeyboard() {
        if searchBar.isFirstResponder {
            view.endEditing(true)
        }
    }
    
    @objc private func fetchButtonPressed(_ sender: UIButton) {
        let selectedCategory = viewModel.selectedCategory.rawValue
        let quoteVC = PresentViewController()
        let sectionType = viewModel.sectionType
        let quoteViewModel = QuoteViewModel(
            sectionType: sectionType,
            quoteCategory: sectionType == .quote ? selectedCategory : nil
        )
        
        quoteVC.viewModel = quoteViewModel
        quoteVC.viewModel?.delegate = quoteVC
        
        self.present(quoteVC, animated: true)
    }
    
    @objc private func segmentValueDidChanged(_ sender: UISegmentedControl) {
        guard let section = SectionType(rawValue: sender.selectedSegmentIndex) else {
            return
        }
        
        viewModel.sectionType = section
        configureUI(for: section)
    }
}

// MARK: - Setup Constraints
extension MainViewController {
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
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
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
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    private func updateSectionLabelConstraints() {
        sectionLabel.snp.updateConstraints { make in
            switch segmentControl.selectedSegmentIndex {
            case 0:
                make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.quotesTitleOffsetTop)
            case 1:
                make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.jokesTitleOffsetTop)
            case 2:
                make.top.equalTo(sectionImageView.snp.bottom).offset(Metrics.chuckTitleOffsetTop)
            default:
                break
            }
        }
    }
    
    private func setupPickerViewConstraints() {
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(sectionLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
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
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(Metrics.fetchButtonHeight)
        }
    }
}

fileprivate struct Metrics {
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
