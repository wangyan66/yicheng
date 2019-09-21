//
//  WYTranslateViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/2.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
class WYTranslateViewController: UIViewController,UITextViewDelegate{
    
    
    @IBOutlet weak var ChineseLine: UIImageView!
    @IBOutlet weak var JapaneseLine: UIImageView!
    @IBOutlet weak var EnglishLine: UIImageView!
    
    @IBOutlet weak var sChineseLine: UIImageView!
    @IBOutlet weak var sJapaneseLine: UIImageView!
    @IBOutlet weak var sEnglishLine: UIImageView!
    
    @IBOutlet weak var originTextView: UITextView!
    @IBOutlet weak var resultTextView: UITextView!
    
    var originText:String? = ""
    var resultText:String? = ""
    let placeHolderLabel=UILabel()
//    var ishideHoder;?
    var tolanguage:Int = 0
    var slanguage:Int = 0
    @IBAction func soundBtn(_ sender: Any) {
        let alertController = UIAlertController.init(title: "该服务为App内购买项目", message: "您想以30金币的价格购买语音翻译功能的永久权限吗?", preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        let removeAction = UIAlertAction(title: "购买", style: .default) { (UIAlertAction) in
            ZWHUDTool.showPlainHUD(in: self.navigationController?.view,text: "购买成功")?.hide(animated: true, afterDelay: kTimeIntervalShort)
        }
        alertController.addAction(removeAction)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func EnglishBtnClicked(_ sender: Any) {
        EnglishLine.isHidden = false
        JapaneseLine.isHidden = true
        ChineseLine.isHidden = true
        tolanguage = 0
        self.translate()
    }
    
    @IBAction func JapaneseBtnClicked(_ sender: Any) {
        EnglishLine.isHidden = true
        JapaneseLine.isHidden = false
        ChineseLine.isHidden = true
        tolanguage = 1
        self.translate()
    }
    
    @IBAction func ChineseBtnClicked(_ sender: Any) {
        EnglishLine.isHidden = true
        JapaneseLine.isHidden = true
        ChineseLine.isHidden = false
        tolanguage = 2
        self.translate()
    }
    
    
    
    
    @IBAction func sEnglishBtnClicked(_ sender: Any) {
        sEnglishLine.isHidden = false
        sJapaneseLine.isHidden = true
        sChineseLine.isHidden = true
        slanguage = 0
        self.translate()
    }
    
    @IBAction func sJapaneseBtnClicked(_ sender: Any) {
        sEnglishLine.isHidden = true
        sJapaneseLine.isHidden = false
        sChineseLine.isHidden = true
        slanguage = 1
        self.translate()
    }
    
    @IBAction func sChineseBtnClicked(_ sender: Any) {
        sEnglishLine.isHidden = true
        sJapaneseLine.isHidden = true
        sChineseLine.isHidden = false
        slanguage = 2
        self.translate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        originTextView.delegate=self
        self.setupPlaceHolder()
        
        //
        EnglishLine.isHidden = true
        JapaneseLine.isHidden = true
        ChineseLine.isHidden = false
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        ///
        EnglishLine.isHidden = true
        JapaneseLine.isHidden = true
        ChineseLine.isHidden = false
        
        sEnglishLine.isHidden = true
        sJapaneseLine.isHidden = false
        sChineseLine.isHidden = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "翻译"
        self.originTextView.text = originText
        self.resultTextView.text = resultText
    }
    func setData(oringin:String,result:String){
        if self.originTextView != nil {
            self.originTextView.text = oringin
        }
        if self.resultTextView != nil {
            self.resultTextView.text = result
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
         IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
    }
    func translate(){
        let dic = ["en","JA","zh-CN"]
        ZWAPIRequestTool.requestTextTranslate(byText: self.originTextView.text, sourceLan: dic[slanguage], targetLan: dic[tolanguage]){[weak self](response:Any?, success:Bool?) in
                        let result=response as! [String :Any]
                        print(result)
                        print(success)
                        if let success = success{
                            let code = result[kHTTPResponseCodeKey] as? Int
                            print(success)
                            print(code ?? 123)
                            if(success == true && code == KHTTPSuccessInt){
                                self?.resultTextView.text = result[kHTTPResponseDataKey] as? String
                                //print(result[kHTTPResponseDataKey] as? String)
                            }else{
                                ZWHUDTool.showPlainHUD(in: self?.navigationController?.view,text: "出现错误")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                            }
                        }
                    }
//        switch tolanguage {
//        case 0:
//            print("case0")
//            ZWAPIRequestTool.requestTextTranslate(byText: self.originTextView.text, sourceLan: dic[slanguage], targetLan: "en"){[weak self](response:Any?, success:Bool?) in
//                let result=response as! [String :Any]
//                print(result)
//                print(success)
//                if let success = success{
//                    let code = result[kHTTPResponseCodeKey] as? Int
//                    print(success)
//                    print(code ?? 123)
//                    if(success == true && code == KHTTPSuccessInt){
//                        self?.resultTextView.text = result[kHTTPResponseDataKey] as? String
//                        //print(result[kHTTPResponseDataKey] as? String)
//                    }else{
//                        ZWHUDTool.showPlainHUD(in: self?.navigationController?.view,text: "出现错误")?.hide(animated: true, afterDelay: kTimeIntervalShort)
//                    }
//                }
//            }
//        case 1:
//            print("case1")
//            ZWAPIRequestTool.requestTextTranslate(byText: self.originTextView.text, sourceLan: dic[slanguage], targetLan: "JA"){[weak self](response:Any?, success:Bool?) in
//                let result=response as! [String :Any]
//                print(result)
//                print(success)
//                if let success = success{
//                    let code = result[kHTTPResponseCodeKey] as? Int
//                    print(success)
//                    print(code ?? 123)
//                    if(success == true && code == KHTTPSuccessInt){
//                        self?.resultTextView.text = result[kHTTPResponseDataKey] as? String
//                    }else{
//                        ZWHUDTool.showPlainHUD(in: self?.navigationController?.view,text: "出现错误")?.hide(animated: true, afterDelay: kTimeIntervalShort)
//                    }
//                }
//            }
//        case 2:
//            print("case2")
//            ZWAPIRequestTool.requestTextTranslate(byText: self.originTextView.text, sourceLan: "JA", targetLan: "zh-CN"){[weak self](response:Any?, success:Bool?) in
//                let result=response as! [String :Any]
//                print(result)
//                print(success)
//                if let success = success{
//                    let code = result[kHTTPResponseCodeKey] as? Int
//                    print(success)
//                    print(code ?? 123)
//                    if(success == true && code == KHTTPSuccessInt){
//                        self?.resultTextView.text = result[kHTTPResponseDataKey] as? String
//                    }else{
//                        ZWHUDTool.showPlainHUD(in: self?.navigationController?.view,text: "出现错误")?.hide(animated: true, afterDelay: kTimeIntervalShort)
//                    }
//                }
//            }
//        default:
//            print("casede")
//        }
    }
    func setupPlaceHolder()->Void{
       
        placeHolderLabel.text="请在此输入要翻译的单词或句子"
        placeHolderLabel.font = UIFont.systemFont(ofSize: 22)
        placeHolderLabel.textColor = UIColor.gray
        placeHolderLabel.sizeToFit()
        placeHolderLabel.frame.origin.x = 0
        placeHolderLabel.frame.origin.y = 6
//        placeHolderLabel.contentMode = .top
        //placeHolderLabel.contentMode = uivie
        originTextView.addSubview(placeHolderLabel)
    }
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text.count==0) {
            self.placeHolderLabel.alpha = 1;
        } else {
            self.placeHolderLabel.alpha = 0;
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.translate()
    }

}
