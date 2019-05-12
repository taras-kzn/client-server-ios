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

class FriendServic {
    // базовый URL сервиса
    let baseUrl = "https://api.vk.com"
    // ключ для доступа к сервису
    let apiKey = "4077466b31867423d6d9bb3ea8211ad778549a409f3c1be8e70b8fbedda2d638b10ed3a667cc48f9137a4"
    
    func loadFriendsData(friends: String,completion: @escaping ([FriendsArray]) -> Void ){
        let path = "/method/friends.get"
        let parameters: Parameters = [
            "user_id": friends,
            "order": "hints",
            "count": "3",
            "fields": "domain,photo_50",
            "access_token": apiKey,
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
            completion(array)
            
        }
        
        
    }
}
