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
    
    func loadFriendsData(userId: String,token: String,completion: @escaping () -> Void ){
        let path = "/method/friends.get"
        let parameters: Parameters = [
            "user_id": userId,
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
            array.forEach {$0.uesrIdName = userId}
            self.saveFriendsData(array, userId: userId)
            
            completion()
            
        }
       
    }
    func saveFriendsData(_ friends: [FriendsArray], userId: String ){

        let queue = DispatchQueue.global(qos:.utility)
        queue.async {
            do {
                let realm = try Realm()
                let oldFriends = realm.objects(FriendsArray.self).filter("uesrIdName == %@", userId )
                realm.beginWrite()
                realm.delete(oldFriends)
                realm.add(friends)
                try realm.commitWrite()
                print(realm.configuration.fileURL)
            }catch{
                print(error)
            }
        }
//        do {
//            let realm = try Realm()
//            let oldFriends = realm.objects(FriendsArray.self).filter("uesrIdName == %@", userId )
//            realm.beginWrite()
//            realm.delete(oldFriends)
//            realm.add(friends)
//            try realm.commitWrite()
//            print(realm.configuration.fileURL)
//        }catch{
//            print(error)
//        }

    }
   
}
