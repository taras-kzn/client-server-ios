//
//  NewsTableViewCell.swift
//  Weather
//
//  Created by admin on 09/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


final class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var imageViewAvatar: UIImageView!
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var imageNews: UIImageView!
    @IBOutlet weak var commtntCountLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var newsTextFild: UITextView!
    @IBOutlet weak var repostCountLabel: UILabel!
    @IBOutlet weak var lekeView: LikeController!

    override func awakeFromNib() {
        super.awakeFromNib()
        newsTextFild.isEditable = false
    
    }

}
