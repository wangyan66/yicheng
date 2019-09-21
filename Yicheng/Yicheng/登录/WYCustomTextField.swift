//
//  WYCustomTextField.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/11.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit
@IBDesignable
class WYCustomTextField: UITextField {
    var vercodeBtn:UIButton?
    @IBInspectable var left:UIImage?{
        didSet{
            self.leftView=UIImageView.init(image: left)
            self.leftViewMode = .always
        }
    }
//    @IBInspectable var right:UIImage?{
//        didSet{
//            if right != nil {
//                self.vercodeBtn? = UIButton.init(frame: CGRect.zero)
//                self.vercodeBtn?.setTitle("获取验证码", for: .normal)
//                self.vercodeBtn?.setTitleColor(RGBA(r: 114, g: 171, b: 241, a: 1.0), for: .normal)
//                print("shit1")
//                self.vercodeBtn?.sizeToFit()
//                self.vercodeBtn?.backgroundColor = .black
//                self.rightView?=UIView()
//                self.rightView?.addSubview(self.vercodeBtn!)
//                self.rightViewMode = .always
//            }
//        }
//    }
    override func prepareForInterfaceBuilder() {
        
        self.leftView=UIImageView.init(image: left)
        self.leftViewMode = .always
        
//        if right != nil {
//            self.vercodeBtn? = UIButton.init(frame: CGRect.zero)
//            self.vercodeBtn?.setTitle("获取验证码", for: .normal)
//            self.vercodeBtn?.setTitleColor(RGBA(r: 114, g: 171, b: 241, a: 1.0), for: .normal)
//            print("shit2")
//            self.vercodeBtn?.sizeToFit()
//            self.rightView?=UIView()
//            self.rightView?.addSubview(self.vercodeBtn!)
//
//            self.rightViewMode = .always
//        }
        
    }
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect=super.leftViewRect(forBounds: bounds)
        rect.origin.x+=15
        return rect
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
