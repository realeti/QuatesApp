//
//  CategoriesViewController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import UIKit

class CategoriesViewController: UIViewController {
    // MARK: - UI
    private let searchBar = UISearchBar()
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
        view.addSubview(pickerView)
        view.addSubview(fetchButton)
        
        fetchButton.addTarget(self, action: #selector(fetchButtonPressed), for: .touchUpInside)
    }
}

extension CategoriesViewController {
    // MARK: - Configure UI

    private func configureUI() {
        view.backgroundColor = .white
        configureSearchBar()
        configureFetchButton()
    }
    
    private func configureSearchBar() {
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .white
        searchBar.placeholder = K.searchPlaceholder
    }
    
    private func configureFetchButton() {
        fetchButton.setTitle(K.fetchButtonTitle, for: .normal)
        fetchButton.setTitleColor(.black, for: .normal)
        fetchButton.backgroundColor = .systemGray6
        fetchButton.layer.cornerRadius = 14
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
        setupPickerViewConstraints()
        setupFetchButtonConstraints()
    }
    
    private func setupSearchBarConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    private func setupPickerViewConstraints() {
        pickerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.center.equalToSuperview()
        }
    }
    
    private func setupFetchButtonConstraints() {
        fetchButton.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(25)
            make.height.equalTo(50)
        }
    }
}
