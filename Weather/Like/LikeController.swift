//
//  LikeController.swift
//  Weather
//
//  Created by admin on 19/03/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


final class LikeController: UIControl {

    var count = 0
    var label = UILabel()
    var likeButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        
        let button = self.likeButton
        let like = self.label
        like.frame = CGRect(x: 60, y: 0, width: 20, height: 20)
        like.text = "\(self.count)"
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        button.setBackgroundImage(UIImage(named: "heart"), for: .normal)
        button.addTarget(self, action: #selector(upImage), for: .touchUpInside)
        self.addSubview(button)
        self.addSubview(like)
        
    }
    
    @objc func upImage(sender: UIButton) {
        
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 2
        animation.duration = 2
        animation.beginTime = CACurrentMediaTime() + 0.5
        animation.fillMode = CAMediaTimingFillMode.backwards
        sender.layer.add(animation, forKey: nil)
        sender.setBackgroundImage(UIImage(named: "Image"), for: .normal)
        
        if self.count == 0{
            count += 1
            self.label.text = "\(self.count)"
        }else{
            count -= 1
            sender.setBackgroundImage(UIImage(named: "heart"), for: .normal)
            self.label.text = "\(self.count)"
        }
    }
    
}



