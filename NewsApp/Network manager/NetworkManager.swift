//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 30.08.2021.
//

import UIKit

class NetworkManager{
    
    static let shared = NetworkManager()
    
    func getNews(searchText: String, apiKey: String, completion: @escaping (Result <[Article], Error>) -> Void){
        let url = URL(string: "https://newsapi.org/v2/everything?domains=yandex.ru&apiKey=\(apiKey)&q=\(searchText)")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil{
                do{
                    let newsArray = try JSONDecoder().decode(News.self, from: data!)
                    completion(.success(newsArray.articles))
                }catch{
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFill) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
