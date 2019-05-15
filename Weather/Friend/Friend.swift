//
//  Friend.swift
//  Weather
//
//  Created by admin on 08/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//


import UIKit
import Alamofire


class FriendsResponse : Decodable {
    let response : Items
    
    
  
}
class Items: Decodable {
    let items : [FriendsArray]
}


class FriendsArray: Decodable {
    
    var firstName = ""
    var lastName = ""
    var photoId = ""
        enum CodingKeys: String, CodingKey {
            case first_name
            case last_name
            case photo_50
        }
    
    convenience required init (from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.firstName = try values.decode(String.self, forKey: .first_name)
        self.lastName = try values.decode(String.self, forKey: .last_name)
        self.photoId = try values.decode(String.self, forKey: .photo_50)
        
    }

  
}







