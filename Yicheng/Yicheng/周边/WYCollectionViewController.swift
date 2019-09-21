//
//  WYCollectionViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/2.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit
import MJRefresh
import Kingfisher
class WYCollectionViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,AMapSearchDelegate,WYDetailPoiViewDelegate{
    //景点识别回调参数
    var needShowDetailInfo:Bool?
    var needShowIntro:String?
    var needShowPosition:String?
    var needShowName:String?
    var needShowImage:UIImage?
    private let cellidentifier="collectionViewCell"
    
    public var pois:NSMutableArray?
    var collectionView:UICollectionView?
    var locationLabel:UILabel?
    var search: AMapSearchAPI!
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
            cell.distance.text = "\(dis)m"
        }else{
            cell.distance.text = "0"
        }
        
        if let urlStr = model.imageUrl {
            let url = URL(string: urlStr)
            cell.imageView.kf.setImage(with: url)
        }else{
            let temp = Int(arc4random()%2)
            let bstr = String.init(temp)
            let str = "fimage"+bstr+".jpg"
            cell.imageView.image=UIImage(named: str)
        }
        return cell
        //return cell;
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = pois?[indexPath.row] as! WYPOI
        //self.searchDetailInfoOfPoi(uid: model.uid)
        self.blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
        self.blurVisualEffect?.frame = self.view.frame
        self.view.addSubview(self.blurVisualEffect!)
        blurVisualEffect?.alpha = 0.3
        let nib = UINib(nibName: "WYDetailPoiView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! WYDetailPoiView
        //        view.frame = CGRect.init(x: (KScreenW-270)/2, y: 95, width: 270, height: 379)
        view.frame.origin.x = (KScreenW-270)/2
        view.frame.origin.y = 140
                view.distance.text = ""
                view.location.text = model.address
                view.name.text = model.name
                view.info.text = "暂无资料"
        if let urlStr = model.imageUrl {
            let url = URL(string: urlStr)
            view.imageView.kf.setImage(with: url)
        }else{
            let temp = Int(arc4random()%2)
            let bstr = String.init(temp)
            let str = "fimage"+bstr+".jpg"
            
            view.imageView.image=UIImage(named: str)
        }
        self.poiInfoView = view
        poiInfoView?.delegate = self
        self.view.addSubview(view)
    }
    //flow delegate
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: (screenw-34)/2, height: 116*2)
//    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    //        return 8.0
    //    }
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    //        return 5.0
    //    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        //        let frame : CGRect = self.view.frame
//        //        let margin  = (frame.width - 90 * 3) / 6.0
//        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12) // margin between cells
//    }
    
    //@IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK: - Search_Delegate
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        if response.count == 0 {
            self.collectionView?.mj_header.endRefreshing()
            return
        }
        //解析response获取POI信息
        let pois = NSMutableArray()
        for aPOI in response.pois {
            let model = WYPOI()
            model.uid = aPOI.uid
            model.address = aPOI.address
            model.name = aPOI.name
            model.tel = aPOI.tel
            model.distance = aPOI.distance
            model.imageUrl = aPOI.images?.first?.url
            //print(aPOI.extensionInfo)
            print(aPOI.type)
            pois.add(model)
        }
        self.pois = pois
        self.collectionView?.reloadData()
        self.collectionView?.mj_header.endRefreshing()
    }
    // MARK: - viewLifeCyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationItem.title = "your title"
        self.initSearch()
        self.setupNavigationBar()
        self.setUpCollectionView()
       
        
        
//        self.beginSearchPois()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let need = needShowDetailInfo {
            
            if need{
                
                //self.showDetailPoiView()
            }
        }
        if let c = pois{
            self.collectionView?.reloadData()
        }
        //self.collectionView?.mj_header.beginRefreshing()
        print(WYUserManager.sharedManager().user?.location)
        self.locationLabel?.text=WYUserManager.sharedManager().user?.location ?? "无"
        //self.locationLabel?.text="北京市"
        self.locationLabel?.sizeToFit()
    }
    
    // MARK: - method
    func showDetailPoiView(){
        
        self.blurVisualEffect = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        
        self.blurVisualEffect?.frame = UIScreen.main.bounds
        self.view.addSubview(self.blurVisualEffect!)
        blurVisualEffect?.alpha = 0.3
        let nib = UINib(nibName: "WYDetailPoiView", bundle: nil)
        let view = nib.instantiate(withOwner: nil, options: nil).first as! WYDetailPoiView
        //        view.frame = CGRect.init(x: (KScreenW-270)/2, y: 95, width: 270, height: 379)
        view.frame.origin.x = (KScreenW-270)/2
        view.frame.origin.y = 140
        view.distance.text = ""
        view.location.text = needShowPosition
        view.name.text = needShowName
       view.info.text = needShowIntro
        view.imageView.image = needShowImage
        self.poiInfoView = view
        poiInfoView?.delegate = self
        self.view.addSubview(view)
    }
    func initSearch(){
        search = AMapSearchAPI()
        search.delegate = self
    }
    func beginSearchPois(){
        let request = AMapPOIAroundSearchRequest()
        print("beginSearchPois")
        
        if let latitude = WYUserManager.sharedManager().user?.latitude {
            if let longitude = WYUserManager.sharedManager().user?.longitude{
                
                request.location = AMapGeoPoint.location(withLatitude: CGFloat(latitude), longitude: CGFloat(longitude))
//                request.location = AMapGeoPoint.location(withLatitude: 39.9088388072, longitude: 116.3975421957)
                request.keywords = "风景名胜|餐饮服务|住宿服务"
                request.radius = 50000
                request.requireExtension = true
                search.aMapPOIAroundSearch(request)
            }
            else{
                self.collectionView?.mj_header.endRefreshing()
            }
        }else{
            self.collectionView?.mj_header.endRefreshing()
        }
    }
    func searchDetailInfoOfPoi(uid:String?){
        if let uid = uid{
            let request = AMapPOIIDSearchRequest()
            request.uid = uid
            request.requireExtension    = true
            search.aMapPOIIDSearch(request)
        }
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
        header.setRefreshingTarget(self , refreshingAction: #selector(refreshData))
        collectionView.mj_header = header
        collectionView.mj_header.isHidden = false
        header.beginRefreshing()
        self.view.addSubview(collectionView)
        self.collectionView = collectionView
        
    }
    private func setupNavigationBar(){
//        let leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        leftButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
//
//        leftButton.setTitle("leftButton", for: UIControl.State.normal)
//
//        leftButton.addTarget(self, action: #selector(leftClick), for:UIControlEvents.touchUpInside)
        
        let rightView=UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        let leftView=UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        let classLabel=UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let locationLabel=UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 40))
        self.locationLabel=locationLabel
        classLabel.text="分类"
        classLabel.textColor = UIColor.white
        classLabel.font=UIFont.systemFont(ofSize: 12)
        locationLabel.text=WYUserManager.sharedManager().user?.location ?? "北京市"
        locationLabel.text = "北京市"
        locationLabel.textColor = UIColor.white
        locationLabel.font=UIFont.systemFont(ofSize: 12)
        classLabel.sizeToFit()
        
        locationLabel.sizeToFit()
        let frame1=classLabel.frame
        let frame2=locationLabel.frame
        classLabel.frame.origin=CGPoint(x:40-frame1.width, y: (40-frame1.height)/2)
        locationLabel.frame.origin=CGPoint(x:10, y: (40-frame2.height)/2)
        classLabel.tintColor=UIColor.white
        rightView.addSubview(classLabel)
        leftView.addSubview(locationLabel)
        let arrowImageView=UIImageView(frame: CGRect(x: 40, y:16, width: 10, height: 8))
        let locationImageView=UIImageView(frame: CGRect(x: 0, y:13, width: 10, height: 13))
        arrowImageView.image=UIImage(named: "arrow")
        locationImageView.image=UIImage(named: "GPS")
        rightView.addSubview(arrowImageView)
        leftView.addSubview(locationImageView)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightView)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftView)

    }
    
    // MARK: - OBJC_method
@objc func refreshData(){
        print("refreshData")
        self.beginSearchPois()
    }
}

