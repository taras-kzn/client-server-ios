//
//  PhotoViewController.swift
//  Weather
//
//  Created by admin on 08/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class PhotoViewController: UIViewController {
    
    var photoColection = [PersonGroup(photo: UIImage(named: "santaKlaus")!, name: "Праздники")]
    
    var friendServiceCoolection = FriendServic()
    var friendArrayColecction = [FriendsArray]()
    

    @IBOutlet weak var collectionView: UICollectionView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        userDefaulsSave()
        loadStringUserDefauls()
 //       loadSessionToken()

        
//        friendServiceCoolection.loadFriendsData(userId: userID, token: Session.instance.token) { [weak self] friendsArray in
//            // сохраняем полученные данные в массиве, чтобы коллекция могла получить к ним доступ
//            self?.friendArrayColecction = (friendsArray)
//            self?.collectionView.reloadData()
//           
//            
//        }
        
   

    }
    
}

extension PhotoViewController : UICollectionViewDataSource{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return friendArrayColecction.count
       
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollection", for: indexPath) as! PhotoCollectionViewCell
//        let collection = photoColection[indexPath.row]
//
//        cell.photoCell.image = collection.photo
//        cell.namedc.text = collection.name
        let friends = friendArrayColecction[indexPath.row]
        cell.namedc.text = friends.firstName + "" + friends.lastName
        fileSystemSave(image: friends.photoId)
        loadImage(cellImage: cell.photoCell)
        
        return cell
    }
    private func fileSystemSave(image: String) {
        let fileUrl = loadImageToCache().appendingPathComponent("friend.png")
        let url = URL(string: image)
        let dataUrl = try! Data(contentsOf: url!)
        
        guard let data = UIImage(data: dataUrl)?.pngData() else {return}
        
        do {
            try data.write(to: fileUrl)
            
        }catch{
            print(error)
            return
        }
        print("image save")
    }
    private func loadImage(cellImage: UIImageView) {
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

}
