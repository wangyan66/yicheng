//
//  WYMineViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/2.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class WYMineViewController: UITableViewController{
    @IBOutlet weak var languageLabel: UILabel!
    //设置状态栏颜色
    func setStatusBarBackgroundColor(color:UIColor) -> Void {
        guard let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView else { return }
        statusBar.backgroundColor = color
        
    }
    func removeCache(){
        let alertController = UIAlertController.init(title: "是否清理缓存", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        let removeAction = UIAlertAction(title: "确认", style: .default) { (UIAlertAction) in
            ZWHUDTool.showPlainHUD(in: self.navigationController?.view,text: "清理成功")?.hide(animated: true, afterDelay: kTimeIntervalShort)
        }
        alertController.addAction(removeAction)
         self.present(alertController, animated: true, completion: nil)
    }
    @objc func goToLoginView(){
        let mainStoryBoard = UIStoryboard(name: "Mine", bundle: nil)
        let LoginVC = mainStoryBoard.instantiateViewController(withIdentifier: "WYLoginViewController")
        
        LoginVC.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(LoginVC, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languageLabel.text = WYUserManager.sharedManager().user?.language ?? "中文"
        //self.navigationController?.navigationItem.
        //self.navigationController?.delegate=self
        //self.setStatusBarBackgroundColor(color: UIColor.clear)
        
        
        //self.tableView.tableFooterView=UIView(frame:CGRect.zero)
        
    let headerView = Bundle.main.loadNibNamed("WYMineHeaderView", owner: nil, options: nil)?.first as! WYMineHeaderView
        headerView.frame.origin.y = -44
        headerView.frame.size.width = KScreenW
        self.view.addSubview(headerView)
        
        let LoginBtn = UIButton()
        LoginBtn.setBackgroundImage(UIImage.init(named: "rect_quit"), for: UIControl.State.normal)
       // LoginBtn.setBackgroundImage(UIImage.init(named: "rect_confirm"), for: UIControl.State.normal)
        LoginBtn.setTitle("注销", for: UIControl.State.normal)
        LoginBtn.tintColor = .white
        LoginBtn.sizeToFit()
        LoginBtn.frame.origin.y=self.tableView.frame.size.height - (self.tabBarController?.tabBar.frame.height)! - KScreenH * 0.2
        print(self.tableView.frame.size.height)
        LoginBtn.frame.origin.x = (KScreenW - LoginBtn.frame.size.width )/2
        LoginBtn.addTarget(self, action: #selector(goToLoginView), for: .touchUpInside)
        self.view.addSubview(LoginBtn)
        
        let clearView=UIView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: headerView.frame.size.height-24))
        clearView.backgroundColor=UIColor.clear
        self.tableView.tableHeaderView=clearView
        print(headerView.frame.size.height)
        

    }

    
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section==1){
            return 21
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let time = DispatchTime(uptimeNanoseconds: UInt64(0.2 * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: time) {
            tableView .deselectRow(at: indexPath, animated: true)
        }
        if indexPath.section == 0{
            if indexPath.row == 0{
                self.gotoStoryboardVC(name:"WYWalletViewController")
            }else if indexPath.row == 1{
                let vc = WYLikeListiewController()
                vc.title = "我的收藏"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 2{
                let vc = WYRouteViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 1 {
            //清理缓存
            if indexPath.row == 0{
                self.removeCache()
            }else if indexPath.row == 1{
                
            }else if indexPath.row == 2{
                self.gotoStoryboardVC(name:"WYFeedBackViewController")
            }
            
        }
    }

    // MARK: -custom func
    func gotoStoryboardVC(name:String){
        let mineStoryBoard = UIStoryboard(name: "Mine", bundle: nil)
        let vc = mineStoryBoard.instantiateViewController(withIdentifier: name)
        vc.hidesBottomBarWhenPushed = true
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
