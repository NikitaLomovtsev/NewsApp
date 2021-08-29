//
//  BookmarksViewController.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 27.08.2021.
//

import UIKit
import RealmSwift
import SafariServices


let realm = try! Realm()

class BookmarksViewController: UIViewController {

//MARK: Outlets
    @IBOutlet weak var bookmarksTableView: UITableView!
    
//MARK: Properties
    let items = realm.objects(SavedData.self).sorted(byKeyPath: "bookmarksId", ascending: false)
 
//MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarksTableView.dataSource = self
        bookmarksTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bookmarksTableView.reloadData()
    }

}
//MARK: TableView
extension BookmarksViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = bookmarksTableView.dequeueReusableCell(withIdentifier: "BookmarksTableViewCell", for: indexPath) as! BookmarksTableViewCell
        
        //cell properties
        cell.bookmarksViewController = self
        let item = items[indexPath.row]
        cell.titleLbl.text = item.title
        cell.bookmarksImageView.downloaded(from: item.urlToImage)
        cell.authorLbl.text = item.author.uppercased()
        cell.publishedAtLbl.text = item.publishedAt
        cell.shareBtn.tag = indexPath.row
        
        //cell ui
        cell.cellBackgroundView.layer.cornerRadius = 10
        cell.bookmarksImageView.layer.cornerRadius = 10
        cell.bookmarksImageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
        
        return cell
    }
    
//MARK: SwipeActions delete from Realm
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let editingRow = items[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
            try! realm.write {
                realm.delete(editingRow)
                self.bookmarksTableView.reloadData()
            }
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }
    
//MARK:: SafariViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let url = URL(string: item.url)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true)
    }
}

