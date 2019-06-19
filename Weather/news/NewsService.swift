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

class NewsService {
    // базовый URL сервиса
    let baseUrl = "https://api.vk.com"
    // ключ для доступа к сервису

    func loadNewsData(typeImage: String,token: String,completion: @escaping () -> Void ){
        let path = "/method/newsfeed.get"
        let parameters: Parameters = [
            "filters":"post",
            "count": "4",
            "access_token": token,
            "v": "5.95"
        ]
        
        // составляем URL из базового адреса сервиса и конкретного пути к ресурсу
        let url = baseUrl+path

        Alamofire.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            let news = try! JSONDecoder().decode(NewsResponse.self, from: data).response
            print(news)
            var array = news.items
            var newsGroup = news.groups
//            var arrayNews = news.items
//            var arrayGroup = news.groups
//            print(arrayNews)
            array.forEach {$0.photoType = typeImage}
            self.saveNewsData(array,newsGroup,typeImage: typeImage)
            
            completion()
            
        }
        
    }
    func saveNewsData(_ news: [NewsArray],_ newsGroup: [GroupsNewsArray],typeImage:String){
        do {
            let realm = try Realm()
            let oldNews = realm.objects(NewsArray.self).filter("photoType == %@",typeImage)
            let groupNews = realm.objects(GroupsNewsArray.self)
            realm.beginWrite()
            realm.delete(oldNews)
            realm.delete(groupNews)
            realm.add(news)
            realm.add(newsGroup)
            try realm.commitWrite()
            print(realm.configuration.fileURL)
        }catch{
            print(error)
        }
    }
    
}

