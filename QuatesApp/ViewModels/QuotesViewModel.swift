//
//  QuotesViewModel.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

class QuotesViewModel {
    private var randomQuote: Quote?
    
    var displayedQuote: Quote? {
        return randomQuote
    }
    
    lazy var fetchingController = NetworkController()
    
    func fetchQuote(for category: String, completion: @escaping () -> Void) {
        fetchingController.loadQuote(category: category) { [weak self] result in
            do {
                let quoteData = try result.get()
                self?.randomQuote = quoteData
                completion()
            } catch {
                print("Error fetching quote: \(error)")
                completion()
            }
        }
    }
}
