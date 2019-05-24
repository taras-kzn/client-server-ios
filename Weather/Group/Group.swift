//
//  Group.swift
//  Weather
//
//  Created by admin on 17/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit

class GroupResponse: Decodable {
    let response : ItemsGroup
}

class ItemsGroup: Decodable {
    let items : [GroupArray]
}

class GroupArray: Decodable {
    var gropuName = ""
    var imageGroup = ""
        enum CodingKeys: String,CodingKey{
            case name
            case photo_50
        }
    convenience required init (from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.gropuName = try values.decode(String.self, forKey: .name)
        self.imageGroup = try values.decode(String.self, forKey: .photo_50)
    }
}





