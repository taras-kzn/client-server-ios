//
//  Group.swift
//  Weather
//
//  Created by admin on 17/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

final class GroupResponse: Decodable {
    
    let response : ItemsGroup
}

final class ItemsGroup:  Decodable {
    
    let items : [GroupArray]
}

final class GroupArray: Object, Decodable {
    
    @objc dynamic var gropuName = ""
    @objc dynamic var imageGroup = ""
    @objc dynamic var userName = ""
    @objc dynamic var userIdName = ""
    
        private enum CodingKeys: String,CodingKey{
            case name
            case photo_50
        }
    
        private enum UserName: String {
            case adel
        }
    
        private enum UserIdName: String {
            case adelId = "3559315"
        }
    
    convenience required init (from decoder: Decoder) throws {
        self.init()
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.gropuName = try values.decode(String.self, forKey: .name)
        self.imageGroup = try values.decode(String.self, forKey: .photo_50)
        self.userName = UserName.adel.rawValue
        self.userIdName = UserIdName.adelId.rawValue
    }
}






