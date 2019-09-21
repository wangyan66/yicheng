//
//  WYLikeListiewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/25.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit
import MJRefresh
import Kingfisher
class WYLikeListiewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,WYDetailPoiViewDelegate{
    private let cellidentifier="collectionViewCell"
    public var pois:NSMutableArray?
    var collectionView:UICollectionView?
    var blurVisualEffect:UIVisualEffectView?
    var poiInfoView: WYDetailPoiView?
    func close() {
        self.blurVisualEffect?.removeFromSuperview()
        self.blurVisualEffect = nil
        self.poiInfoView?.removeFromSuperview()
        self.poiInfoView = nil
    }
    func like() {
        ZWHUDTool.showPlainHUD(in: self.navigationController?.view,text: "收藏成功")?.hide(animated: true, afterDelay: kTimeIntervalShort)
        
    }
    func navigate() {
        
        // self.poiInfoView?.removeFromSuperview()
        let alertController = UIAlertController.init(title: "该服务为App内购买项目", message: "您想以30金币的价格购买导航功能的永久权限吗?", preferredStyle: .alert)
        let cancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        let removeAction = UIAlertAction(title: "购买", style: .default) { (UIAlertAction) in
            ZWHUDTool.showPlainHUD(in: self.navigationController?.view,text: "购买成功")?.hide(animated: true, afterDelay: kTimeIntervalShort)
        }
        alertController.addAction(removeAction)
        self.present(alertController, animated: true, completion: nil)
    }
    // MARK: - CollectionView_Delegate
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pois?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellidentifier, for: indexPath) as! WYCollectionViewCell
        let model = pois?[indexPath.row] as! WYPOI
        //cell.imageView.image=UIImage(named: "manuel-cosentino-691602-unsplash")
        cell.address.text = model.address
        cell.name.text = model.name
        
        if let tel = model.tel{
            if(tel.count>0){
                cell.tel.text = tel
            }else{
                cell.tel.text = "无"
            }
            
        }else{
            cell.tel.text = "无"
        }
        if let dis = model.distance{
            cell.distance.text = ""
        }else{
            cell.distance.text = ""
        }
        
        if let urlStr = model.imageUrl {
            let url = URL(string: urlStr)
            cell.imageView.kf.setImage(with: url)
        }else{
            cell.imageView.image=UIImage(named: "manuel-cosentino-691602-unsplash")
        }
        return cell
        //return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = pois?[indexPath.row] as! WYPOI
//        self.searchDetailInfoOfPoi(uid: model.uid)
        
        self.blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
        self.blurVisualEffect?.frame = UIScreen.main.bounds
        self.view.addSubview(self.blurVisualEffect!)
        blurVisualEffect?.alpha = 0.3
        let nib = UINib(nibName: "WYDetailPoiView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! WYDetailPoiView
        //        view.frame = CGRect.init(x: (KScreenW-270)/2, y: 95, width: 270, height: 379)
        view.frame.origin.x = (KScreenW-270)/2
        view.frame.origin.y = 140
        view.name.text = model.name
        view.location.text = model.address
        view.info.text = model.introduce
        view.distance.text = ""
        let url = URL(string: model.imageUrl!)
       
        view.imageView.kf.setImage(with: url)
        self.poiInfoView = view
        poiInfoView?.delegate = self
        self.view.addSubview(view)
        //        self.beginSearchPois()
    }
    func setUpCollectionView(){
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: (KScreenW-34)/2, height: 232)
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 12, bottom: 0, right: 12)
        flowLayout.minimumLineSpacing = 16.0;
        //       flowLayout.minimumInteritemSpacing = 0.0;
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: KScreenW, height: self.view.frame.size.height), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.init(red: 243/255, green: 243/255, blue: 243/255, alpha: 1.0)
        //collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.dataSource=self;
        collectionView.delegate=self;
        collectionView.register(UINib(nibName: "WYCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:cellidentifier)
        let header = MJRefreshNormalHeader()
        header.setRefreshingTarget(self,refreshingAction: #selector(refreshData))
        collectionView.mj_header = header
        collectionView.mj_header.isHidden = false
        header.beginRefreshing()
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        
    }
    @objc func refreshData(){
        ZWAPIRequestTool.requestLikeListResult(){[weak self](response:Any?, success:Bool?) in
            self?.collectionView?.mj_header.endRefreshing()
            print(response)
            if let success = success{
                if (success != true){
                    
                    ZWHUDTool.showPlainHUD(withText: "出现错误")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                    return
                    
                }
                
                let result=response as! [String :Any]
                print(result)
                let code = result[kHTTPResponseCodeKey] as? Int
                print(success)
                print(code ?? 123)
                if(success == true && code == KHTTPSuccessInt){
                    let pois = NSMutableArray()
                    let dataAry:[Any] = result[kHTTPResponseDataKey] as! [Any]
                    
                    
                    for dic in dataAry{
                        
                        print(dic)
                        let dictionary = dic as! [String : Any]
                        
                            let model = WYPOI()
                        model.address = dictionary["position"] as! String
                            model.name = dictionary["name"] as! String
                            model.tel = dictionary["phone"] as! String
                            model.distance = 0
                            model.imageUrl = dictionary["url"] as! String
                            model.introduce = dictionary["introduce"] as! String
                            pois.add(model)
                    }
                    self?.pois = pois
                    self?.collectionView?.reloadData()
                }else{
                    
                    ZWHUDTool.showPlainHUD(withText: "出现错误")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                }
            }else{
                
                ZWHUDTool.showPlainHUD(withText: "出现错误啦,请再试试")?.hide(animated: true, afterDelay: kTimeIntervalShort)
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
         self.setUpCollectionView()
        self.title = "我的收藏"
        self.navigationController?.navigationBar.tintColor = .white
        self.hidesBottomBarWhenPushed = true
    }
}
