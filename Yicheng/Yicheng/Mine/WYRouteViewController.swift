//
//  WYRouteViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/22.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class WYRouteViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var tableView:UITableView?
    let cellIdentifier = "WYRouteViewCell"
    let nameAry = ["八达岭长城","天坛","天安门","雍和宫","故宫"]
    let timeAry = ["2019/02/14","2019/02/21","2019/02/27","2019/03/15","2019/03/21"]
    let locationAry = ["北京市延庆区军都山关沟古道北口","北京市东城区永定门内大街东侧","北京市东城区东长安街","北京市东城区雍和宫大街28号","北京市东城区东长安街"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的足迹"
        self.navigationController?.navigationBar.tintColor = .white
        self.hidesBottomBarWhenPushed = true
        self.setupTableView()
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as! WYCollectionViewCell
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        let tableView = UITableView(frame:self.view.frame,style:.plain)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .singleLine
//        tableView.separatorColor = RGBA(r: 0.8, g: 0.8, b: 0.8, a: 1.0)
//        tableView.separatorInset = UIEdgeInsets.zero
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "WYRouteViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView.init(frame: CGRect.zero)
//        tableView.estimatedRowHeight = 100
//        tableView.rowHeight = UITableView.automaticDimension
       
        self.tableView = tableView
        self.view.addSubview(self.tableView!)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:WYRouteViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! WYRouteViewCell
//        let temp = Int(arc4random_uniform(3))+1
        cell.name.text = nameAry[indexPath.row]
        cell.time.text = timeAry[indexPath.row]
        cell.location.text = locationAry[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let time = DispatchTime(uptimeNanoseconds: UInt64(0.2 * Double(NSEC_PER_SEC)))
        DispatchQueue.main.asyncAfter(deadline: time) {
            tableView .deselectRow(at: indexPath, animated: true)
        }
    }

}
