//
//  CategoriesViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import UIKit

class CategoriesViewController: UIViewController {
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
        return segment
    }()
    
    private let sectionImageView = UIImageView()
    
    private let sectionLabel = UILabel(
        text: K.quoteSectionTitle,
        font: UIFont(name: K.fontMontserrat400, size: 32),
        lines: 2
    )
    
    private let pickerView = UIPickerView()
    private let fetchButton = UIButton(type: .system)
    private let notFoundStackView = UIStackView(axis: .vertical, spacing: 8)
    private let notFoundImageView = UIImageView()
    
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
            
            pickerView.isHidden = (isPickerViewHidden ? true : false)
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private var sectionType: SectionType = .quote
    
    // MARK: - View Model
    let categoryViewModel = CategoryViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        setupDelegates()
        setupConstraints()
        setupTapGesture()
        
        segmentControl.selectedSegmentIndex = 0
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        if searchBar.isFirstResponder {
            view.endEditing(true)
        }
    }
    
    // MARK: - Set Views
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(segmentControl)
        view.addSubview(sectionImageView)
        view.addSubview(sectionLabel)
        view.addSubview(pickerView)
        view.addSubview(fetchButton)
        view.addSubview(notFoundStackView)
        notFoundStackView.addArrangedSubview(notFoundImageView)
        notFoundStackView.addArrangedSubview(notFoundLabel)
    }
}

extension CategoriesViewController {
    // MARK: - Configure UI

    private func configureUI() {
        view.backgroundColor = UIColor(resource: .snow)
        configureSegmentControl()
        configureSectionImageView()
        configureNotFoundImageView()
        configureFetchButton()
    }
    
    private func configureSegmentControl() {
        segmentControl.selectedSegmentIndex = 0
        segmentControl.selectedSegmentTintColor = UIColor(resource: .snow)
        segmentControl.addTarget(self, action: #selector(segmentValueDidChanged), for: .valueChanged)
    }
    
    private func configureSectionImageView(image: UIImage = .quote) {
        let image = image
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.heavyGray.withAlphaComponent(0.12))
        
        sectionImageView.image = image
        sectionImageView.contentMode = .scaleAspectFit
    }
    
    private func configureNotFoundImageView() {
        notFoundImageView.image = UIImage(resource: .turtle)
        notFoundImageView.contentMode = .scaleAspectFit
        notFoundStackView.isHidden = true
    }
    
    private func configureFetchButton() {
        setFetchButtonTitle(title: K.fetchButtonQuoteTitle)
        fetchButton.backgroundColor = .black
        fetchButton.layer.cornerRadius = 16
        fetchButton.layer.borderWidth = 1
        fetchButton.layer.borderColor = UIColor.systemCyan.cgColor
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed), for: .touchUpInside)
    }
    
    private func setFetchButtonTitle(title: String) {
        fetchButton.customizeTitle(
            title: title,
            font: UIFont(name: K.fontMontserrat400, size: 18),
            foregroundColor: UIColor.white,
            shadowColor: UIColor.systemCyan,
            shadowRadius: 5
        )
    }
}

extension CategoriesViewController {
    // MARK: - Setup Delegates

    private func setupDelegates() {
        categoryViewModel.delegate = self
        searchBar.delegate = self
        pickerView.delegate = self
    }
}

extension CategoriesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryViewModel.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryViewModel.categories[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryViewModel.selectedCategory = categoryViewModel.categories[row]
    }
}

extension CategoriesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        categoryViewModel.filterCategories(with: searchText)
        
        if categoryViewModel.categories.isEmpty {
            pickerView.isHidden = true
            notFoundStackView.isHidden = false
        } else {
            pickerView.isHidden = false
            notFoundStackView.isHidden = true
        }
    }
}

extension CategoriesViewController: CategoryViewModelDelegate {
    func didUpdateCategories() {
        pickerView.reloadAllComponents()
    }
}

extension CategoriesViewController {
    // MARK: - Actions
    
    @objc private func fetchButtonPressed(_ sender: UIButton) {
        let quoteVC = QuoteViewController()
        let quoteViewModel = QuoteViewModel()
        
        quoteVC.viewModel = quoteViewModel
        quoteVC.viewModel?.delegate = quoteVC
        quoteVC.viewModel?.sectionType = sectionType
        
        if sectionType == .quote {
            let selectedCategory = categoryViewModel.selectedCategory.rawValue
            quoteVC.viewModel?.quoteCategory = selectedCategory
            quoteVC.viewModel?.sectionType = sectionType
        }
        
        self.present(quoteVC, animated: true)
    }
    
    @objc private func segmentValueDidChanged(_ sender: UISegmentedControl) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            sectionType = .quote
            configureSectionImageView(image: .quote)
            sectionLabel.text = K.quoteSectionTitle
            setFetchButtonTitle(title: K.fetchButtonQuoteTitle)
            isSearchBarHidden = false
            isPickerViewHidden = false
            
            if categoryViewModel.categories.isEmpty {
                notFoundStackView.isHidden = false
            }
        case 1:
            sectionType = .joke
            configureSectionImageView(image: .joke)
            sectionLabel.text = K.jokesSectionTitle
            
            setFetchButtonTitle(title: K.fetchButtonJokeTitle)
            isPickerViewHidden = true
            isSearchBarHidden = true
            notFoundStackView.isHidden = true
        case 2:
            sectionType = .chuck
            configureSectionImageView(image: .chuck)
            sectionLabel.text = K.chuckSectionTitle
            setFetchButtonTitle(title: K.fetchButtonChuckTitle)
            isSearchBarHidden = true
            isPickerViewHidden = true
            notFoundStackView.isHidden = true
        default:
            break
        }
        
        updateSectionLabelConstraints()
    }
}

extension CategoriesViewController {
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        setupSearchBarConstraints()
        setupSegmentControlConstraints()
        setupSectionImageViewConstraints()
        setupSectionLabelConstraints()
        setupPickerViewConstraints()
        setupNotFoundStackViewConstraints()
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
    
    private func setupNotFoundStackViewConstraints() {
        notFoundStackView.snp.makeConstraints { make in
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

private struct Metrics {
    static let searchBarHeight: CGFloat = 44.0
    static let pickerViewHeight: CGFloat = 216.0
    static let sectionImageHeight: CGFloat = 85.0
    static let notFoundImageHeight: CGFloat = 50.0
    static let fetchButtonHeight: CGFloat = 50.0
    
    static let quotesTitleOffsetTop: CGFloat = -18
    static let jokesTitleOffsetTop: CGFloat = -12
    static let chuckTitleOffsetTop: CGFloat = -4
    
    init () {}
}
