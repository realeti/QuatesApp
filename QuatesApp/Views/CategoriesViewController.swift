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
        searchBar.backgroundColor = .white
        searchBar.placeholder = K.searchPlaceholder
        return searchBar
    }()
    
    private let quoteImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(resource: .quote)
        
        imageView.image = UIImage(resource: .quote)
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.heavyGray.withAlphaComponent(0.1))
        
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let categoriesLabel: UILabel = {
        let label = UILabel()
        label.text = K.categoriesTitle
        label.font = UIFont(name: K.fontNeueMachina, size: 36)
        label.numberOfLines = 2
        return label
    }()
    
    private let pickerView = UIPickerView()
    private let fetchButton = UIButton(type: .system)
    
    // MARK: - View Model
    let quoteViewModel = QuoteViewModel()
    let categoryViewModel = CategoryViewModel()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configureUI()
        setupDelegates()
        setupConstraints()
    }
    
    // MARK: - Set Views
    private func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(quoteImageView)
        view.addSubview(categoriesLabel)
        view.addSubview(pickerView)
        view.addSubview(fetchButton)
        
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension CategoriesViewController {
    // MARK: - Configure UI

    private func configureUI() {
        view.backgroundColor = .white
        configureFetchButton()
    }
    
    private func configureFetchButton() {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.systemCyan
        shadow.shadowBlurRadius = 5
        
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont(name: K.fontNeueMachina, size: 19) ?? UIFont.systemFont(ofSize: 19),
            .foregroundColor: UIColor.white,
            .shadow: shadow
        ]
        
        let attributesString = NSAttributedString(string: K.fetchButtonTitle, attributes: attributes)
        
        fetchButton.setAttributedTitle(attributesString, for: .normal)
        fetchButton.backgroundColor = .label
        fetchButton.layer.cornerRadius = 16
        fetchButton.layer.borderWidth = 1
        fetchButton.layer.borderColor = UIColor.systemCyan.cgColor
    }
}

extension CategoriesViewController {
    // MARK: - Setup Delegates

    private func setupDelegates() {
        categoryViewModel.delegate = self
        quoteViewModel.delegate = self
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
        let selectedCategory = categoryViewModel.selectedCategory.rawValue
        quoteViewModel.fetchQuote(for: selectedCategory)
    }
}

extension CategoriesViewController: QuoteViewModelDelegate {
    func didFetchQuote(_ quote: Quote) {
        DispatchQueue.main.async { [weak self] in
            let quoteVC = QuoteViewController()
            quoteVC.quote = quote
            self?.present(quoteVC, animated: true)
        }
    }
    
    func didFailFetchingQuote(_ error: any Error) {
        DispatchQueue.main.async { [weak self] in
            print(error.localizedDescription)
        }
    }
}

extension CategoriesViewController {
    // MARK: - Setup Constraints
    
    private func setupConstraints() {
        setupSearchBarConstraints()
        setupQuoteImageViewConstraints()
        setupCategoriesLabelConstraints()
        setupPickerViewConstraints()
        setupFetchButtonConstraints()
    }
    
    private func setupSearchBarConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    private func setupQuoteImageViewConstraints() {
        quoteImageView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.equalTo(categoriesLabel.snp.leading).offset(22)
            make.width.height.equalTo(85)
        }
    }
    
    private func setupCategoriesLabelConstraints() {
        categoriesLabel.snp.makeConstraints { make in
            make.top.equalTo(quoteImageView.snp.bottom).offset(-18)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(25)
        }
    }
    
    private func setupPickerViewConstraints() {
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(categoriesLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
    
    private func setupFetchButtonConstraints() {
        fetchButton.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
    }
}
