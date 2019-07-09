//
//  AllGoup.swift
//  Weather
//
//  Created by admin on 30/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

final class AllGroupResponse: Decodable {
    
    let response : ItemsAllGroup
}

final class ItemsAllGroup:  Decodable {
    
    let items : [AllGroupArray]
}

final class AllGroupArray: Object, Decodable {
    
    @objc dynamic var allGroupName = ""
    @objc dynamic var allGroupImage = ""
    
    private enum CodingKeys: String, CodingKey {
        case name
        case photo_50
    }

    convenience required init (from decoder: Decoder) throws {
        
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.allGroupName = try values.decode(String.self, forKey: .name)
        self.allGroupImage = try values.decode(String.self, forKey: .photo_50)

    }
}
