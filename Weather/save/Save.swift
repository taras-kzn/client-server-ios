//
//  Save.swift
//  Weather
//
//  Created by admin on 17/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import UIKit
import SwiftKeychainWrapper

var userID = ""

func userDefaulsSave() {
    UserDefaults.standard.set("3639061", forKey:"idAdel")
}
func loadStringUserDefauls(){
    userID = UserDefaults.standard.string(forKey: "idAdel")!
    print(userID)
    
}
func loadSessionToken(){
    Session.instance.token = KeychainWrapper.standard.string(forKey: "token")!
}
func loadImageToCache() -> URL {
    return FileManager.default.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)[0]
}
func loadImage(cellImage: UIImageView) {
    let fileUrl = loadImageToCache().appendingPathComponent("friend.png")
    
    do{
        let imageData = try Data.init(contentsOf: fileUrl)
        cellImage.image = UIImage(data: imageData)
    }catch{
        print("error")
        return
    }
    print("LoadImage")
}
