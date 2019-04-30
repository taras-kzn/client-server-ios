//
//  HeaderGroup.swift
//  Weather
//
//  Created by admin on 01/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

class HeaderGroup: UITableViewHeaderFooterView {
    
    var label = UILabel(frame: .zero)
    
    //это делать тогда когда делаем из xiba или через сторбод
    //override func awakeFromNib() {
    //  setup()
    //}
    
    override init(reuseIdentifier: String?) {
        super .init(reuseIdentifier: reuseIdentifier)
        addSubview(label)
        setup()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
        setup()
    }
    private func setup(){
        addSubview(label)
    }
}


   

