//
//  FavoritesViewModel.swift
//  QuatesApp
//
//  Created by Apple M1 on 25.06.2024.
//

import Foundation

protocol FavoritesModeling {
    var sectionType: SectionType { get }
    var quotes: [Quote] { get }
    var jokes: [Joke] { get }
    var chuckJokes: [ChuckNorrisJoke] { get }
    
    func fetchData(completion: @escaping () -> Void)
    func deleteData(withId id: String, completion: @escaping () -> Void)
}

protocol FavoritesViewModelDelegate: AnyObject {
    func didFailFetching(_ error: Error)
    func didFailDeleting(_ error: Error)
}

final class FavoritesViewModel: FavoritesModeling {
    var sectionType: SectionType = .quote
    var quotes: [Quote] = []
    var jokes: [Joke] = []
    var chuckJokes: [ChuckNorrisJoke] = []
    
    // MARK: - Private Properties
    private let storage = QuoteManager.shared
    
    // MARK: - Public Properties
    weak var delegate: FavoritesViewModelDelegate?
    
    // MARK: - Fetch Data
    func fetchData(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            let dispatchGroup = DispatchGroup()
            
            dispatchGroup.enter()
            self?.fetchQuotes {
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self?.fetchJokes {
                dispatchGroup.leave()
            }
            
            dispatchGroup.enter()
            self?.fetchChuckJokes {
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                completion()
            }
        }
    }
}

// MARK: - Fetch Quotes
extension FavoritesViewModel {
    private func fetchQuotes(completion: @escaping () -> Void) {
        self.storage.fetchQuotes { [weak self] result in
            defer { completion() }
            
            do {
                let quotes = try result.get()
                self?.quotes = quotes
            } catch {
                self?.delegate?.didFailFetching(error)
            }
        }
    }
}

// MARK: - Fetch Jokes
extension FavoritesViewModel {
    private func fetchJokes(completion: @escaping () -> Void) {
        self.storage.fetchJokes { [weak self] result in
            defer { completion() }
            
            do {
                let jokes = try result.get()
                self?.jokes = jokes
            } catch {
                self?.delegate?.didFailFetching(error)
            }
        }
    }
}

// MARK: - Fetch C.N. Jokes
extension FavoritesViewModel {
    private func fetchChuckJokes(completion: @escaping () -> Void) {
        self.storage.fetchChuckJokes { [weak self] result in
            defer { completion() }
            
            do {
                let chuckJokes = try result.get()
                self?.chuckJokes = chuckJokes
            } catch {
                self?.delegate?.didFailFetching(error)
            }
        }
    }
}

// MARK: - Delete Data
extension FavoritesViewModel {
    func deleteData(withId id: String, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self else { return }
            
            switch sectionType {
            case .quote:
                storage.deleteQuote(withId: id) { [weak self] error in
                    if let error {
                        self?.delegate?.didFailDeleting(error)
                        return
                    }
                    completion()
                }
            case .joke:
                storage.deleteJoke(withId: id) { [weak self] error in
                    if let error {
                        self?.delegate?.didFailDeleting(error)
                        return
                    }
                    completion()
                }
            case .chucknorris:
                storage.deleteChuckJoke(withId: id) { [weak self] error in
                    if let error {
                        self?.delegate?.didFailDeleting(error)
                        return
                    }
                    completion()
                }
            }
        }
        
    }
}
