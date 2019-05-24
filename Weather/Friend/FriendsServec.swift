//
//  FriendsServec.swift
//  Weather
//
//  Created by admin on 09/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import Alamofire
import UIKit
import RealmSwift


class FriendServic {
    // базовый URL сервиса
    let baseUrl = "https://api.vk.com"
    // ключ для доступа к сервису
    
    
//    let apiKey  =  "46b726ceefcff6554885d9c8556cbc9afa7e2ef51abfb8ac300ab14879053661bbf26d3e92af80f6d3e97"
    
    
    func loadFriendsData(friends: String,token: String,completion: @escaping ([FriendsArray]) -> Void ){
        let path = "/method/friends.get"
        let parameters: Parameters = [
            "user_id": friends,
            "order": "hints",
            "count": "10",
            "fields": "domain,photo_100",
            "access_token": token,
            "v": "5.95"
        ]
        
        // составляем URL из базового адреса сервиса и конкретного пути к ресурсу
        let url = baseUrl+path
        
        //делаем запрос
//        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
//            print(repsonse.value)
//        }
        //делаем запрос
        Alamofire.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            let friend = try! JSONDecoder().decode(FriendsResponse.self, from: data).response
            var array = friend.items
            self.saveFriendsData(array)
            
            completion(array)
            
        }
       
    }
    func saveFriendsData(_ friends: [FriendsArray] ){
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(friends)
            try realm.commitWrite()
        }catch{
            print(error)
        }
    }
   
}
