//
//  AllGroupViewCell.swift
//  Weather
//
//  Created by admin on 07/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class AllGroupViewCell: UITableViewCell {



    @IBOutlet weak var photoCell: UIImageView!
    @IBOutlet weak var groupName: UILabel!
    

    @IBOutlet weak var viewPhotoCell: UIView!
    
    func setPerson(_ person: PersonGroup){
        self.groupName.text = person.name
        self.photoCell.image = person.photo
    }
    
   
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
        
       
        // Initialization code
    }
   
   
    
}
