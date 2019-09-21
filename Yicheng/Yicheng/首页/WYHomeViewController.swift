//
//  WYHomeViewController.swift
//  Yicheng
//
//  Created by 王焱 on 2019/3/2.
//  Copyright © 2019年 王焱. All rights reserved.
//

import UIKit

class WYHomeViewController: UIViewController,AMapSearchDelegate,MAMapViewDelegate,AMapLocationManagerDelegate,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating{
    //景点识别回调参数
//    var needSearch:Bool?
//    var needSearchName:String?
    var searchController: UISearchController!
    var tableView: UITableView!
    var tableData: Array<AMapTip>!
    var currentRequest: AMapInputTipsSearchRequest?
    
    var locationManager: AMapLocationManager!
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableData = Array()
        AMapServices.shared().apiKey = MAPKEY
        initMapView()
        initSearch()
        setupUI()
        setupLocation()
        setupTableView()
        setupSearchController()
        self.locate()
        
        print(self.searchController.isActive)
        print(self.tableView.isHidden)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        searchController.isActive = false
//        searchController.searchBar.removeFromSuperview()
    }
    func setupUI(){
        let locationBtn=UIButton()
        locationBtn.setImage(UIImage.init(named: "loc"), for: UIControl.State.normal)
        locationBtn.setBackgroundImage(UIImage.init(named: "gps_frame"), for: UIControl.State.normal)
        locationBtn.sizeToFit()
        locationBtn.frame.origin.y = (self.navigationController?.navigationBar.frame.origin.y)! - 10
        locationBtn.frame.origin.x = 20
        locationBtn.addTarget(self, action: #selector(locate), for: .touchUpInside)
        self.view.addSubview(locationBtn)
    }
    func setupTableView(){
        let tableY = self.navigationController!.navigationBar.frame.maxY
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - tableY), style: UITableView.Style.plain)
        print(tableY)
        tableView.autoresizingMask = [UIView.AutoresizingMask.flexibleHeight, UIView.AutoresizingMask.flexibleWidth]
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        self.view.addSubview(tableView)
    }
    func setupSearchController(){
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = false;
        searchController.hidesNavigationBarDuringPresentation = false;
        
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "请输入关键字"
        searchController.searchBar.sizeToFit()
        if #available(iOS 9.0, *) {
            self.searchController.loadViewIfNeeded()
        } else {
            // Fallback on earlier versions
            let _ = self.searchController.view
        }
        self.navigationItem.titleView = searchController.searchBar
    }
    func searchTip(withKeyword keyword: String?) {
        
        //print("keyword \(String(describing: keyword))")
        if keyword == nil || keyword! == "" {
            return
        }
        
        let request = AMapInputTipsSearchRequest()
        request.keywords = keyword
        
        currentRequest = request
        search.aMapInputTipsSearch(request)
    }
    //MARK:- UISearchBarDelegate
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        
        print("begin")
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        print("search")
    }
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        if currentRequest == nil || currentRequest! != request {
            return
        }
        
        if response.count == 0 {
            return
        }
        
        tableData.removeAll()
        for aTip in response.tips {
            tableData.append(aTip)
        }
        tableView.reloadData()
    }
    //MARK:- UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        print("update active \(searchController.isActive)")
        tableView.isHidden = !searchController.isActive
        searchTip(withKeyword: searchController.searchBar.text)
        
        if searchController.isActive && searchController.searchBar.text != "" {
            searchController.searchBar.placeholder = searchController.searchBar.text
        }
    }
    //MARK:- TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        mapView.removeAnnotations(mapView.annotations)
        
        let tip = tableData[indexPath.row]
        
        if tip.location != nil {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(tip.location.latitude), longitude: CLLocationDegrees(tip.location.longitude))
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = tip.name
            anno.subtitle = tip.address
            
            mapView.addAnnotation(anno)
            mapView.selectAnnotation(anno, animated: true)
        }
        
        searchController.isActive = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    //MARK:- TableViewDataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "demoCellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil {
            
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellIdentifier)
        }
        
        if !tableData.isEmpty {
            
            let tip = tableData[indexPath.row]
            
            cell!.textLabel?.text = tip.name
            cell!.detailTextLabel?.text = tip.address
        }
        
        return cell!
    }
    @objc func locate(){
        
        
        locationManager.requestLocation(withReGeocode: true, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            
            if let error = error {
                let error = error as NSError
               
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
//                    NSLog("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
//                    NSLog("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                    let user = WYUser()
                    WYUserManager.sharedManager().user = user
                    WYUserManager.sharedManager().user?.location = reGeocode?.city
                    WYUserManager.sharedManager().user?.latitude = Float((location?.coordinate.latitude)!)
                    WYUserManager.sharedManager().user?.longitude = Float((location?.coordinate.longitude)!)
                    let pointAnnotation = MAPointAnnotation()
                    pointAnnotation.coordinate = location?.coordinate ?? CLLocationCoordinate2DMake(0,0)
                    pointAnnotation.title = String(format: "lat:%f;lon:%f;",[location?.coordinate.latitude, location?.coordinate.longitude])
//                    pointAnnotation.subtitle = String(format: "%@-%@-%.2fm", [reGeocode?.citycode,reGeocode?.adcode,location?.horizontalAccuracy])
                    self?.mapView.addAnnotation(pointAnnotation)
                    self?.mapView.selectAnnotation(pointAnnotation, animated: true)
                    self?.mapView.setZoomLevel(15.1, animated: false)
                    self?.mapView.setCenter(pointAnnotation.coordinate, animated: true)
                   
                }
            }
                else {
                    //没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
                    print(" loaction button clicked3")
                    let pointAnnotation = MAPointAnnotation()
                    pointAnnotation.coordinate = location?.coordinate ?? CLLocationCoordinate2DMake(0,0)
                    pointAnnotation.title = reGeocode?.formattedAddress
//                    pointAnnotation.subtitle = String(format: "%@-%@-%.2fm", [reGeocode?.citycode,reGeocode?.adcode,location?.horizontalAccuracy])
                
                
                let user = WYUser()
                print(user.latitude)
               print(user.longitude)
                WYUserManager.sharedManager().user = user
                WYUserManager.sharedManager().user?.location = reGeocode?.city
                WYUserManager.sharedManager().user?.latitude = Float((location?.coordinate.latitude)!)
                WYUserManager.sharedManager().user?.longitude = Float((location?.coordinate.longitude)!)
                    print(WYUserManager.sharedManager().user?.location)
                    self?.mapView.addAnnotation(pointAnnotation)
                    self?.mapView.selectAnnotation(pointAnnotation, animated: true)
                    self?.mapView.setZoomLevel(15.1, animated: false)
                    self?.mapView.setCenter(pointAnnotation.coordinate, animated: true)
                }
            })
            
//            if let location = location {
//                NSLog("location:%@", location)
//            }
//
//            if let reGeocode = reGeocode {
//                NSLog("reGeocode:%@", reGeocode)
//            }
    }
    func initMapView() {

        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.showsScale = false
        self.view.addSubview(mapView!)
    }
    
    func setupLocation(){
        
        locationManager = AMapLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.locationTimeout = 2
        
        locationManager.reGeocodeTimeout = 2
    }
    
    func initSearch() {
        //        AMap
        search = AMapSearchAPI()
        search.delegate = self
    }
@objc func searchPOI(){
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = "福州大学"
        request.requireExtension = true
        request.city = "福州"
        request.types = "高等院校"
        request.cityLimit = true
        request.requireSubPOIs = true
        search.aMapPOIKeywordsSearch(request)
    }
    func gotoNearby(pois:NSMutableArray){
        let nav = self.tabBarController?.viewControllers?[1] as! UINavigationController
        let VC=nav.topViewController as! WYCollectionViewController
        VC.pois=pois
        self.tabBarController?.selectedIndex = 1
    }
    //POI搜索结果
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        mapView.removeAnnotations(mapView.annotations)
        if response.count == 0 {
            return
        }
        
        var annos = Array<MAPointAnnotation>()
        let pois = NSMutableArray()
        for aPOI in response.pois {
            let model = WYPOI()
            model.address = aPOI.address
            model.name = aPOI.name
            model.tel = aPOI.tel
            model.distance = aPOI.distance
            
//            print("距离!!!\(aPOI.distance)")
            pois.add(model)
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = aPOI.name
            anno.subtitle = aPOI.address
            annos.append(anno)
        }
        mapView.addAnnotations(annos)
        mapView.showAnnotations(annos, animated: false)
        mapView.selectAnnotation(annos.first, animated: true)
        self.gotoNearby(pois: pois)
        
    }
    //AMMapViewDelegate
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)
            
//            let idx = annotation.index(of: annotation as! MAPointAnnotation)
            annotationView!.pinColor = MAPinAnnotationColor(rawValue: 0)!
            
            return annotationView!
        }
        
        return nil
    }
    // 发起逆地理编码请求
    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        self.search!.aMapReGoecodeSearch(regeo)
    }
    
    //MARK:- MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, didLongPressedAt coordinate: CLLocationCoordinate2D) {
        // 长按地图触发回调，在长按点进行逆地理编码查询
        searchReGeocodeWithCoordinate(coordinate: coordinate)
    }
    
    //MARK:- AMapSearchDelegate
    func aMapSearchRequest(_ request: Any?, didFailWithError error: Error?) {
        print("request :\(request ?? ""), error: \(String(describing: error))")
    }
    
    // 逆地理查询回调
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        
        print("response :\(response.formattedDescription() ?? "")")
        
        if (response.regeocode != nil) {
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            
            let annotation = MAPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = response.regeocode.formattedAddress
            annotation.subtitle = response.regeocode.addressComponent.province
            mapView!.addAnnotation(annotation)
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

}
