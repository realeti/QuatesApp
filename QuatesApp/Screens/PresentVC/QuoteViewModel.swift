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
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            switch self.sectionType {
            case .quote:
                guard let quote else { return }
                self.storage.saveQuote(
                    text: quote.quote,
                    author: quote.author,
                    category: quote.category
                )
            case .joke:
                guard let joke else { return }
                self.storage.saveJoke(text: joke.joke)
            case .chucknorris:
                guard let chuckNorrisJoke else { return }
                self.storage.saveChuckJoke(text: chuckNorrisJoke.joke)
            }
            
            self.delegate?.didSavedData()
        }
    }
}
