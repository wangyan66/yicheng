//
//  WYTabBar.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/19.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

protocol WYTabBarDelegate:NSObjectProtocol {
    func addClick()
}

class WYTabBar: UITabBar {
    
    weak var addDelegate: WYTabBarDelegate?
    
    private lazy var addButton:UIButton = {
        return UIButton()
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = 60
        addButton.setBackgroundImage(UIImage.init(named: "ocr"), for: UIControl.State.normal)
        addButton.addTarget(self, action: #selector(WYTabBar.addButtonClick), for: .touchUpInside)
        self.addSubview(addButton)
       // self.backgroundColor = .white
        /// tabbar设置背景色
        //        self.shadowImage = UIImage()
        //self.backgroundImage = UIColor.creatImageWithColor(color: UIColor.white)
//        let btn = UIButton(frame: CGRect.init(x: (self.frame.width/5 - 86) / 2+(self.frame.width*2)/5, y: -40, width: 86, height: 86))
//        // btn.autoresizingMask = [.flexibleHeight,.flexibleWidth]
//        btn.setImage(UIImage.init(named: "ocr"), for: UIControl.State.normal)
////        btn.addTarget(self, action:#selector(fromAlbum), for: UIControl.Event.touchUpInside)
//        self.addSubview(btn)
//        self.plusBtn = btn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @objc func addButtonClick(){
        if addDelegate != nil{
            addDelegate?.addClick()
        }
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let buttonX = self.frame.size.width/5
        var index = 0
        for barButton in self.subviews{
            
            if barButton.isKind(of: NSClassFromString("UITabBarButton")!){
                
                if index == 2{
                    /// 设置添加按钮位置
                    addButton.frame = CGRect.init(x: (self.frame.width/5 - 86) / 2+(self.frame.width*2)/5, y: -40, width: 86, height: 86)
                    index += 1
                }
                barButton.frame = CGRect.init(x: buttonX * CGFloat(index), y: 0, width: buttonX, height: self.frame.size.height)
                index += 1
                
            }
        }
        self.bringSubviewToFront(addButton)
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        /// 判断是否为根控制器
        if self.isHidden {
            /// tabbar隐藏 不在主页 系统处理
            return super.hitTest(point, with: event)
            
        }else{
            /// 将单钱触摸点转换到按钮上生成新的点
            let onButton = self.convert(point, to: self.addButton)
            /// 判断新的点是否在按钮上
            if self.addButton.point(inside: onButton, with: event){
                return addButton
            }else{
                /// 不在按钮上 系统处理
                return super.hitTest(point, with: event)
            }
        }
    }
}

