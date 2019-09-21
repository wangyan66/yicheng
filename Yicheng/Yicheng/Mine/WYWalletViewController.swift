//
//  WYWalletViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/20.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class WYWalletViewController: UIViewController {
    var nowBtn:UIButton?
    var hideMoney = true
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var eyeBtn: UIButton!
    
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var btn30: UIButton!
    @IBOutlet weak var btn25: UIButton!
    @IBOutlet weak var btn20: UIButton!
    @IBOutlet weak var btn15: UIButton!
    @IBOutlet weak var btn10: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBAction func btn5Clicked(_ sender: Any) {
        nowBtn?.setBackgroundImage(UIImage.init(named: "rect_62") , for: .normal)
        btn5.setBackgroundImage(UIImage.init(named: "chosen") , for: .normal)
        nowBtn = btn5
        confirmBtn.setTitle("确认充值¥5", for: .normal)
    }
    @IBAction func btn10Clicked(_ sender: Any) {
        nowBtn?.setBackgroundImage(UIImage.init(named: "rect_62") , for: .normal)
        btn10.setBackgroundImage(UIImage.init(named: "chosen") , for: .normal)
        nowBtn = btn10
         confirmBtn.setTitle("确认充值¥10", for: .normal)
    }
    @IBAction func btn15Clicked(_ sender: Any) {
        nowBtn?.setBackgroundImage(UIImage.init(named: "rect_62") , for: .normal)
        btn15.setBackgroundImage(UIImage.init(named: "chosen") , for: .normal)
        nowBtn = btn15
        
        confirmBtn.setTitle("确认充值¥15", for: .normal)
    }
    @IBAction func btn20Clicked(_ sender: Any) {
        nowBtn?.setBackgroundImage(UIImage.init(named: "rect_62") , for: .normal)
        btn20.setBackgroundImage(UIImage.init(named: "chosen") , for: .normal)
        nowBtn = btn20
         confirmBtn.setTitle("确认充值¥20", for: .normal)
    }
    @IBAction func btn25Clicked(_ sender: Any) {
        nowBtn?.setBackgroundImage(UIImage.init(named: "rect_62") , for: .normal)
        btn25.setBackgroundImage(UIImage.init(named: "chosen") , for: .normal)
        nowBtn = btn25
         confirmBtn.setTitle("确认充值¥25", for: .normal)
    }
    @IBAction func btn30Clicked(_ sender: Any) {
        nowBtn?.setBackgroundImage(UIImage.init(named: "rect_62") , for: .normal)
        btn30.setBackgroundImage(UIImage.init(named: "chosen") , for: .normal)
        nowBtn = btn30
         confirmBtn.setTitle("确认充值¥30", for: .normal)
        
    }
//    @IBAction func eyebtnClicked(_ sender: Any) {
//
//        (sender as AnyObject).selected = !sender.selected
//    }
    @IBAction func eyebtnClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if hideMoney{
            moneyLabel.text = "8888"
            hideMoney = false
        }else{
            moneyLabel.text = "****"
            hideMoney = true
        }
    }
    @IBOutlet weak var btn401: UIButton!
    @IBOutlet weak var btn402: UIButton!
    @IBAction func btn402Clicked(_ sender: UIButton) {
        sender.isSelected = true
        btn401.isSelected = !sender.isSelected
    }
    @IBAction func btn401Clicked(_ sender: UIButton) {
        sender.isSelected = true
        btn402.isSelected = !sender.isSelected
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        eyeBtn.setBackgroundImage(UIImage.init(named: "close_eye") , for: .normal)
        eyeBtn.setBackgroundImage(UIImage.init(named: "open_eye") , for: .selected)
        btn401.setBackgroundImage(UIImage.init(named: "round_63") , for: .normal)
        btn401.setBackgroundImage(UIImage.init(named: "chosen_2") , for: .selected)
        btn402.setBackgroundImage(UIImage.init(named: "round_63") , for: .normal)
        btn402.setBackgroundImage(UIImage.init(named: "chosen_2") , for: .selected)
        hideMoney = true
        confirmBtn.setTitle("确认充值", for: .normal)
        self.title = "我的钱包"
        self.navigationController?.navigationBar.tintColor = .white
        self.hidesBottomBarWhenPushed = true
        // Do any additional setup after loading the view.
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
