//
//  ViewController.swift
//  NewsApp
//
//  Created by Никита Ломовцев on 26.08.2021.
//

import UIKit
import SafariServices
import RealmSwift


class ViewController: UIViewController {

//MARK: Outlets
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBackgroundView: UIView!
    @IBOutlet weak var topView: UIView!
    
//MARK: Properties
    let items = realm.objects(SavedData.self)
    var news: [Article] = []
    var searchText: String?
    let apiKey = "3033551a360a40a2ae9d42dfb3124d6c"
    let spinner = UIImageView()
    
//MARK: Setup View
    func setupView(){
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.layer.cornerRadius = 5
        searchTextField.tintColor = UIColor(red: 231/255, green: 178/255, blue: 127/255, alpha: 1)
        searchTextField.layer.borderWidth = 1.5
        searchTextField.layer.borderColor = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1).cgColor
        searchBackgroundView.layer.cornerRadius = 10
        searchBackgroundView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        downloadJSON(searchText: searchText ?? "")
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        tableView.refreshControl?.tintColor = UIColor.clear
    }
    
//MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        spinnerCreating()
        spinnerAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
//MARK: Spinner
    func spinnerCreating(){
        let width = CGFloat(40)
        let height = CGFloat(40)
        let x = (self.view.frame.size.width / 2) - width / 2
        let y = (self.view.frame.size.height / 2) - height / 2 - topView.frame.size.height
        spinner.frame = CGRect(x: x, y: y, width: width, height: height)
        spinner.image = UIImage(named: "spinner")
        tableView.addSubview(spinner)
        spinner.isHidden = true
    }
    
    func spinnerAnimation(){
        spinner.isHidden = false
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.fromValue = 0
        anim.toValue = CGFloat.pi*2
        anim.duration = 0.6
        anim.repeatCount = Float.infinity
        spinner.layer.add(anim, forKey: "transform.rotation")
    }
    
    func spinnerAnimationRemove(){
        spinner.layer.removeAllAnimations()
        spinner.isHidden = true
    }
    
//MARK: Pull to refresh
    @objc func didPullToRefresh(){
        downloadJSON(searchText: "")
        DispatchQueue.main.async {
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    
//MARK: Search
    @IBAction func done(_ sender: Any) {
        search()
    }
    
    @IBAction func searchBtn(_ sender: Any) {
        search()
    }
    
    func search(){
        searchText = searchTextField.text ?? ""
        searchText = searchText!.replacingOccurrences(of: " ", with: "")
        searchText = searchText!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        searchTextField.endEditing(true)
        downloadJSON(searchText: searchText!)
    }
    
//MARK: Download JSON
    func downloadJSON(searchText: String) -> (){
        news.removeAll()
        tableView.reloadData()
        spinnerAnimation()
        let url = URL(string: "https://newsapi.org/v2/everything?domains=yandex.ru&apiKey=\(apiKey)&q=\(searchText)")
        URLSession.shared.dataTask(with: url!) { data, response, error in
            if error == nil{
                do{
                    let newsArray = try JSONDecoder().decode(News.self, from: data!)
                    DispatchQueue.main.sync {
                        self.spinnerAnimationRemove()
                        self.news = newsArray.articles
                        self.tableView.reloadData()
                    }
                }catch{
                    print("JSON ERROR")
                }
            }
        }.resume()
    }
}

//MARK: Table View
extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        //cell properties
        cell.viewController = self
        let item = news[indexPath.row]
        let link = item.urlToImage
        cell.titleLbl.text = item.title
        cell.publishedAtLbl.text = String(item.publishedAt.map({$0 == "T" || $0 == "Z" ? " " : $0}).dropLast(4))
        cell.photoImageView.downloaded(from: link)
        cell.authorLbl.text = (item.author ?? "NONAME").uppercased()
        cell.descriptionLbl.text = item.description
        cell.saveBtn.tag = indexPath.row
        cell.saveDoneBtn.tag = indexPath.row
        cell.data = news
        
        //cell ui
        cell.cellBackgroundView.layer.cornerRadius = 10
        cell.photoImageView.layer.cornerRadius = 10
        cell.photoImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        //button dependencies
        cell.saveDoneBtn.isHidden = true
        if cell.saveDoneBtn.isHidden == false{
            cell.saveBtn.isHidden = true
        } else {
            cell.saveBtn.isHidden = false
        }
        
        //cell in memory check
        for (index, _) in items.enumerated(){
            if cell.titleLbl.text == items[index].title{
                cell.saveBtn.isHidden = true
                cell.saveDoneBtn.isHidden = false
            }
        }
        return cell
    }
    
//MARK:: SafariViewController
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = news[indexPath.row]
        let url = URL(string: item.url)
        let vc = SFSafariViewController(url: url!)
        present(vc, animated: true)
    }
}
