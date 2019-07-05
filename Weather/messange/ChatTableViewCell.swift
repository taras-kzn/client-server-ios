//
//  ChatTableViewCell.swift
//  Weather
//
//  Created by admin on 30/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {

    @IBOutlet weak var mesangeView: UIView!
    @IBOutlet weak var messangeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
