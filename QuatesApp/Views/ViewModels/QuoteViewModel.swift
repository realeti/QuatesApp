//
//  QuoteViewModel.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

protocol QuoteModeling {
    func fetchQuote(for category: String)
}

protocol QuoteViewModelDelegate: AnyObject {
    func didFetchQuote(_ quote: Quote)
    func didFailFetchingQuote(_ error: Error)
    func didChangeLoadingState(isLoading: Bool)
}

final class QuoteViewModel: QuoteModeling {
    lazy var fetchingController = NetworkController()
    weak var delegate: QuoteViewModelDelegate?
    
    func fetchQuote(for category: String) {
        delegate?.didChangeLoadingState(isLoading: true)
        
        fetchingController.loadQuote(category: category) { [weak self] result in
            self?.delegate?.didChangeLoadingState(isLoading: false)
            
            do {
                let quoteData = try result.get()
                self?.delegate?.didFetchQuote(quoteData)
            } catch {
                self?.delegate?.didFailFetchingQuote(error)
            }
        }
    }
}
