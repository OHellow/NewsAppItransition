//
//  URL_Constructor.swift
//  NewsApp
//
//  Created by Satsishur on 29.01.2021.
//

import Foundation

class URL_Constructor {
    enum SortOptions: String {
        case relevancy
        case popularity
        case publishedAt
    }

    let sortBy = URLQueryItem(name: "sortBy", value: SortOptions.publishedAt.rawValue)

    let secretAPIKey = URLQueryItem(name: "apiKey", value: "54bf385a589f4134b70b269e2abe9974")
    
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
        //print("URL",url?.url)
        return url?.url
    }
    
    func requestSources() -> URL? {
        let path = "https://newsapi.org/v2/sources?"
        var url = URLComponents(string: path)
        url?.queryItems?.append(secretAPIKey)
        return url?.url
    }
}
