//
//  ArticlesManager.swift
//  NewsApp
//
//  Created by Satsishur on 18.01.2021.
//

import Foundation

class ArticlesManager {    
    //MARK: Sorting Order Enums
    enum SortOptions: String {
        case relevancy // articles more closely related to q come first.
        case popularity // articles from popular sources and publishers come first.
        case publishedAt //newest articles come first.
    }

    let sortBy = URLQueryItem(name: "sortBy", value: SortOptions.publishedAt.rawValue) //should be an enum with options

    let secretAPIKey = URLQueryItem(name: "apiKey", value: "cc71c2c33a3142f79baf0a337e43c0b4")
    
    let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    var errorMessage = ""
    
    var articles = [Article]()
    
    func requestNews(endpoint: Endpoint,
                     country: String? = nil,
                     category: String? = nil,
                     source: String? = nil,
                     filter: String? = nil,
                     page: String? = nil) -> URL? {
        let path = endpoint.baseURL + endpoint.path()
        var url = URLComponents(string: path)
        if country != nil {
            let country = URLQueryItem(name: "country", value: country)
            url?.queryItems?.append(country)
        }
        if category != nil {
            let category = URLQueryItem(name: "category", value: category)
            url?.queryItems?.append(category)
        }
        if source != nil {
            let source = URLQueryItem(name: "sources", value: source)
            url?.queryItems?.append(source)
        }
        if filter != nil {
            let filter = URLQueryItem(name: "qInTitle", value: filter)
            url?.queryItems?.append(filter)
            url?.queryItems?.append(sortBy)
        }
        if page != nil {
            let page = URLQueryItem(name: "page", value: page)
            url?.queryItems?.append(page)
        }
        url?.queryItems?.append(secretAPIKey)
        return url?.url
    }
    
    func requestSources() -> URL? {
        let path = "https://newsapi.org/v2/sources?"
        var url = URLComponents(string: path)
        url?.queryItems?.append(secretAPIKey)
        print(url)
        return url?.url
    }
    
    func parseData(_ data: Data) -> [Article]? {
        do {
            let rawFeed = try decoder.decode(NewsSource.self, from: data)
            print("TOTAL",rawFeed.totalResults)
            //print(rawFeed.articles)
            return rawFeed.articles
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            return []
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return []
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return []
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return []
        } catch {
            print("error: ", error)
            return []
        }
//        } catch let decodeError as NSError {
//            errorMessage += "Decoder error: \(decodeError.localizedDescription)"
//            print(errorMessage)
//            return []
//        }
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
}

enum Endpoint {
    case topHeadLines
    case search
    case sources
    
    var baseURL:String { "https://newsapi.org/v2/"}
    
    func path() -> String {
        switch self {
        case .topHeadLines:
            return "top-headlines?"
        case .search:
            return "everything?"
        case .sources:
            return "sources?"
        }
    }
}
