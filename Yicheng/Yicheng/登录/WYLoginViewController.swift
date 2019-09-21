//
//  WYLoginViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/10.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit
import Moya
class WYLoginViewController: UIViewController,UITextFieldDelegate{

    @IBAction func sendVercode(_ sender: Any) {
        ZWAPIRequestTool.requestSendCode(withPhone: phoneTextField.text) { [weak self](response:Any?, success:Bool?) in
            let result=response as! [String :Any]
            print(result)
            print(success)
            if let success = success{
                let code = result[kHTTPResponseCodeKey] as? Int
                print(success)
                print(code ?? 123)
                if(success == true && code == KHTTPSuccessInt){
                    WYUserManager.sharedManager().vercode = result[kHTTPResponseDataKey] as? String
                }else{
                    ZWHUDTool.showPlainHUD(in: self?.navigationController?.view,text: "出现错误")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                }
            }
        }
    }
    @IBAction func login(_ sender: Any) {
        if let text = vercodeTextField.text {
        
            
            print(WYUserManager.sharedManager().vercode)
            if  text == WYUserManager.sharedManager().vercode {
                ZWHUDTool.showPlainHUD(in: self.navigationController?.view,text: "登录成功")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                self.navigationController?.popViewController(animated: true)
            }else{
                ZWHUDTool.showPlainHUD(in: self.navigationController?.view,text: "验证码错误")?.hide(animated: true, afterDelay: kTimeIntervalShort)
            }
            
        }
        
    }
    @IBOutlet weak var phoneTextField: WYCustomTextField!
    
    @IBOutlet weak var vercodeTextField: WYCustomTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        vercodeTextField.delegate=self
        phoneTextField.delegate=self
        // Do any additional setup after loading the view.
    }
    
    //TextField delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let length = string.lengthOfBytes(using: String.Encoding.utf8)
        for loopIndex in 0..<length {
            let char = (string as NSString).character(at: loopIndex)
            
            if char < 48 {
                return false
                
            }
            if char > 57 {
                return false
            }
        }
        if phoneTextField == textField {
            let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
            
            if proposeLength > 11 {
                return false
            }
        }
        if vercodeTextField == textField {
            let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
            
            if proposeLength > 6 {
                return false
            }
        }
        return true
    }
    
    
    deinit {
        print("deinit")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
