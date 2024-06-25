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
    func didFetchData(_ section: SectionType)
    func didFailFetching(_ error: Error)
    func didChangeLoadingState(isLoading: Bool)
}

final class QuoteViewModel: QuoteModeling {
    // MARK: - Private Properties
    private lazy var networkController = NetworkController()
    
    private(set) var quote: Quote?
    private(set) var joke: Joke?
    private(set) var chuckNorrisJoke: ChuckNorrisJoke?
    
    private(set) var sectionType: SectionType
    private var quoteCategory: String?
    
    // MARK: - Public Properties
    weak var delegate: QuoteViewModelDelegate?
    
    // MARK: - Init
    init(sectionType: SectionType, quoteCategory: String? = nil) {
        self.sectionType = sectionType
        self.quoteCategory = quoteCategory
    }
    
    // MARK: - Fetch Data
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
    
    // MARK: - Fetch Quote
    private func fetchQuote(for category: String) {
        delegate?.didChangeLoadingState(isLoading: true)
        
        networkController.loadQuote(category: category) { [weak self] result in
            self?.delegate?.didChangeLoadingState(isLoading: false)
            
            do {
                let quoteData = try result.get()
                self?.quote = quoteData
                self?.delegate?.didFetchData(.quote)
            } catch {
                self?.delegate?.didFailFetching(error)
            }
        }
    }
    
    // MARK: - Fetch Joke
    private func fetchJoke() {
        delegate?.didChangeLoadingState(isLoading: true)
        
        networkController.loadJoke() { [weak self] result in
            self?.delegate?.didChangeLoadingState(isLoading: false)
            
            do {
                let jokeData = try result.get()
                self?.joke = jokeData
                self?.delegate?.didFetchData(.joke)
            } catch {
                self?.delegate?.didFailFetching(error)
            }
        }
    }
    
    // MARK: - Fetch Chuck Norris Joke
    private func fetchChuckNorrisJoke() {
        delegate?.didChangeLoadingState(isLoading: true)
        
        networkController.loadChuckNorrisJoke() { [weak self] result in
            self?.delegate?.didChangeLoadingState(isLoading: false)
            
            do {
                let jokeData = try result.get()
                self?.chuckNorrisJoke = jokeData
                self?.delegate?.didFetchData(.chucknorris)
            } catch {
                self?.delegate?.didFailFetching(error)
            }
        }
    }
}
