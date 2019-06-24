//
//  NewsTable.swift
//  Weather
//
//  Created by admin on 09/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class NewsTable: Object  {
    @objc dynamic var newsId : Double = 0.0
    @objc dynamic var date : Double = 0.0
    @objc dynamic var text : String = ""
    @objc dynamic var type : String = ""
    @objc dynamic var url : String = ""
    @objc dynamic var video : String = ""
    @objc dynamic var comments : Int = 0
    @objc dynamic var like : Int = 0
    @objc dynamic var repost : Int = 0
    @objc dynamic var views : Int = 0
    @objc dynamic var groupId : Double = 0.0
    @objc dynamic var gropuName : String = ""
    @objc dynamic var imageGroup : String = ""
}




