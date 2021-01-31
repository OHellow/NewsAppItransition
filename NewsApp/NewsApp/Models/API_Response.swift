//
//  ArticleModels.swift
//  NewsApp
//
//  Created by Satsishur on 18.01.2021.
//

import Foundation

struct NewsSource: Codable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

struct Article: Codable {
    let source: Source?
    let author: String?
    let title: String?
    let articleDescription: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: Date?

    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case articleDescription = "description"
        case url
        case urlToImage
        case publishedAt
    }
}

struct Source: Codable {
    let id: String?
    let name: String?
}




struct NewsPublishers: Codable {
    let status: String?
    let sources: [Sources]?
}

struct Sources: Codable {
    let id: String?
    let name: String?
    let description: String?
    let url: String?
    let category: String?
    let language: String?
    let country: String?
}
