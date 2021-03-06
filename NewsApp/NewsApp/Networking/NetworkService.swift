//
//  ArticlesManager.swift
//  NewsApp
//
//  Created by Satsishur on 18.01.2021.
//

import Foundation

enum SearchForNewsError: Error {
    case networkingError
}

class NetworkService {      
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    var errorMessage = ""
    var articles = [Article]()
    
    func makeNewsRequest<T: Codable>(from url: URL, completion: @escaping ((Result<T, SearchForNewsError>)) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error ) in
            guard let data = data else {
                completion(.failure(.networkingError))
                return
            }
            DispatchQueue.global().async {
                let news: T? = self.decodeJSON(data)
                if let news = news {
                    completion(.success(news))
                } else {
                    completion(.failure(.networkingError))
                }
            }
        }.resume()
    }
    
    private func decodeJSON<T: Codable>(_ data: Data) -> T? {
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            return nil
        }
        
    }
}
//    func parseArticles(_ data: Data) -> [Article]? {
//        do {
//            let rawFeed = try decoder.decode(NewsResponse.self, from: data)
//            //print("TOTAL",rawFeed.totalResults)
//            return rawFeed.articles
//        } catch let decodeError as NSError {
//            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
//            print(errorMessage)
//            return []
//        }
//    }
//
//    func fetchArticles(from url: URL, completion: @escaping ((Result<[Article], SearchForNewsError>)) -> ()) {
//        URLSession.shared.dataTask(with: url) { (data, response, error ) in
//            guard let data = data else { return }
//            if let articles = self.parseArticles(data) {
//            completion(.success(articles))
//            } else {
//                completion(.failure(.networkingError))
//            }
//        }.resume()
//    }
//
//    func parseSources(_ data: Data) -> [Sources]? {
//        do {
//            let rawFeed = try decoder.decode(NewsPublishers.self, from: data)
//            return rawFeed.sources
//        } catch let decodeError as NSError {
//            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
//            return []
//        }
//    }
//
//    func fetchSources(from url: URL, completion: @escaping ((Result<[Sources], SearchForNewsError>)) -> ()) {
//        URLSession.shared.dataTask(with: url) { (data, response, error ) in
//            guard let data = data else { return }
//            if let sources = self.parseSources(data) {
//                completion(.success(sources))
//            } else {
//                completion(.failure(.networkingError))
//            }
//        }.resume()
//    }
    


