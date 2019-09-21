//
//  WYDetailPoiView.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/23.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit
@objc protocol WYDetailPoiViewDelegate{
    
    func close()  //必须方法
    func like()
    func navigate()
    //@objc optional func like() //可选方法
    
}
class WYDetailPoiView: UIView {
    
    weak var  delegate: WYDetailPoiViewDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var info: UITextView!
    @IBAction func closeView(_ sender: Any) {
        
        if let delegateOK = self.delegate{
            delegateOK.close()
        }
    }
    @IBAction func like(_ sender: Any) {
        if let delegateOK = self.delegate{          
            delegateOK.like()
        }
    }
    @IBAction func navigate(_ sender: Any) {
        if let delegateOK = self.delegate{
            delegateOK.navigate()
        }
    }
    func loadXib() ->UIView {
        let className = type(of:self)
        let bundle = Bundle(for:className)
        let name = NSStringFromClass(className).components(separatedBy: ".").last
        let nib = UINib(nibName: name!, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        
        return view
    }

}
