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

class ArticlesManager {      
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    var errorMessage = ""
    var articles = [Article]()
    
    func parseData(_ data: Data) -> [Article]? {
        do {
            let rawFeed = try decoder.decode(NewsSource.self, from: data)
            //print("TOTAL",rawFeed.totalResults)
            return rawFeed.articles
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
            print(errorMessage)
            return []
        }
    }
    
    func getResults(from url: URL, completion: @escaping ([Article]) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error ) in
            guard let data = data else { return }
            let articles = self.parseData(data)
            completion(articles ?? [])
        }.resume()
    }
    
    func parsePublishers(_ data: Data) -> [Sources]? {
        do {
            let rawFeed = try decoder.decode(NewsPublishers.self, from: data)
            return rawFeed.sources
        } catch let decodeError as NSError {
            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
            return []
        }
    }
    func getPublishers(from url: URL, completion: @escaping ([Sources]) -> ()) {
        URLSession.shared.dataTask(with: url) { (data, response, error ) in
            guard let data = data else { return }
            let articles = self.parsePublishers(data)
            completion(articles ?? [])
        }.resume()
    }
    
//    private func decodeJSON<T: Codable>(_ data: Data) -> T? {
//        do {
//            let decodedData = try decoder.decode(T.self, from: data)
//            return decodedData
//        } catch {
//            return nil
//        }
//    }
}
