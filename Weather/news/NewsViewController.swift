//
//  NewsViewController.swift
//  Weather
//
//  Created by admin on 09/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import RealmSwift

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!


    
    let typeImage = "q"
    let newsServise = NewsService()
    var newsArray = [NewsTable]()
    var newsGroup = [GroupsNewsArray]()
    var arrayOne = [NewsTable]()
    var notif: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        loadNewsRealm()
        tableView.reloadData()
        

//        newsServise.loadNewsData(token: "86f426bcfee27d44f1c0ded0d5dd20e7722901b98c31336f33fcf7c7419c7526b4ef8b71dcd12aa7a7b39") { [weak self]  in
//
//            //self?.newsArray = (newsArray)
//
//        }
        
   
        //tableView.estimatedRowHeight = 357.0
        //tableView.rowHeight = UITableView.automaticDimension
    
    }
    func loadNewsRealm(){
        do{
            let realm = try Realm()
            let news = realm.objects(NewsTable.self)
            let newsGroups = realm.objects(GroupsNewsArray.self)
            let image = realm.objects(SizeImage.self).filter("type == %@", "q")
            print(news.count)
            self.newsArray = Array(news)
            self.newsGroup = Array(newsGroups)

            
        }catch{
            print("error")
            
        }
    }
    
    
}
extension NewsViewController : UITableViewDataSource , UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        var news : NewsTable
        news = newsArray[indexPath.row]




        let queue = DispatchQueue.global(qos: .utility)
        let imageURL = NSURL(string: news.imageGroup)
        var imagePhotoGroup = URL(string: news.video)
        var imageNews = URL(string: news.url)


       
        
    
        
       let queueImage = DispatchQueue.global(qos: .userInitiated)
        queue.async {
            if let data = try? Data(contentsOf: imageURL as! URL ){
                DispatchQueue.main.async {
                    cell.imageViewAvatar.image = UIImage(data: data)
                    //cell.imageNews.image = UIImage(data: data)
                }
            }
//            if let datas = try? Data(contentsOf: imageURL as! URL ){
//                DispatchQueue.main.async {
//                    cell.photoImageView.image = UIImage(data: datas)
//                    //cell.imageViewAvatar.image = UIImage(data: data)
//                }
//            }
            
            
        }
        queueImage.async {
            if let dataImage = try? Data(contentsOf: imagePhotoGroup ?? imageNews as! URL ){
                DispatchQueue.main.async {
                    cell.imageNews.image = UIImage(data: dataImage)
                }
            }
        }
        cell.viewCountLabel.text = "\(news.views)"
        cell.repostCountLabel.text = "\(news.repost)"
        cell.commtntCountLabel.text = "\(news.comments)"

        cell.labelView.text = news.gropuName

        cell.imageViewAvatar.layer.cornerRadius = 30
        cell.imageViewAvatar.layer.masksToBounds = true
        cell.photoView.layer.cornerRadius = 40
        cell.photoView.layer.shadowOpacity = 0.5
        cell.newsTextFild.text = news.text
        cell.imageNews.contentMode = UIView.ContentMode.scaleToFill


        
        return cell
    }
    
    
}
