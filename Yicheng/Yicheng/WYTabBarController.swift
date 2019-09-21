//
//  WYTabBarController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/2.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class WYTabBarController: UITabBarController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WYCustomCameraViewControllerDelegate{
    func ocrbyImage(image: UIImage) {

         ZWHUDTool.show(withText: "正在识别")
        ZWAPIRequestTool.requestPictureTranslate(byPicture: image){[weak self](response:Any?, success:Bool?) in
            print(response)
            if let success = success{
                ZWHUDTool.dismiss()
                if (success != true){
                    
                    ZWHUDTool.showPlainHUD(withText: "出现错误啦,请再试试")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                    return
                    
                }
                let result=response as! [String :Any]
                print(result)
                let code = result[kHTTPResponseCodeKey] as? Int
                print(success)
                print(code ?? 123)
                if(success == true && code == KHTTPSuccessInt){
                    
                    let nvc = self?.viewControllers?[3] as! UINavigationController
                    let vc = nvc.viewControllers.last as! WYTranslateViewController
                    let data = result[kHTTPResponseDataKey] as! [String :String]
                   let  str1 = data["text"]
                   let str2 = data["transResult"]
                    vc.tolanguage = 1
                   vc.resultText = str2
                    vc.placeHolderLabel.isHidden = true
                    vc.originText = str1
                    vc.resultText = str2
                    vc.setData(oringin: str1!, result: str2!)
                    self?.selectedIndex = 3
                }else{
                    
                     ZWHUDTool.showPlainHUD(withText: "出现错误啦,请再试试")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                }
            }else{
                ZWHUDTool.dismiss()
                ZWHUDTool.showPlainHUD(withText: "出现错误啦,请再试试")?.hide(animated: true, afterDelay: kTimeIntervalShort)
            }
            
        }
    }
    
    func touristByImage(image: UIImage) {
          ZWHUDTool.show(withText: "正在识别")
        
        ZWAPIRequestTool.requestTouristRecognize(by:image){[weak self](response:Any?, success:Bool?) in
            print(response)
            if let success = success{
                if (success != true){
                    ZWHUDTool.dismiss()
                    ZWHUDTool.showPlainHUD(withText: "出现错误啦,请再试试")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                    return
                    
                }
                let result=response as! [String :Any]
                print(result)
                let code = result[kHTTPResponseCodeKey] as? Int
                print(success)
                print(code ?? 123)
                //200 普通识别结果
                ZWHUDTool.dismiss()
                if(code == KHTTPSuccessInt){
                    //如果value中 有null会出错
                    let data = result[kHTTPResponseDataKey] as! [String :String]
                    print(data["attraction"])
                    let needShowDetail = data[KHTTP_Have_Detail]
                    if (needShowDetail == "1"){
                        //可以展示景点卡
                        let name = data["attraction"]
                        let intro = data["introduce"]
                        let position = data["position"]
                      let nvc = self?.viewControllers?[1] as! UINavigationController
                      let vc = nvc.viewControllers.last as! WYCollectionViewController
                        vc.needShowDetailInfo = true
                        vc.needShowName = name
                        vc.needShowIntro = intro
                        vc.needShowPosition = position
                        vc.needShowImage = image
                        
                        self?.selectedIndex = 1
                        vc.showDetailPoiView()
                    }else{
                        if let attStr = data["attraction"]{
                            self?.goHomeSearchWithName(name: attStr)
                        }
                        
                    }

                }else if(code == 201){
                    
                    let data = result[kHTTPResponseDataKey] as! [String :String]
                    if let attStr = data["attraction"]{
                        if attStr == KHTTPAttractionFailedKEY{
                            ZWHUDTool.dismiss()
                            ZWHUDTool.showPlainHUD(withText: "识别错误,请换张图片试试")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                            return
                        }
                    }
                    ZWHUDTool.dismiss()
                    let needShowDetail = data[KHTTP_Have_Detail]
                    if (needShowDetail == "1"){
                        //可以展示景点卡
                        let name = data["attraction"]
                        let intro = data["introduce"]
                        let position = data["position"]
                        let nvc = self?.viewControllers?[1] as! UINavigationController
                        let vc = nvc.viewControllers.last as! WYCollectionViewController
                        vc.needShowDetailInfo = true
                        vc.needShowName = name
                        vc.needShowIntro = intro
                        vc.needShowPosition = position
                        vc.needShowImage = image
                        ZWHUDTool.dismiss()
                        self?.selectedIndex = 1
                        vc.showDetailPoiView()
                    }else{
                        if let attStr = data["attraction"]{
                            self?.goHomeSearchWithName(name: attStr)
                        }
                        
                    }
                }
                else{
                    ZWHUDTool.dismiss()
                    ZWHUDTool.showPlainHUD(withText: "出现错误啦,请再试试")?.hide(animated: true, afterDelay: kTimeIntervalShort)
                }
            }else{
                ZWHUDTool.dismiss()
                ZWHUDTool.showPlainHUD(withText: "出现错误啦,请再试试")?.hide(animated: true, afterDelay: kTimeIntervalShort)
            }
            
        }
    }
    
    
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
//        print("caoi")
//        return  !(viewController.isEqual(tabBarController.viewControllers?[2]))
//    }
    var centerBtn:UIButton?
    private func addChildVC(childVC: UIViewController, childTitle: String, imageName: String, selectedImageName:String , tag:Int)
    {
        //let childVC=WYCollectionViewController()
        let navigation = UINavigationController(rootViewController: childVC)
//        navigation.navigationBar.tintColor = UIColor.black //item 字体颜色
        navigation.navigationBar.setBackgroundImage(UIImage(named: "top_bar1"), for: .default)
//        navigation.navigationBar.barTintColor = UIColor.init(red: 80.0/255.0, green: 140.0/255.0, blue: 238.0/255.0, alpha: 1.0) //背景颜色
        navigation.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        //navigation.navigationBar.ba
//        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
//        //标题颜色
//        navigation.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
       // navigation.navigationItem.title="周边"
        //childVC.navigationItem.title="周边"
        
        childVC.tabBarItem.title = childTitle
        childVC.tabBarItem.tag = tag
        childVC.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        childVC.title = childTitle
        self.addChild(navigation)
    }
    
    //主页
    private func homeaddChildVC(childVC: UIViewController, childTitle: String, imageName: String, selectedImageName:String , tag:Int)
    {
        //let childVC=WYCollectionViewController()
        let navigation = UINavigationController(rootViewController: childVC)
        //        navigation.navigationBar.tintColor = UIColor.black //item 字体颜色
        navigation.navigationBar.setBackgroundImage(UIImage(named: "top_bar2"), for: .default)
        //        navigation.navigationBar.barTintColor = UIColor.init(red: 80.0/255.0, green: 140.0/255.0, blue: 238.0/255.0, alpha: 1.0) //背景颜色
        navigation.navigationBar.titleTextAttributes=[NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        //navigation.navigationBar.ba
        //        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        //        //标题颜色
        //        navigation.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        // navigation.navigationItem.title="周边"
        //childVC.navigationItem.title="周边"
        
        childVC.tabBarItem.title = childTitle
        childVC.tabBarItem.tag = tag
        childVC.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        childVC.tabBarItem.selectedImage = UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        childVC.title = childTitle
        self.addChild(navigation)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       // tabBar.tintColor = UIColor.yellow //tabbar 字体颜色
        //tabBar.barTintColor = UIColor.white //tabbar 背景颜色
//        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "WYCollectionViewController")
//        let tab = WYTabBar()
//        tab.delegate = self
//        self.setValue(tab, forKey: "tabBar")
        self.homeaddChildVC(childVC: WYHomeViewController(),childTitle: "首页", imageName: "page", selectedImageName: "page_col",tag: 1)
        self.addChildVC(childVC: WYCollectionViewController(),childTitle: "周边", imageName: "gps", selectedImageName: "gps_col",tag: 2)
        self.addChildVC(childVC: WYEmptyViewController(),childTitle: "", imageName: "", selectedImageName: "",tag: 3)
        let mainStoryBoard = UIStoryboard(name: "Mine", bundle: nil)
        let TransVC = mainStoryBoard.instantiateViewController(withIdentifier: "WYTranslateViewController")
        self.addChildVC(childVC: TransVC,childTitle: "翻译", imageName: "trans", selectedImageName: "trans_col",tag: 4)
        
        let MineVC = mainStoryBoard.instantiateViewController(withIdentifier: "WYMineViewController")
        self.addChildVC(childVC: MineVC,childTitle: "我的", imageName: "mine", selectedImageName: "mine_col",tag:5)
        
        
        
        // Do any additional setup after loading the view.
    }
//    private lazy var composeBtn : UIButton = {
//
//        () -> UIButton in // 懒加载本质是闭包,只是将这行省略了
//
//        // 初始化按钮
//        let composeBtn = UIButton()
//        // 设置按钮图片
//        composeBtn.setImage(UIImage(named: "camera"), for: UIControl.State.normal)
//        composeBtn.setImage(UIImage(named: "camera"), for: UIControl.State.highlighted)
//        // 设置背景图片
//        composeBtn.setBackgroundImage(UIImage(named: "round"), for: UIControl.State.normal)
//        composeBtn.setBackgroundImage(UIImage(named: "round"), for: UIControl.State.highlighted)
//
//        // 给按钮添加点击事件
////        composeBtn.addTarget(self, action: Selector("composeBtnClick:"), for: UIControl.Event.touchUpInside)
//        // 设置按钮的尺寸
//        composeBtn.sizeToFit()
//        return composeBtn
//    }()
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //查看info对象
        print(info)
        
        //显示的图片
        //        let image:UIImage!
        //        if editSwitch.isOn {
        //            //获取编辑后的图片
        //            image = info[.editedImage] as? UIImage
        //        }else{
        //            //获取选择的原图
        //            image = info[.originalImage] as? UIImage
        //        }
        //
        //        imageView.image = image
        //图片控制器退出
        picker.dismiss(animated: true, completion: {
            () -> Void in
        })
    }
    func selectImage(selectImageWay:Int)->Void{
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            if (selectImageWay==0){
                picker.sourceType=UIImagePickerController.SourceType.camera
            }else{
                picker.sourceType=UIImagePickerController.SourceType.photoLibrary
            }
            //设置是否允许编辑
            picker.allowsEditing = true
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: nil)
        }else{
            print("读取相册错误")
        }
    }
    @objc func centerBtnClicked(){
        let vc = WYCustomCameraViewController()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
//        weak var weakSelf = self
//        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
//        //let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
//        let takePhotoAction = UIAlertAction(title: "拍照", style: .default) { (UIAlertAction) in
////            weakSelf?.selectImage(selectImageWay: 0)
////            let mineStoryBoard = UIStoryboard(name: "Mine", bundle: nil)
////            let vc = mineStoryBoard.instantiateViewController(withIdentifier: "WYCustomCameraViewController")
////            vc.hidesBottomBarWhenPushed = true
//            let vc = WYCustomCameraViewController()
//            vc.delegate = self
////            self.navigationController?.pushViewController(vc, animated: vc)
//            self.present(vc, animated: true, completion: nil)
//        }
//        alertController.addAction(takePhotoAction)
//
//
//        let selectFromAlbumAction = UIAlertAction(title: "从相册中选择", style: .default) { (UIAlertAction) in
//            weakSelf?.selectImage(selectImageWay: 1)
//        }
//        alertController.addAction(selectFromAlbumAction)
//        let cancelAction = UIAlertAction(title: "取消", style: .default,handler: nil)
//        alertController.addAction(cancelAction)
//        //        tabBarController?.present(alertController, animated: true, completion: nil)
//        self.present(alertController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.centerBtn=self.tabBar.AddMyCenterTab()
        centerBtn?.addTarget(self, action: #selector(centerBtnClicked), for: UIControl.Event.touchUpInside)
        // 添加中间按钮
        // 按钮在viewDidLoad中添加,会被系统的BarButtonItem挡住,处理不了事件了
        // viewWillAppear中添加按钮,在系统的BarButtonItem之后添加
//        self.tabBar.addSubview(composeBtn)
//        // 设置按钮的位置
//        let rect = self.tabBar.frame
//        let width = rect.width / CGFloat(children.count)
//        composeBtn.frame = CGRect(x: 2 * width, y: 0, width: width, height: rect.height)
    }
    
    func goHomeSearchWithName(name:String){
                        let nvc = self.viewControllers?[0] as! UINavigationController
                        let vc = nvc.viewControllers.last as! WYHomeViewController
        
        vc.searchController.searchBar.text = name
            self.selectedIndex = 0
    }
    func addClick() {
        print("add succeed")
    }
    func shit(){
        let clazz = NSClassFromString("UITabBarButton")
        //var btnIndex:CGFloat = 0
        
        if let clas = clazz{
            for btn in self.tabBar.subviews {
                if btn.isKind(of:clas){
//                    btn.frame.size.width = self.tabBar.frame.size.width/5
//                    btn.frame.origin.x = btn.frame.size.width * btnIndex
//                    btnIndex += 1.0
//                    if btnIndex == 2 {
//                        
//                        btnIndex += 1.0
//                    }
                    btn.isUserInteractionEnabled = false
                }
            }
        }
    }
}

extension UITabBar
{
    
    //关联对象的ID,注意，在私有嵌套 struct 中使用 static var，这样会生成我们所需的关联对象键，但不会污染整个命名空间。
    
    private struct AssociatedKeys {
        static var TabKey = "tabView"
    }
    
    //定义一个新的tabbar属性,并设置set,get方法
    var btnTab:UIButton?{
        
        get{
            //通过Key获取已存在的对象
            return objc_getAssociatedObject(self, &AssociatedKeys.TabKey) as? UIButton
            
        }
        
        set{
            //对象不存在则创建
            objc_setAssociatedObject(self, &AssociatedKeys.TabKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /**
     添加中心按钮
     */
    func AddMyCenterTab()->UIButton
    {
        if self.btnTab == nil
        {
            
           // self.shadowImage = UIImage()//(49 - 42) / 2
           // print("self.frame.width:\(self.frame.width)")
            let btn = UIButton(frame: CGRect.init(x: (self.frame.width/5 - 86) / 2+(self.frame.width*2)/5, y: -40, width: 86, height: 86))
           // btn.autoresizingMask = [.flexibleHeight,.flexibleWidth]
            btn.setImage(UIImage.init(named: "ocr"), for: UIControl.State.normal)
            self.addSubview(btn)
            self.btnTab = btn
        }
        
        
        return self.btnTab!
    }
//    override open func layoutSubviews(){
//        let clazz = NSClassFromString("UITabBarButton")
//                var btnIndex:CGFloat = 0
//                if let clas = clazz{
//                    for btn in self.subviews {
//                        if btn.isKind(of:clas){
//                            btn.frame.size.width = self.frame.size.width/5
//                            btn.frame.origin.x = btn.frame.size.width * btnIndex
//                            btnIndex += 1.0
//                            if btnIndex == 2 {
//                                btnIndex += 1.0
//                            }
//                        }
//                    }
//                }
//    }
    
}

