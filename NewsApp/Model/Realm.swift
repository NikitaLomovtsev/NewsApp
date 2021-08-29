//
//  Realm.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 28.08.2021.
//

import UIKit
import RealmSwift

class SavedData: Object{
    @objc dynamic var title = String()
    @objc dynamic var publishedAt = String()
    @objc dynamic var url = String()
    @objc dynamic var author = String()
    @objc dynamic var urlToImage = String()
    @objc dynamic var bookmarksId = Int()
}
