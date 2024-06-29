//
//  MainViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import UIKit

final class MainViewController: UIViewController {
    // MARK: - Private Properties
    private var mainView: MainView!
    
    private var isSearchBarHidden: Bool = false {
        didSet {
            mainView.searchBar.snp.updateConstraints { make in
                make.height.equalTo(isSearchBarHidden ? 0 : MainView.Metrics.searchBarHeight)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.mainView.layoutIfNeeded()
            }
        }
    }
    
    private var isPickerViewHidden: Bool = false {
        didSet {
            mainView.pickerView.snp.updateConstraints { make in
                make.height.equalTo(isPickerViewHidden ? 0 : MainView.Metrics.pickerViewHeight)
            }
            
            if !viewModel.categories.isEmpty {
                mainView.pickerView.isHidden = (isPickerViewHidden ? true : false)
            }
            
            UIView.animate(withDuration: 0.3) {
                self.mainView.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - View Model
    private let viewModel = CategoryViewModel()
    
    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
        
        mainView = MainView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupDelegates()
        setupTapGesture()
    }
    
    // MARK: - Setup TapGesture
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        mainView.addGestureRecognizer(tapGesture)
    }
}

// MARK: - Configure UI
extension MainViewController {
    private func configureUI() {
        configureSectionImageView(image: .quote)
        setCustomButtonTitle(title: K.fetchButtonQuoteTitle)
        
        mainView.segmentControl.addTarget(self, action: #selector(segmentValueDidChanged), for: .valueChanged)
        mainView.fetchButton.addTarget(self, action: #selector(fetchButtonPressed), for: .touchUpInside)
    }
    
    private func configureSectionImageView(image: UIImage) {
        let image = image
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.heavyGray.withAlphaComponent(0.12))
        
        mainView.sectionImageView.image = image
        mainView.sectionImageView.contentMode = .scaleAspectFit
    }
    
    private func setCustomButtonTitle(title: String) {
        mainView.fetchButton.customizeTitle(
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
        mainView.updateSectionLabelConstraints(for: section)
    }
    
    private func applyConfiguration(_ config: SectionConfiguration) {
        configureSectionImageView(image: config.image)
        mainView.sectionLabel.text = config.title
        setCustomButtonTitle(title: config.buttonTitle)
        isSearchBarHidden = config.isSearchBarHidden
        isPickerViewHidden = config.isPickerViewHidden
        mainView.emptyContentStackView.isHidden = config.isEmptyContentViewHidden
    }
}

// MARK: - Setup Delegates
extension MainViewController {
    private func setupDelegates() {
        viewModel.delegate = self
        mainView.searchBar.delegate = self
        mainView.pickerView.delegate = self
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
            mainView.pickerView.isHidden = true
            mainView.emptyContentStackView.isHidden = false
        } else {
            mainView.pickerView.isHidden = false
            mainView.emptyContentStackView.isHidden = true
        }
    }
}

// MARK: - Category ViewModel Delegate
extension MainViewController: CategoryViewModelDelegate {
    func didUpdateCategories() {
        mainView.pickerView.reloadAllComponents()
    }
}

// MARK: - Actions
extension MainViewController {
    @objc private func hideKeyboard() {
        if mainView.searchBar.isFirstResponder {
            mainView.endEditing(true)
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
