//
//  WYEmptyViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/2.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit
import SnapKit
class WYEmptyViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        // Do any additional setup after loading the view.
    }
    func setupUI() -> Void {
        let ocrBtn=UIButton()
        ocrBtn.backgroundColor=UIColor.gray
        
        ocrBtn.setTitle("拍照识别", for: .normal)
        ocrBtn.tintColor=UIColor.black
        ocrBtn.addTarget(self, action: #selector(recognizeBtnClicked), for: UIControl.Event.touchUpInside)
        self.view.addSubview(ocrBtn)
        ocrBtn.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
            make.top.equalTo(view.snp.top).offset(200)
        }
        
        let landmarkBtn=UIButton()
        landmarkBtn.backgroundColor=UIColor.gray
        landmarkBtn.setTitle("景点识别", for: .normal)
        landmarkBtn.tintColor=UIColor.black
        landmarkBtn.addTarget(self, action: #selector(recognizeBtnClicked), for: UIControl.Event.touchUpInside)
        
        self.view.addSubview(landmarkBtn)
        landmarkBtn.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalTo(view)
            make.top.equalTo(view.snp.top).offset(300)
        }
        
    }
@objc func recognizeBtnClicked(){
        weak var weakSelf = self
//        if btnTag==0 {
//            print("文字识别")
//        }else{
//            print("图像识别")
//        }
        let alertController = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
        //let takePhotoAction = UIAlertAction(title: "Take a photo", style: .default, handler: nil)
        let takePhotoAction = UIAlertAction(title: "拍照", style: .default) { (UIAlertAction) in
            weakSelf?.selectImage(selectImageWay: 0)
        }
        alertController.addAction(takePhotoAction)
    
    
        let selectFromAlbumAction = UIAlertAction(title: "从相册中选择", style: .default) { (UIAlertAction) in
            weakSelf?.selectImage(selectImageWay: 1)
        }
        alertController.addAction(selectFromAlbumAction)
        let cancelAction = UIAlertAction(title: "取消", style: .default,handler: nil)
        alertController.addAction(cancelAction)
//        tabBarController?.present(alertController, animated: true, completion: nil)
        self.present(alertController, animated: true, completion: nil)
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
    //选取相册
    @objc func fromAlbum() {
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //初始化图片控制器
            let picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            //指定图片控制器类型
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            //设置是否允许编辑
            picker.allowsEditing = true
            //弹出控制器，显示界面
            self.present(picker, animated: true, completion: {
                () -> Void in
            })
        }else{
            print("读取相册错误")
        }
        
    }
    @objc func takePhoto(){
        
    }
    //选择图片成功后代理
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
}
    
    
         
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

