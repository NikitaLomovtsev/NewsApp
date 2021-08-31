//
//  TabBarController.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 27.08.2021.
//

import UIKit

class TabBarController: UITabBarController {
    @IBOutlet weak var newsTabBar: UITabBar!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsTabBar.layer.masksToBounds = true
        self.newsTabBar.layer.cornerRadius = 10
        self.newsTabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//        self.newsTabBar.isTranslucent = false
//        self.newsTabBar.backgroundColor = .black
    }
    


}


