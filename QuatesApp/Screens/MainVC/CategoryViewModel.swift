//
//  CategoryViewModel.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

protocol CategoryModeling {
    var categories: [CategoryList] { get }
    var sectionType: SectionType { get }
    var selectedCategory: CategoryList { get }
    
    func filterCategories(with searchText: String)
}

protocol CategoryViewModelDelegate: AnyObject {
    func didUpdateCategories()
}

final class CategoryViewModel: CategoryModeling {
    // MARK: - Private Properties
    private let allCategories: [CategoryList] = CategoryList.allCases
    private(set) var categories: [CategoryList] = CategoryList.allCases
    
    // MARK: - Public properties
    weak var delegate: CategoryViewModelDelegate?
    
    var sectionType: SectionType = .quote
    var selectedCategory: CategoryList = .age
    
    // MARK: - Category Filter
    func filterCategories(with searchText: String) {
        if searchText.isEmpty {
            categories = allCategories
        } else {
            categories = allCategories.filter { $0.rawValue.lowercased().contains(searchText.lowercased()) }
        }
        delegate?.didUpdateCategories()
    }
}
