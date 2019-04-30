//
//  NewsViewController.swift
//  Weather
//
//  Created by admin on 09/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var arrayNews = [
        NewsTable.init(name: "Audi Club", imageAvatar: UIImage(named: "audiAvatar")!, text: "Последнее время Audi неустанно заваливает новинками мировой рынок. На Женевском салоне состоялась презентация нового кросс-купе Q4. Правда, сюда приехал электромобиль Q4 e-tron. Но внешне версия с бензиновым двигателем будет не сильно отличаться от электрокара. Поэтому посмотрим на машину поближе.", imagePhoto: UIImage(named: "audiImage")!),NewsTable.init(name: "Bmv Club", imageAvatar: UIImage(named: "bmv")!, text: "Очень мощный и быстрый седан BMW впервые в истории получил полноприводную трансмиссию. На разгон до 100 км/ч M5 требуется 3,4 секунды – это лучший результат в истории баварской марки", imagePhoto: UIImage(named: "BMW-X8")!)
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
     
        
        //tableView.estimatedRowHeight = 357.0
        //tableView.rowHeight = UITableView.automaticDimension
    
    }
    
    
}
extension NewsViewController : UITableViewDataSource , UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayNews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTableViewCell", for: indexPath) as! NewsTableViewCell
        var news : NewsTable
        news = arrayNews[indexPath.row]
       
        cell.imageViewAvatar.image = news.imageAvatar
        cell.labelView.text = news.name
        cell.imageViewAvatar.layer.cornerRadius = 30
        cell.imageViewAvatar.layer.masksToBounds = true
        cell.photoView.layer.cornerRadius = 40
        cell.photoView.layer.shadowOpacity = 0.5
        //cell.labelView.layer.cornerRadius = 20
        cell.labelView.layer.shadowOpacity = 0.5
        cell.textNewsLabel?.numberOfLines = 0
        cell.textNewsLabel.text = news.text
        cell.photoImageView.contentMode = UIView.ContentMode.scaleToFill
        cell.photoImageView.image = news.imagePhoto
        
        
    
      
        
        
        return cell
    }
    
    
}
