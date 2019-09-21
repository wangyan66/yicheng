//
//  KeyFile.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/14.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit
    let KScreenH=UIScreen.main.bounds.height
    let KScreenW=UIScreen.main.bounds.width
    let MAPKEY="4841e92b9e84ce340a24b37ca28e15f4"
    let kHTTPResponseDataKey="data"
    let kHTTPResponseCodeKey="status"
    let KHTTPSuccessInt = 200
    let KHTTPAttractionFailedKEY = "None_of_the_above"
    let KHTTP_Have_Detail = "isInformation"
let kTimeIntervalShort:TimeInterval = 1.0
func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat)->UIColor{
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}
