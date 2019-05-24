//
//  Friend.swift
//  Weather
//
//  Created by admin on 08/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//


import UIKit
import Alamofire
import RealmSwift


class FriendsResponse : Decodable {
    let response : Items
    
    
  
}
class Items: Decodable {
    let items : [FriendsArray]
}


class FriendsArray: Object, Decodable {
    
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var photoId = ""
            enum CodingKeys: String, CodingKey {
                case first_name
                case last_name
                case photo_100
            }
    
    convenience required init (from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try values.decode(String.self, forKey: .first_name)
        self.lastName = try values.decode(String.self, forKey: .last_name)
        self.photoId = try values.decode(String.self, forKey: .photo_100)
        
    }

  
}







