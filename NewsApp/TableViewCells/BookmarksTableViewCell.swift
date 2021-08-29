//
//  BookmarksTableViewCell.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 28.08.2021.
//

import UIKit

class BookmarksTableViewCell: UITableViewCell {
    
    var bookmarksViewController: UIViewController?
    let items = realm.objects(SavedData.self).sorted(byKeyPath: "bookmarksId", ascending: false)
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var bookmarksCell: UIView!
    @IBOutlet weak var bookmarksImageView: UIImageView!
    @IBOutlet weak var publishedAtLbl: UILabel!
    @IBOutlet weak var authorLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    
    @IBAction func shareBtnAction(_ sender: Any) {
        let shareItem: [Any] = [URL(string: items[shareBtn.tag].url)!]
        let avc = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
        bookmarksViewController?.present(avc, animated: true, completion: nil)
    }
    

}
