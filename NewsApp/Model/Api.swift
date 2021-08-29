//
//  Api.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 28.08.2021.
//

import Foundation

struct News: Decodable {
    let articles: [Article]
}

struct Article: Decodable{
    let title: String
    let publishedAt: String
    let urlToImage: String
    let url: String
    let author: String?
    let description: String
    
}
