

import Foundation
import UIKit
import Alamofire
import RealmSwift


final class GroupService  {
    
    let baseUrl = "https://api.vk.com"

    func loadGroupData(idUser: String,token: String,completion: @escaping () -> Void ){
        let path = "/method/groups.get"
        let param : Parameters = [
            "user_id": idUser,
            "count": "45",
            "extended": "1",
            "access_token": token,
            "v": "5.95"
        ]
        
        let url = baseUrl+path
        
        Alamofire.request(url, method: .get, parameters: param).responseData { repsonse in
            guard let data = repsonse.value else { return }
            let group = try? JSONDecoder().decode(GroupResponse.self, from: data).response
            guard let array = group else {return}
            let ar = array.items
            ar.forEach {$0.userIdName = idUser}
            self.saveGroupData(ar, userId: idUser)
            completion()
        }

    }
    
    func saveGroupData(_ grops: [GroupArray], userId: String ){
        do{
            let realm = try Realm()
            let oldGrops = realm.objects(GroupArray.self).filter("userIdName == %@", userId)
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
