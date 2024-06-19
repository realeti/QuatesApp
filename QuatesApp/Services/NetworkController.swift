//
//  NetworkController.swift
//  QuatesApp
//
//  Created by Apple M1 on 18.06.2024.
//

import Foundation

protocol QuoteLoading {
    func loadQuote(category: String, completion: @escaping (Result<Quote, Error>) -> Void)
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
    
    let session = URLSession.shared
    lazy var decoder = JSONDecoder()
    
    let headers = [
        "accept": "application/json",
        "X-Api-Key": "PDRpJeNaA9Gcq11+FRunkA==NMd6tiN48hUMCcYD"
    ]
    
    let baseUrlString = "https://api.api-ninjas.com/v1/quotes"
    
    private func loadData(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = baseUrlString.appending(path)
        self.loadData(fullPath: urlString, completion: completion)
    }
    
    private func loadData(fullPath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: fullPath) else {
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
        let path = "?category=\(category)"
        loadData(path: path) { response in
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
}
