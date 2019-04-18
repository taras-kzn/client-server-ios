//
//  PhotoViewController.swift
//  Weather
//
//  Created by admin on 08/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    var photoColection = [PersonGroup(photo: UIImage(named: "santaKlaus")!, name: "Праздники")]

    @IBOutlet weak var collectionView: UICollectionView!
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self

    }
    
}

extension PhotoViewController : UICollectionViewDataSource{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return photoColection.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollection", for: indexPath) as! PhotoCollectionViewCell
        let collection = photoColection[indexPath.row]
        cell.photoCell.image = collection.photo
        cell.namedc.text = collection.name
        
        
        return cell
    }
    
  
}
