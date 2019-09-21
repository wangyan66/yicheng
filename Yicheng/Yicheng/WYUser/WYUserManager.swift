//
//  WYUserManager.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/16.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class WYUserManager: NSObject {
    static let userManager:WYUserManager = WYUserManager()
    var user:WYUser?
    var vercode:String?
    var token:String?
    var isInJapan:Int?
    
    class func sharedManager() -> WYUserManager {
        return userManager
    }
}
