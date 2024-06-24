//
//  QuoteViewModel.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

protocol QuoteModeling {
    func fetchData()
}

protocol QuoteViewModelDelegate: AnyObject {
    func didFetchQuote(_ quote: Quote)
    func didFetchJoke(_ joke: Joke)
    func didFetchChuckNorrisJoke(_ joke: ChuckNorrisJoke)
    func didFailFetching(_ error: Error)
    func didChangeLoadingState(isLoading: Bool)
}

final class QuoteViewModel: QuoteModeling {
    lazy var fetchingController = NetworkController()
    weak var delegate: QuoteViewModelDelegate?
    
    var sectionType: SectionType
    var quoteCategory: String?
    
    init(sectionType: SectionType, quoteCategory: String? = nil) {
        self.sectionType = sectionType
        self.quoteCategory = quoteCategory
    }
    
    func fetchData() {
        switch sectionType {
        case .quote:
            guard let selectedCategory = quoteCategory else {
                return
            }
            fetchQuote(for: selectedCategory)
        case .joke:
            fetchJoke()
        case .chucknorris:
            fetchChuckNorrisJoke()
        }
    }
    
    private func fetchQuote(for category: String) {
        delegate?.didChangeLoadingState(isLoading: true)
        
        fetchingController.loadQuote(category: category) { [weak self] result in
            self?.delegate?.didChangeLoadingState(isLoading: false)
            
            do {
                let quoteData = try result.get()
                self?.delegate?.didFetchQuote(quoteData)
            } catch {
                self?.delegate?.didFailFetching(error)
            }
        }
    }
    
    private func fetchJoke() {
        delegate?.didChangeLoadingState(isLoading: true)
        
        fetchingController.loadJoke() { [weak self] result in
            self?.delegate?.didChangeLoadingState(isLoading: false)
            
            do {
                let jokeData = try result.get()
                self?.delegate?.didFetchJoke(jokeData)
            } catch {
                self?.delegate?.didFailFetching(error)
            }
        }
    }
    
    private func fetchChuckNorrisJoke() {
        delegate?.didChangeLoadingState(isLoading: true)
        
        fetchingController.loadChuckNorrisJoke() { [weak self] result in
            self?.delegate?.didChangeLoadingState(isLoading: false)
            
            do {
                let jokeData = try result.get()
                self?.delegate?.didFetchChuckNorrisJoke(jokeData)
            } catch {
                self?.delegate?.didFailFetching(error)
            }
        }
    }
}
