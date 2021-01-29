//
//  Endpoint.swift
//  NewsApp
//
//  Created by Satsishur on 29.01.2021.
//

import Foundation

enum Endpoint {
    case topHeadLines
    case everything
    case sources
    
    var baseURL:String { "https://newsapi.org/v2/"}
    
    func path() -> String {
        switch self {
        case .topHeadLines:
            return "top-headlines?"
        case .everything:
            return "everything?"
        case .sources:
            return "sources?"
        }
    }
}

enum Options: Int {
    case country = 0
    case search = 1
    case category = 2
    case source = 3
}
