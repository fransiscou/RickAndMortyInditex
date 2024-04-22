//
//  HomeServices.swift
//  RickMortyReview
//
//  Created by Fran Sarró on 22/4/24.
//

import Foundation

protocol HomeServicesProtocol {
    func getCharacters(completion: @escaping (Result<Characters, HomeServiceError>) -> ())
}

enum HomeServiceError: Error {
    case url
    case data
}

class HomeServices: HomeServicesProtocol {
    func getCharacters(completion: @escaping (Result<Characters, HomeServiceError>) -> ()) {
        guard let url = URL(string: HomeConstants.charactersEndpoint) else {
            return completion(.failure(.url))
        }
        
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return completion(.failure(.data))
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid response")
                return completion(.failure(.data))
            }
            
            guard let data = data else {
                print("No data received")
                return completion(.failure(.data))
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Characters.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
                completion(.failure(.data))
            }
        }
        
        task.resume()
    }
}
