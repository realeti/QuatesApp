//
//  QuoteViewModel.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

protocol QuoteModeling {
    var quote: Quote? { get }
    var joke: Joke? { get }
    var chuckNorrisJoke: ChuckNorrisJoke? { get }
    var sectionType: SectionType { get }
    
    func fetchData()
    func saveData()
}

protocol QuoteViewModelDelegate: AnyObject {
    func didFetchData(_ section: SectionType)
    func didFailFetching(_ error: Error)
    func didChangeLoadingState(isLoading: Bool)
    func didSavedData()
    func didFailSavedData(_ error: Error)
}

final class QuoteViewModel: QuoteModeling {
    // MARK: - Private Properties
    private let networkController = NetworkController()
    private lazy var storage = QuoteManager.shared
    
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
        DispatchQueue.global(qos: .background).async {
            switch self.sectionType {
            case .quote:
                guard let selectedCategory = self.quoteCategory else {
                    return
                }
                self.fetchQuote(for: selectedCategory)
            case .joke:
                self.fetchJoke()
            case .chucknorris:
                self.fetchChuckNorrisJoke()
            }
        }
    }
}

// MARK: - Fetch Quote
extension QuoteViewModel {
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
}

// MARK: - Fetch Joke
extension QuoteViewModel {
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
}

// MARK: - Fetch Chuck Norris Joke
extension QuoteViewModel {
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

// MARK: - Save Data
extension QuoteViewModel {
    func saveData() {
        switch sectionType {
        case .quote:
            guard let quote else { return }
            saveQuote(quote: quote)
        case .joke:
            guard let joke else { return }
            saveJoke(joke: joke)
        case .chucknorris:
            guard let chuckNorrisJoke else { return }
            saveChuckJoke(joke: chuckNorrisJoke)
        }
    }
}

// MARK: - Save Quote
extension QuoteViewModel {
    private func saveQuote(quote: Quote) {
        storage.saveQuote(
            text: quote.quote,
            author: quote.author,
            category: quote.category
        ) { [weak self] error in
            if let error {
                self?.delegate?.didFailSavedData(error)
                return
            }
            self?.delegate?.didSavedData()
        }
    }
}

// MARK: - Save Joke
extension QuoteViewModel {
    private func saveJoke(joke: Joke) {
        storage.saveJoke(text: joke.joke) { [weak self] error in
            if let error {
                self?.delegate?.didFailSavedData(error)
                return
            }
            self?.delegate?.didSavedData()
        }
    }
}

// MARK: - Save C.N. Joke
extension QuoteViewModel {
    private func saveChuckJoke(joke: ChuckNorrisJoke) {
        storage.saveChuckJoke(text: joke.joke) { [weak self] error in
            if let error {
                self?.delegate?.didFailSavedData(error)
                return
            }
            self?.delegate?.didSavedData()
        }
    }
}
