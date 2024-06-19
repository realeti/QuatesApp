//
//  CategoryViewModel.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

protocol CategoryModeling {
    var categories: [CategoryList] { get }
    func filterCategories(with searchText: String)
}

protocol CategoryViewModelDelegate: AnyObject {
    func didUpdateCategories()
}

class CategoryViewModel: CategoryModeling {
    private let allCategories: [CategoryList] = CategoryList.allCases
    private(set) var categories: [CategoryList] = CategoryList.allCases
    var selectedCategory: CategoryList?
    
    weak var delegate: CategoryViewModelDelegate?
    
    func filterCategories(with searchText: String) {
        if searchText.isEmpty {
            categories = allCategories
        } else {
            categories = allCategories.filter { $0.rawValue.lowercased().contains(searchText.lowercased()) }
        }
        
        delegate?.didUpdateCategories()
    }
}
