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

    var arrayNews = [
        NewsTable.init(name: "Audi Club", imageAvatar: UIImage(named: "audiAvatar")!, text: "Последнее время Audi неустанно заваливает новинками мировой рынок. На Женевском салоне состоялась презентация нового кросс-купе Q4. Правда, сюда приехал электромобиль Q4 e-tron. Но внешне версия с бензиновым двигателем будет не сильно отличаться от электрокара. Поэтому посмотрим на машину поближе.", imagePhoto: UIImage(named: "audiImage")!),NewsTable.init(name: "Bmv Club", imageAvatar: UIImage(named: "bmv")!, text: "Очень мощный и быстрый седан BMW впервые в истории получил полноприводную трансмиссию. На разгон до 100 км/ч M5 требуется 3,4 секунды – это лучший результат в истории баварской марки", imagePhoto: UIImage(named: "BMW-X8")!)
    ]
    
    let typeImage = "q"
    let newsServise = NewsService()
    var newsArray = [NewsArray]()
    var newsGroup = [GroupsNewsArray]()
    var notif: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

        loadNewsRealm()
        tableView.reloadData()
        
     
//        newsServise.loadNewsData(typeImage: typeImage,token: "1d948e24352f2d496a1d229a23ce720cba0087261f3da9101becebdaedce19716b654483e7a2314ceeb5b") { [weak self]  in
//
//            //self?.newsArray = (newsArray)
//
//        }
        
        print(newsArray)
        //tableView.estimatedRowHeight = 357.0
        //tableView.rowHeight = UITableView.automaticDimension
    
    }
    func loadNewsRealm(){
        do{
            let realm = try Realm()
            let news = realm.objects(NewsArray.self).filter("photoType == %@",typeImage)
            let newsGroups = realm.objects(GroupsNewsArray.self)
            print(news.count)
            self.newsArray = Array(news)
            self.newsGroup = Array(newsGroups)
//            notif = news.observe{ [weak self] changes in
//                switch changes {
//
//                case .initial:
//                    self?.tableView.reloadData()
//                case .update(_, let deletions, let insertions, let modifications):
//                    self?.tableView.beginUpdates()
//                    self?.tableView.performBatchUpdates({self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: (self?.newsArray.count)!)}),with: .automatic)
//                        self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: (self?.newsArray.count)!)}),with: .automatic)
//                        self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: (self?.newsArray.count)!)}),with: .automatic)
//                        print(deletions,modifications,insertions)
//
//                    }, completion: {_ in
//                        print("update")
//                    })
//                    self?.tableView.endUpdates()
//                case .error(let error):
//                    print(error)
//                }
//                print("изминения прошли")
//
//            }
            
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
        var news : NewsArray
        var newsGroupS : GroupsNewsArray
        newsGroupS = newsGroup[indexPath.row]
        news = newsArray[indexPath.row]
        

        
        let queue = DispatchQueue.global(qos: .utility)
        let imageURL = NSURL(string: newsGroupS.imageGroup)
        let imagePhotoGroup = URL(string: news.image)
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
            if let dataImage = try? Data(contentsOf: imagePhotoGroup!){
                DispatchQueue.main.async {
                    cell.imageNews.image = UIImage(data: dataImage)
                }
            }
        }
        cell.viewCountLabel.text = "\(news.views)"
        cell.repostCountLabel.text = "\(news.repost)"
        cell.commtntCountLabel.text = "\(news.comments)"
     
        cell.labelView.text = newsGroupS.gropuName
        
        cell.imageViewAvatar.layer.cornerRadius = 30
        cell.imageViewAvatar.layer.masksToBounds = true
        cell.photoView.layer.cornerRadius = 40
        cell.photoView.layer.shadowOpacity = 0.5
        cell.newsTextFild.text = news.text
        cell.imageNews.contentMode = UIView.ContentMode.scaleToFill
        //cell.photoImageView.image = news.imagePhoto
        
        
    
      
        
        
        return cell
    }
    
    
}
