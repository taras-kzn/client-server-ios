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


final class FriendServic {
    
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
        
        let url = baseUrl+path

        Alamofire.request(url, method: .get, parameters: parameters).responseData { repsonse in
            guard let data = repsonse.value else { return }
            let friend = try? JSONDecoder().decode(FriendsResponse.self, from: data).response

            guard let array = friend else {return}
            let ar = array.items
            ar.forEach {$0.uesrIdName = userId}
            self.saveFriendsData(ar, userId: userId)
            completion()
        }
       
    }
    
    func saveFriendsData(_ friends: [FriendsArray], userId: String ){
        
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
   
}
