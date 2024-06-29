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
    
    // MARK: - Private enums
    private enum StorageErrors: Error {
        case alreadyExists
    }
    
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
    func saveQuote(text: String, author: String, category: String, completion: @escaping (Error?) -> Void) {
        let id = text.hashed()
        
        if entityExists(entityType: QuoteCD.self, id) {
            completion(StorageErrors.alreadyExists)
            return
        }
        
        saveEntity(entityType: QuoteCD.self) { quote in
            quote.text = text
            quote.author = author
            quote.category = category
            quote.id = text.hashed()
        }
        completion(nil)
    }
    
    // MARK: - Save Joke
    func saveJoke(text: String, completion: @escaping (Error?) -> Void) {
        let id = text.hashed()
        
        if entityExists(entityType: JokeCD.self, id) {
            completion(StorageErrors.alreadyExists)
            return
        }
        
        saveEntity(entityType: JokeCD.self) { joke in
            joke.text = text
            joke.id = text.hashed()
        }
        completion(nil)
    }
    
    // MARK: - Save Chuck Norris Joke
    func saveChuckJoke(text: String, completion: @escaping (Error?) -> Void) {
        let id = text.hashed()
        
        if entityExists(entityType: ChuckJokeCD.self, id) {
            completion(StorageErrors.alreadyExists)
            return
        }
        
        saveEntity(entityType: ChuckJokeCD.self) { chuckJoke in
            chuckJoke.text = text
            chuckJoke.id = text.hashed()
        }
        completion(nil)
    }
    
    private init() {}
}

// MARK: - Entity Exists
extension QuoteManager {
    private func entityExists<T: NSManagedObject>(entityType: T.Type, _ id: String) -> Bool {
        let context = storage.viewContext
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        request.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            return false
        }
    }
}

// MARK: - Fetch Quotes
extension QuoteManager {
    func fetchQuotes(completion: @escaping (Result<[Quote], Error>) -> Void) {
        let context = storage.backgroundContext
        
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
        let context = storage.backgroundContext
        
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
        let context = storage.backgroundContext
        
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

// MARK: - Delete Generic Entity
extension QuoteManager {
    private func deleteEntity<T: NSManagedObject>(entityType: T.Type, _ id: String, completion: @escaping (Error?) -> Void) {
        let context = storage.backgroundContext
        let request = NSFetchRequest<T>(entityName: String(describing: entityType))
        request.predicate = NSPredicate(format: "id == %@", id)
        
        context.perform {
            do {
                let results = try context.fetch(request)
                
                for object in results {
                    context.delete(object)
                }
                
                self.storage.saveContext(context)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
}

// MARK: - Delete Quote
extension QuoteManager {
    func deleteQuote(withId id: String) {
        deleteEntity(entityType: QuoteCD.self, id) { error in
            if let error {
                print("Failed to delete quote with ID \(id): \(error)")
            }
        }
    }
}

// MARK: - Delete Joke
extension QuoteManager {
    func deleteJoke(withId id: String) {
        deleteEntity(entityType: JokeCD.self, id) { error in
            if let error {
                print("Failed to delete joke with ID \(id): \(error)")
            }
        }
    }
}

// MARK: - Delete C.N. Joke
extension QuoteManager {
    func deleteChuckJoke(withId id: String) {
        deleteEntity(entityType: ChuckJokeCD.self, id) { error in
            if let error {
                print("Failed to delete C.N. joke with ID \(id): \(error)")
            }
        }
    }
}
