//
//  NewsService.swift
//  Weather
//
//  Created by admin on 17/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import UIKit

final class NewsService {
    // базовый URL сервиса
    let baseUrl = "https://api.vk.com"
    // ключ для доступа к сервису
    func loadNewsData(token: String,completion: @escaping () -> Void ){
        let path = "/method/newsfeed.get"
        let parameters: Parameters = [
            "filters":"post",
            "count": "5",
            "access_token": token,
            "v": "5.95"
        ]
        // составляем URL из базового адреса сервиса и конкретного пути к ресурсу
        let url = baseUrl+path

        Alamofire.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            let news = try! JSONDecoder().decode(NewsResponse.self, from: data).response
            let array = news.items
            let newsGroup = news.groups
            var arrayNews = [SizeImage]()
            var indexPath = IndexPath()
            var oneArray = [NewsTable]()
            let queu = DispatchQueue.global(qos: .utility)
            queu.async {
                for a in array{
                    let one = NewsTable()
                    one.newsId = a.newsId
                    one.comments = a.comments
                    one.like = a.like
                    one.repost = a.repost
                    one.text = a.text
                    one.views = a.views
                    one.video = a.video
                    oneArray.append(one)
                    for s in a.size{
                        if s.type == "q"{
                            one.type = s.type
                            one.url = s.url
                        }
                        for g in newsGroup {
                            if "\(one.newsId)" == "\(g.groupId)" || "\(one.newsId)" == "-\(g.groupId)"{
                                one.gropuName = g.gropuName
                                one.groupId = g.groupId
                                one.imageGroup = g.imageGroup
                            }
                        }
                    }
                }
            }

            print(array)
            self.saveNewsData(array,newsGroup,oneArray)
            completion()
        }
    }
    
    func saveNewsData(_ news: [NewsArray],_ newsGroup: [GroupsNewsArray],_ oneArray: [NewsTable]){
        
        let queu = DispatchQueue.global(qos: .utility)
        do {
            let realm = try Realm()
            let oldNews = realm.objects(NewsArray.self)
            let groupNews = realm.objects(GroupsNewsArray.self)
            let newsArray = realm.objects(NewsTable.self)
            realm.beginWrite()
            realm.delete(oldNews)
            realm.delete(groupNews)
            realm.delete(newsArray)
            realm.add(news)
            realm.add(newsGroup)
            realm.add(oneArray)
            try realm.commitWrite()
            print(realm.configuration.fileURL)
        }catch{
            print(error)
        }
    }
    
}

