//
//  QuoteManager.swift
//  QuatesApp
//
//  Created by Apple M1 on 26.06.2024.
//

import CoreData

final class QuoteManager {
    // MARK: - Singleton Instance
    static let shared = QuoteManager()
    
    // MARK: - Private Properties
    private let storage = CoreDataStack.shared
    
    // MARK: - Save Generic Entity
    private func saveEntity<T: NSManagedObject>(entityType: T.Type, configure: @escaping (T) -> Void) {
        let context = storage.viewContext
        context.perform {
            let entity = T(context: context)
            configure(entity)
            self.storage.saveContext(context)
        }
    }
    
    // MARK: - Save Quote
    func saveQuote(text: String, author: String, category: String) {
        saveEntity(entityType: QuoteCD.self) { quote in
            quote.text = text
            quote.author = author
            quote.category = category
        }
    }
    
    // MARK: - Save Joke
    func saveJoke(text: String) {
        saveEntity(entityType: JokeCD.self) { joke in
            joke.text = text
        }
    }
    
    // MARK: - Save Chuck Norris Joke
    func saveChuckJoke(text: String) {
        saveEntity(entityType: ChuckJokeCD.self) { chuckJoke in
            chuckJoke.text = text
        }
    }
    
    private init() {}
}

// MARK: - Fetch Quotes
extension QuoteManager {
    func fetchQuotes(completion: @escaping (Result<[Quote], Error>) -> Void) {
        let context = storage.newBackgroundContext()
        
        context.perform {
            let request: NSFetchRequest<QuoteCD> = QuoteCD.fetchRequest()
            
            do {
                let quoteObjects = try context.fetch(request)
                
                guard !quoteObjects.isEmpty else {
                    completion(.success([]))
                    return
                }
                
                let quotes = quoteObjects.map {
                    Quote(
                        quote: $0.text ?? "",
                        author: $0.author ?? "",
                        category: $0.category ?? ""
                    )
                }
                
                completion(.success(quotes))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Fetch Jokes
extension QuoteManager {
    func fetchJokes(completion: @escaping (Result<[Joke], Error>) -> Void) {
        let context = storage.newBackgroundContext()
        
        context.perform {
            let request: NSFetchRequest<JokeCD> = JokeCD.fetchRequest()
            
            do {
                let jokeObjects = try context.fetch(request)
                
                guard !jokeObjects.isEmpty else {
                    completion(.success([]))
                    return
                }
                
                let jokes = jokeObjects.map {
                    Joke(joke: $0.text ?? "")
                }
                
                completion(.success(jokes))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Fetch Chuck Norris Jokes
extension QuoteManager {
    func fetchChuckJokes(completion: @escaping (Result<[ChuckNorrisJoke], Error>) -> Void) {
        let context = storage.newBackgroundContext()
        
        context.perform {
            let request: NSFetchRequest<ChuckJokeCD> = ChuckJokeCD.fetchRequest()
            
            do {
                let chuckJokeObjects = try context.fetch(request)
                
                guard !chuckJokeObjects.isEmpty else {
                    completion(.success([]))
                    return
                }
                
                let chuckJokes = chuckJokeObjects.map {
                    ChuckNorrisJoke(joke: $0.text ?? "")
                }
                
                completion(.success(chuckJokes))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
