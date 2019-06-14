//
//  AllGroupsService.swift
//  Weather
//
//  Created by admin on 30/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import RealmSwift

class AllGroupService  {
    let baseUrl = "https://api.vk.com"
    
    
    func loadAllGroupData(token: String,completion: @escaping ([AllGroupArray]) -> Void ){
        let path = "/method/groups.getCatalog"
        let param : Parameters = [
            "category_id": "10",
            "access_token": token,
            "v": "5.95"
        ]
        let url = baseUrl+path
        
        Alamofire.request(url, method: .get, parameters: param).responseData { repsonse in
            guard let data = repsonse.value else { return }
            let allGroup = try! JSONDecoder().decode(AllGroupResponse.self, from: data).response
            var array = allGroup.items
            self.saveAllGroupData(array)
            completion(array)
            
        }
        
    }
    func saveAllGroupData(_ grops: [AllGroupArray]){
        do{
            let realm = try Realm()
            let oldGrops = realm.objects(AllGroupArray.self)
            realm.beginWrite()
            realm.delete(oldGrops)
            realm.add(grops)
            try realm.commitWrite()
            print(realm.configuration.fileURL)
            
        }catch{
            print("error")
            
        }
        
    }
    
    
}

