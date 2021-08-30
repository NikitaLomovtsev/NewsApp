//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 26.08.2021.
//

import UIKit
import RealmSwift
import AudioToolbox



class NewsTableViewCell: UITableViewCell {
    
//MARK: Outlets
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var publishedAtLbl: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var saveDoneBtn: UIButton!

//MARK: Properties
    weak var viewController: UIViewController?
    var items: Results<SavedData>!
    var data: [Article]!
    let realm = try! Realm()
    //UserDefaults id for reversing Realm data
    var bookmarksId: Int {
        get{
            return UserDefaults.standard.integer(forKey: "bookmarksId")
        }
        set{
            let newBookmarksId =  bookmarksId + newValue
            UserDefaults.standard.set(newBookmarksId, forKey: "bookmarksId")
        }
    }
    
//MARK: Vibrate
    func vibrate(){
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
    }
    
//MARK: Share button
    @IBAction func shareBtnAction(_ sender: Any) {
        vibrate()
        let shareItem: [Any] = [URL(string: data[saveBtn.tag].url)!]
        let avc = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        viewController?.present(avc, animated: true, completion: nil)
    }
    
//MARK: Save button
    @IBAction func saveBtnAction(_ sender: Any) {
        vibrate()
        saveBtn.isHidden = true
        saveDoneBtn.isHidden = false
        let task = SavedData()
        task.title = data[saveBtn.tag].title
        task.publishedAt = String(data[saveBtn.tag].publishedAt.map({$0 == "T" || $0 == "Z" ? " " : $0}).dropLast(4))
        task.url = data[saveBtn.tag].url
        task.author = data[saveBtn.tag].author ?? "NONAME"
        task.urlToImage = data[saveBtn.tag].urlToImage
        //UserDefaults id for reversed realm
        task.bookmarksId = self.bookmarksId
        self.bookmarksId += 1
            try! self.realm.write {
                self.realm.add(task)
            }
    }
    
//MARK: SaveDone button
    @IBAction func saveDoneBtnAction(_ sender: Any) {
        vibrate()
        let savedItems = realm.objects(SavedData.self)
        //search for cell in realm
        for (index, _) in savedItems.enumerated(){
            if data[saveDoneBtn.tag].title == savedItems[index].title{
                //delete cell
                try! realm.write{
                    realm.delete(savedItems[index])
                }
                DispatchQueue.main.async {
                    self.saveBtn.isHidden = false
                    self.saveDoneBtn.isHidden = true
                }
            }
        }
    }
    
}



