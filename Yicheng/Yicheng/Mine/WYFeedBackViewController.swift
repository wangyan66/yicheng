//
//  WYFeedBackViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/22.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class WYFeedBackViewController: UIViewController,UITextViewDelegate{

    @IBAction func submit(_ sender: Any) {
        ZWHUDTool.showPlainHUD(in: self.navigationController?.view,text: "提交成功")?.hide(animated: true, afterDelay: kTimeIntervalShort)
        self.navigationController?.popViewController(animated: true)
    }
    @IBOutlet weak var textView: UITextView!
    let placeHolderLabel=UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "意见反馈"
        self.navigationController?.navigationBar.tintColor = .white
        self.hidesBottomBarWhenPushed = true
        
        textView.delegate = self
        textView.layer.backgroundColor = UIColor.clear.cgColor
        let borderColor = RGBA(r: 187, g: 187, b: 187, a: 1.0)
        textView.layer.borderColor = borderColor.cgColor
        textView.layer.borderWidth = 1.0;
        textView.layer.masksToBounds = true
        textView.textColor = borderColor
        self.setupPlaceHolder()
        // Do any additional setup after loading the view.
    }
    

    func setupPlaceHolder()->Void{
        
        placeHolderLabel.text="请在此写下您的建议"
        placeHolderLabel.font = UIFont.systemFont(ofSize: 14)
        placeHolderLabel.textColor = RGBA(r: 187, g: 187, b: 187, a: 1.0)
        placeHolderLabel.sizeToFit()
        placeHolderLabel.frame.origin.x = 0
        placeHolderLabel.frame.origin.y = 6
        //        placeHolderLabel.contentMode = .top
        //placeHolderLabel.contentMode = uivie
        textView.addSubview(placeHolderLabel)
    }
//    func textViewDidChange(_ textView: UITextView) {
//        if (textView.text.count==0) {
//            self.placeHolderLabel.alpha = 1;
//        } else {
//            self.placeHolderLabel.alpha = 0;
//        }
//    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.placeHolderLabel.alpha = 0;
    }
}
