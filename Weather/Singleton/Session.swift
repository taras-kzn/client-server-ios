//
//  Session.swift
//  Weather
//
//  Created by admin on 24/04/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit


final class Session{
    
    static let instance = Session()
    private init() {}
    
    var token : String = ""
    var userId : Int = 6973302

}
