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
}

final class FavoritesViewModel: FavoritesModeling {
    var sectionType: SectionType = .quote
    var quotes: [Quote] = []
    var jokes: [Joke] = []
    var chuckJokes: [ChuckNorrisJoke] = []
    
    // MARK: - Private Properties
    private let storage = QuoteManager.shared
    
    // MARK: - Fetch Data
    func fetchData(completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        fetchQuotes {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchJokes {
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        fetchChuckJokes {
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
}

// MARK: - Fetch Quotes
extension FavoritesViewModel {
    private func fetchQuotes(completion: @escaping () -> Void) {
        storage.fetchQuotes { [weak self] result in
            defer { completion() }
            
            do {
                let quotes = try result.get()
                self?.quotes = quotes
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Fetch Jokes
extension FavoritesViewModel {
    private func fetchJokes(completion: @escaping () -> Void) {
        defer { completion() }
        
        storage.fetchJokes { [weak self] result in
            do {
                let jokes = try result.get()
                self?.jokes = jokes
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Fetch C.N. Jokes
extension FavoritesViewModel {
    private func fetchChuckJokes(completion: @escaping () -> Void) {
        defer { completion() }
        
        storage.fetchChuckJokes { [weak self] result in
            do {
                let chuckJokes = try result.get()
                self?.chuckJokes = chuckJokes
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
