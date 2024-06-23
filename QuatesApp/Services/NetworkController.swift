//
//  NetworkController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

protocol QuoteLoading {
    func loadQuote(category: String, completion: @escaping (Result<Quote, Error>) -> Void)
    func loadJoke(completion: @escaping (Result<Joke, Error>) -> Void)
    func loadChuckNorrisJoke(completion: @escaping (Result<ChuckNorrisJoke, Error>) -> Void)
}

enum NetErrors: Error {
    case statusCode(Int)
    case invalidURL
    case invalidData
    case badResponse
    case wrongDecode
    case connectionProblem
}

final class NetworkController: QuoteLoading {
    private enum APIEndpoint {
        case quote(category: String)
        case joke
        case chucknorris
        
        var path: String {
            switch self {
            case .quote(let category):
                return "quotes?category=\(category)"
            case .joke:
                return "jokes"
            case .chucknorris:
                return "chucknorris"
            }
        }
    }
    
    let session = URLSession.shared
    lazy var decoder = JSONDecoder()
    
    private let headers = [
        "accept": "application/json",
        "X-Api-Key": "PDRpJeNaA9Gcq11+FRunkA==NMd6tiN48hUMCcYD"
    ]
    
    private let baseUrlString = "https://api.api-ninjas.com/v1/"
    
    private func loadData(endpoint: APIEndpoint, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = baseUrlString.appending(endpoint.path)
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NetErrors.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(NetErrors.connectionProblem))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetErrors.badResponse))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (200..<300).contains(statusCode) else {
                completion(.failure(NetErrors.statusCode(statusCode)))
                return
            }
            
            guard let data else {
                completion(.failure(NetErrors.invalidData))
                return
            }
            completion(.success(data))
        }
        
        dataTask.resume()
    }
    
    func loadQuote(category: String, completion: @escaping (Result<Quote, Error>) -> Void) {
        let endpoint = APIEndpoint.quote(category: category)
        loadData(endpoint: endpoint) { response in
            do {
                let data = try response.get()
                let responseData = try self.decoder.decode([QuoteDTO].self, from: data)
                
                guard let quoteDTO = responseData.first else {
                    completion(.failure(NetErrors.wrongDecode))
                    return
                }
                
                let resultQuote = Quote(
                    quote: quoteDTO.quote,
                    author: quoteDTO.author,
                    category: quoteDTO.category
                )
                
                completion(.success(resultQuote))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func loadJoke(completion: @escaping (Result<Joke, Error>) -> Void) {
        let endpoint = APIEndpoint.joke
        loadData(endpoint: endpoint) { response in
            do {
                let data = try response.get()
                let responseData = try self.decoder.decode([JokeDTO].self, from: data)
                
                guard let jokeDTO = responseData.first else {
                    completion(.failure(NetErrors.wrongDecode))
                    return
                }
                
                let resultJoke = Joke(joke: jokeDTO.joke)
                completion(.success(resultJoke))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func loadChuckNorrisJoke(completion: @escaping (Result<ChuckNorrisJoke, Error>) -> Void) {
        let endpoint = APIEndpoint.chucknorris
        loadData(endpoint: endpoint) { response in
            do {
                let data = try response.get()
                let responseData = try self.decoder.decode(ChuckNorrisJokeDTO.self, from: data)
                let resultJoke = ChuckNorrisJoke(joke: responseData.joke)
                completion(.success(resultJoke))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
