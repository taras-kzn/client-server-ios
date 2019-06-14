//
//  NewsRealm.swift
//  Weather
//
//  Created by admin on 31/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import UIKit








class NewsResponse: Decodable {
    let response: NewsItems
}

class NewsItems: Decodable {
    let items: [NewsArray]
    let groups: [GroupsNewsArray]
}
class NewsArray: Object, Decodable {
    @objc dynamic var newsId = 0.0
    @objc dynamic var date = 0.0
    @objc dynamic var text = ""
    //@objc static var photo = ""
    @objc dynamic var photoType = ""
    @objc dynamic var image = ""
    @objc dynamic var comments = 0
    @objc dynamic var like = 0
    @objc dynamic var repost = 0
    @objc dynamic var views = 0
    
//    enum UserIdName: String{
//        case idAdel = "3639061"
//    }
        enum CodingKeys: String,CodingKey {
            case source_id
            case date = "date"
            case text
            case attachments
            case comments
            case likes
            case reposts
            case views
        }
        enum AttachmentsKeys: String,CodingKey {
            case photo
            case sizes

        }
        enum ImageKeys: String,CodingKey{
            case type
            case url
        }
        enum CommentsKeys: String,CodingKey {
            case count
        }
        enum LikeKeys: String,CodingKey {
            case count
        }
        enum RepostKeys: String,CodingKey{
            case count
        }
        enum ViewsKeys: String,CodingKey{
            case count
        }
    
    convenience required init(from decoder: Decoder) throws {
        self.init()
        
        let valuse = try decoder.container(keyedBy: CodingKeys.self)
        self.newsId = try valuse.decode(Double.self, forKey: .source_id)
        self.date = try valuse.decode(Double.self, forKey: .date)
        self.text = try valuse.decode(String.self, forKey: .text)
        
        var attachmentsValues = try valuse.nestedUnkeyedContainer(forKey: .attachments)
        let firstAttachmentsValues = try attachmentsValues.nestedContainer(keyedBy: AttachmentsKeys.self)
        let photoValues = try firstAttachmentsValues.nestedContainer(keyedBy: AttachmentsKeys.self, forKey: .photo)
        var sizeValue = try photoValues.nestedUnkeyedContainer(forKey: .sizes )
        let firstImge = try sizeValue.nestedContainer(keyedBy: ImageKeys.self)
        self.photoType = try firstImge.decode(String.self, forKey: .type)
        self.image = try firstImge.decode(String.self, forKey: .url)
        
        let commentsValue = try valuse.nestedContainer(keyedBy: CommentsKeys.self, forKey: .comments)
        self.comments = try commentsValue.decode(Int.self, forKey: .count)
        
        let likeValue = try valuse.nestedContainer(keyedBy: LikeKeys.self, forKey: .likes)
        self.like = try likeValue.decode(Int.self, forKey: .count)
        
        let repostValue = try valuse.nestedContainer(keyedBy: RepostKeys.self, forKey: .reposts)
        self.repost = try repostValue.decode(Int.self, forKey: .count)
        
        let viewsValue = try valuse.nestedContainer(keyedBy: ViewsKeys.self, forKey: .views)
        self.views = try viewsValue.decode(Int.self, forKey: .count)
        

        
    }

    
}
class GroupsNewsArray: Object,Decodable {
    @objc dynamic var groupId = 0.0
    @objc dynamic var gropuName = ""
    @objc dynamic var imageGroup = ""
        
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case photo_50
            
        }
    convenience required init (from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.groupId = try values.decode(Double.self, forKey: .id)
        self.gropuName = try values.decode(String.self, forKey: .name)
        self.imageGroup = try values.decode(String.self, forKey: .photo_50)
    }
}


