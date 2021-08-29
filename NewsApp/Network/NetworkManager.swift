//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 29.08.2021.
//

import Foundation


class NetworkManager {
    
    var newsArray: News!
    
    func downloadJSON(_ searchText: String, _ apiKey: String) -> News {
        let url = URL(string: "https://newsapi.org/v2/everything?domains=yandex.ru&apiKey=\(apiKey)&q=\(searchText)")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil{
                do{
                    let array = try JSONDecoder().decode(News.self, from: data!)
                    DispatchQueue.main.async {
                        self.newsArray = array
                        
                    }
                }catch{
                    print("JSON ERROR")
                }
            }
        }.resume()
       
            
            return newsArray
        
        
    
    }
    
}
