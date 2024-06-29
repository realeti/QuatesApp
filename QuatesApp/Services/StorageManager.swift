//
//  StorageManager.swift
//  QuatesApp
//
//  Created by Apple M1 on 26.06.2024.
//

import CoreData

final class StorageManager {
    // MARK: - Singleton Instance
    static let shared = StorageManager()
    
    // MARK: - Private Properties
    private let storage = CoreDataStack.shared
    
    // MARK: - Private enums
    private enum StorageErrors: Error {
        case alreadyExists
    }
    
    // MARK: - Save Generic Entity
    private func saveEntity<T: NSManagedObject>(entityType: T.Type, configure: @escaping (T) -> Void) {
        let context = storage.backgroundContext
        
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
extension StorageManager {
    private func entityExists<T: NSManagedObject>(entityType: T.Type, _ id: String) -> Bool {
        let context = storage.backgroundContext
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

// MARK: - Fetch Entities
extension StorageManager {
    private func fetchEntities<T: NSManagedObject, U>(
        entityType: T.Type,
        configure: @escaping (T) -> U,
        completion: @escaping (Result<[U], Error>) -> Void
    ) {
        let context = storage.viewContext
        
        context.perform {
            let request = NSFetchRequest<T>(entityName: String(describing: entityType))
            
            do {
                let objects = try context.fetch(request)
                
                guard !objects.isEmpty else {
                    completion(.success([]))
                    return
                }
                
                let entities = objects.map { configure($0) }
                
                completion(.success(entities))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Fetch Quotes
extension StorageManager {
    func fetchQuotes(completion: @escaping (Result<[Quote], Error>) -> Void) {
        fetchEntities(entityType: QuoteCD.self, configure: { quoteCD in
            Quote(
                quote: quoteCD.text ?? "",
                author: quoteCD.author ?? "",
                category: quoteCD.category ?? ""
            )
        }, completion: completion)
    }
}

// MARK: - Fetch Jokes
extension StorageManager {
    func fetchJokes(completion: @escaping (Result<[Joke], Error>) -> Void) {
        fetchEntities(entityType: JokeCD.self, configure: { jokeCD in
            Joke(joke: jokeCD.text ?? "")
        }, completion: completion)
    }
}

// MARK: - Fetch C.N. jokes
extension StorageManager {
    func fetchChuckJokes(completion: @escaping (Result<[ChuckNorrisJoke], Error>) -> Void) {
        fetchEntities(entityType: ChuckJokeCD.self, configure: { chuckJokeCD in
            ChuckNorrisJoke(joke: chuckJokeCD.text ?? "")
        }, completion: completion)
    }
}

// MARK: - Delete Generic Entity
extension StorageManager {
    func deleteEntity<T: NSManagedObject>(entityType: T.Type, _ id: String, completion: @escaping (Error?) -> Void) {
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
