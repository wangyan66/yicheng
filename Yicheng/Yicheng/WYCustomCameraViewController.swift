//
//  WYCustomCameraViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/24.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit
import AVFoundation
import Photos
@objc protocol WYCustomCameraViewControllerDelegate{
    
    func ocrbyImage(image:UIImage)  //必须方法
    func touristByImage(image:UIImage)
    
    //@objc optional func like() //可选方法
    
}
class WYCustomCameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    weak var  delegate: WYCustomCameraViewControllerDelegate?
    var chooseModel: UISegmentedControl?
    //相机
    //获取设备
    var device :AVCaptureDevice!
    //输入流
    var input :AVCaptureDeviceInput!
    //输出流
    var photoOutput :AVCapturePhotoOutput!
    //启动摄像头捕获输入
    var output :AVCaptureOutput!
    //会话，协调input到output的数据传输
    var session :AVCaptureSession!
    //图像预览层，显示图像
    var previewLayer :AVCaptureVideoPreviewLayer!
    //拍照按钮
    var photoButton: UIButton?
    //拍照后的成像
    var imageView: UIImageView?
    var image :UIImage?
    //是否获取了拍照标识
    var isJurisdiction:Bool?
    // 图像设置，闪光灯设置
    var setting:AVCapturePhotoSettings?
    var flashButton:UIButton?
    //捕获链接
    var videoConnection: AVCaptureConnection?
    //控制闪光灯开关
    var isflash:Bool=false
    //相册
    var libraryButton:UIButton?
    //语言
    var languageButton:UIButton?
    var isChinese:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //隐藏tabbar
//        self.tabBarController?.hidesBottomBarWhenPushed = true
//        self.tabBarController?.tabBar.isHidden = true
        //判断是否有相机权限
        isJurisdiction = canUserCamera()
        if isJurisdiction!{
            customCamera()
            customUI()
        }
        else{
            return
        }
    }
    //相机权限
    func canUserCamera() -> Bool {
        PHPhotoLibrary.requestAuthorization({ (status) in
            switch status {
            case .notDetermined:
                break
            case .restricted://此应用程序没有被授权访问的照片数据
                break
            case .denied://用户已经明确否认了这一照片数据的应用程序访问
                break
            case .authorized://已经有权限
                break
            default:
                break
                
            }
        })
        return true
    }
    //初始化自定义相机
    func customCamera(){
        //创建摄像头
        guard let devices = AVCaptureDevice.devices(for: AVMediaType.video) as? [AVCaptureDevice] else { return } //初始化摄像头设备
        guard let devic = devices.filter({ return $0.position == .back }).first else{ return}
        device = devic
        //照片输出设置
        if #available(iOS 11.0, *) {
            setting=AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
        } else {
            // Fallback on earlier versions
        }
        //用输入设备初始化输入
        self.input = try? AVCaptureDeviceInput(device: device)
        //照片输出流初始化
        self.photoOutput = AVCapturePhotoOutput.init()
        //输出流初始化
        self.output = AVCaptureMetadataOutput.init()
        //生成会话
        self.session = AVCaptureSession.init()
        
        //输出画面质量
        if(self.session.canSetSessionPreset(AVCaptureSession.Preset(rawValue: "AVCaptureSessionPreset1280x720"))){
            self.session.sessionPreset = AVCaptureSession.Preset(rawValue: "AVCaptureSessionPreset1280x720")
        }
        
        //添加输入到会话中
        if(self.session.canAddInput(self.input)){
            
            self.session.addInput(self.input)
            
        }
        
        //添加输出到会话中
        if(self.session.canAddOutput(self.photoOutput)){
            
            self.session.addOutput(self.photoOutput)
            
        }
        
        //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
        self.previewLayer = AVCaptureVideoPreviewLayer.init(session: self.session)
        self.previewLayer.frame  = CGRect.init(x: 0, y: 103, width: KScreenW, height: 500)
        self.previewLayer.videoGravity = AVLayerVideoGravity(rawValue: "AVLayerVideoGravityResizeAspectFill")
        self.view.layer.addSublayer(self.previewLayer)
        
        
        
        // //自动白平衡
        //  if device.isWhiteBalanceModeSupported(.autoWhiteBalance) {
        //  device.whiteBalanceMode = .autoWhiteBalance
        //   }
        // device.unlockForConfiguration()//解锁
        //    }
        
        
        //启动
        self.session.startRunning()
    }
    //相机UI
    
    func customUI(){
        self.view.backgroundColor = .black
        //关于SegmentedControl
        //默认选中第一项
        chooseModel = UISegmentedControl.init(items: ["景点识别","文字识别"])
        chooseModel?.frame = CGRect(x: (KScreenW-150)/2, y: 660, width: 150, height: 25)
        chooseModel?.tintColor = .white
        chooseModel?.selectedSegmentIndex = 0
        chooseModel?.addTarget(self, action: #selector(segmentDidchange(segmented:)), for: .valueChanged)
        self.view.addSubview(chooseModel!)
        //返回按钮
        let backButton = UIButton(type: UIButton.ButtonType.system)
        backButton.setBackgroundImage(UIImage(named:"close"), for: .normal)
        backButton.frame = CGRect(x: 25, y: 44, width: 20, height: 20)
        backButton.addTarget(self, action: #selector(back), for: UIControl.Event.touchUpInside)
        self.view.addSubview(backButton)
        //前后摄像头切换
        let changeBtn = UIButton.init()
        changeBtn.frame = CGRect.init(x: 321, y:720, width: 29, height: 29)
        changeBtn.setImage(UIImage.init(named: "zipai"), for: UIControl.State.normal)
        changeBtn.addTarget(self, action: #selector(changeCamera), for: .touchUpInside)
        view.addSubview(changeBtn)
        //拍照按钮
        photoButton = UIButton(type: .custom)
        photoButton?.frame = CGRect(x: 150, y: 700, width: 74, height: 74)
        photoButton?.setImage(UIImage(named: "take_photo"), for: .normal)
        photoButton?.addTarget(self, action: #selector(shutterCamera), for: .touchUpInside)
        view.addSubview(photoButton!)
        
        //闪光灯按钮
        flashButton = UIButton.init()
        flashButton?.frame = CGRect.init(x: 321, y:42, width: 29, height: 29)
        flashButton?.addTarget(self, action: #selector(flashAction), for: .touchUpInside)
        flashButton?.setImage(UIImage.init(named: "flash_close"), for: UIControl.State.normal)
        view.addSubview(flashButton!)
        
        //查看相册按钮
        libraryButton = UIButton.init()
        libraryButton?.frame = CGRect.init(x: 17, y: KScreenH - 105, width: 60, height: 60)
        libraryButton?.addTarget(self, action: #selector(libraryAction), for: .touchUpInside)
        libraryButton?.setImage(UIImage.init(named:"manuel-cosentino-691602-unsplash"), for: .normal)
        view.addSubview(libraryButton!)
        
        //选择语言按钮
        languageButton = UIButton.init()
        languageButton?.frame = CGRect.init(x: 284, y: 722, width: 32, height: 32)
        languageButton?.addTarget(self, action: #selector(languageAction), for: .touchUpInside)
        languageButton?.setImage(UIImage.init(named:"close"), for: .normal)
//        view.addSubview(languageButton!)
        
    }
    @objc func changeCamera(){
        //1.获取摄像头，并且改变原有的摄像头
        guard var position = input?.device.position else { return }
        
        //获取当前应该显示的镜头
        position = position == .front ? .back : .front
        //2.重新创建输入设备对象
        //创建新的device
        let devices = AVCaptureDevice.devices(for: AVMediaType.video) as [AVCaptureDevice]
        for devic in devices{
            if devic.position==position{
                device = devic
            }
        }
        //input
        guard let videoInput = try? AVCaptureDeviceInput(device: device!) else { return }
        //3. 改变会话的配置前一定要先开启配置，配置完成后提交配置改变
        session.beginConfiguration()
        //移除原有设备输入对象
        session.removeInput(input)
        //添加新的输入对象
        //添加输入到会话中
        if(self.session.canAddInput(videoInput)){
            self.session.addInput(videoInput)
        }
        //提交会话配置
        session.commitConfiguration()
        //切换
        self.input = videoInput
    }
    
    
    //MARK:拍照按钮点击事件
@objc func shutterCamera(){
    videoConnection = photoOutput.connection(with: AVMediaType.video)
    
        guard videoConnection != nil else {
            print("take photo failed!")
            return
        }
    if #available(iOS 11.0, *) {
        setting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
    } else {
        // Fallback on earlier versions
       // setting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
    }
    setting?.flashMode = AVCaptureDevice.FlashMode.off
    photoButton?.isUserInteractionEnabled = false
    setting = AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])
        photoOutput.capturePhoto(with: setting!, delegate: self)
    }
    
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
//        print("didFinishProcessingPhoto")
//        //check error
//        guard error == nil else {
//            print(error)
//            return
//        }
//                session.stopRunning()//停止
//              let data = photo.fileDataRepresentation();
//            image = UIImage.init(data: data!)
//            imageView = UIImageView.init(image: image)
//            view.addSubview(imageView!)
//    }
    @objc func flashAction(){
        
        try? device.lockForConfiguration()
        if device.position ==  .front {//前置不要打开
            return
        }
        
        isflash = !isflash//改变闪光灯
        try? device.lockForConfiguration()
        if(isflash){//开启
            //开启闪光灯方法一     level取值0-1
            //    guard ((try? device.setTorchModeOn(level: 0.5)) != nil) else {
            //        print("闪光灯开启出错")
            //        return
            //    }
            device.torchMode = .on//开启闪光灯方法二
            flashButton?.setImage(UIImage.init(named:"flash_open"), for: .normal)
            
        }else{//关闭
            if device.hasTorch {
                device.torchMode = .off//关闭闪光灯
                flashButton?.setImage(UIImage.init(named: "flash_close"), for: UIControl.State.normal)
            }
            
        }
        device.unlockForConfiguration()
    }
    
    //打开相册
    @objc func libraryAction(){
        let photoPicker =  UIImagePickerController()
        photoPicker.delegate = self
        //as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        photoPicker.allowsEditing = true
        photoPicker.sourceType = .photoLibrary
        //在需要的地方present出来
        self.present(photoPicker, animated: true, completion: nil)
        
    }
    //点击切换语言
    @objc func languageAction(){
        isChinese = !isChinese
        if (isChinese) {
            languageButton?.setImage(UIImage(named:"Chinese"), for: .normal)
        }
        else{
            languageButton?.setImage(UIImage(named:"Japanese"), for: .normal)
        }
        
    }
    //点击返回上一界面
    @objc func back(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    //segment改变函数
    @objc func segmentDidchange(segmented:UISegmentedControl){
        //获得选项的索引
        print(segmented.selectedSegmentIndex)
        //获得选择的文字
        //print(segmented.titleForSegment(at: segmented.selectedSegmentIndex))
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var simage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if simage == nil {
            self.dismiss(animated: true, completion: nil)
            return
        }
        //图片方向纠正
        self.dismiss(animated: true, completion: nil)
        //        self.imageView.isHidden = false
        //        self.imageView.image = image
        //        self.previewLayer.isHidden = true
        self.image = simage
        //self.goSHibie()
        self.goHome()
    }
    func goHome(){
        self.dismiss(animated: true, completion: nil)
        if let dele = self.delegate{
            if chooseModel?.selectedSegmentIndex==0{
                if let im = image{
                   dele.touristByImage(image: im)
                }
                
            }else if chooseModel?.selectedSegmentIndex==1{
                if let im = image{
                    dele.ocrbyImage(image: im)
                }
                
            }else{
                
            }
        }
        
    }
}
extension WYCustomCameraViewController :AVCapturePhotoCaptureDelegate{
    
    
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingLivePhotoToMovieFileAt outputFileURL: URL, duration: CMTime, photoDisplayTime: CMTime, resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
//
//    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        
        
    }
        func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
            print("didFinishProcessingPhoto")
            //check error
            guard error == nil else {
                print(error)
                return
            }
                    session.stopRunning()//停止
                  let data = photo.fileDataRepresentation();
                image = UIImage.init(data: data!)
                imageView = UIImageView.init(image: image)
                self.goHome()
                //view.addSubview(imageView!)
        }
    
}
