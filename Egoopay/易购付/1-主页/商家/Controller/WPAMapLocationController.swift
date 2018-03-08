//
//  WPAMapLocationController.swift
//  Egoopay
//
//  Created by 易购付 on 2017/12/7.
//  Copyright © 2017年 Egoopay. All rights reserved.
//

import UIKit
import MapKit

class WPAMapLocationController: WPBaseViewPlainController, MAMapViewDelegate, AMapSearchDelegate, AMapLocationManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "地址"
        self.view.addSubview(mapView)
        initSearch()
        searchPOI(keyword: address)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**  城市 */
    var city = String()
    
    /**  地址 */
    var address = String()
    
//    /**  路线规划信息 */
//    var route = AMapRoute()
    
    /**  起始点经纬度 */
    var startCoordinate = CLLocationCoordinate2D()
    
    /**  终点经纬度 */
    var destinationCoordinate = CLLocationCoordinate2D()
    
    /**  1:驾车 2:公交 3:步行 */
    var routeType = 1
    
    var search: AMapSearchAPI!
    
    var customUserLocationView: MAAnnotationView!
    
    /**  底层的MapView */
    lazy var mapView: MAMapView = {
        let view = MAMapView(frame: self.view.bounds)
        view.delegate = self
        view.showsUserLocation = true
        view.setZoomLevel(15.0, animated: true)
        return view
    }()
    
    /**  底部的导航视图 */
    lazy var footer_view: WPAMapLocationView = {
        let view = WPAMapLocationView.init(frame: CGRect.init(x: 0, y: kScreenHeight - 192 - WPNavigationHeight, width: kScreenWidth, height: 192))
        view.address = address
        weak var weakSelf = self
        view.goToOtherAppType = {
            weakSelf?.goToOtherAppAction()
        }
        return view
    }()

    func initSearch() {
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    // MARK: - Action
    
    // 关键词搜索
    func searchPOI(keyword: String?) {
        if keyword == nil || keyword! == "" {
            return
        }
        let request = AMapPOIKeywordsSearchRequest()
        request.keywords = keyword
        request.requireExtension = true
        request.city = city
        search.aMapPOIKeywordsSearch(request)
    }
    
    // 路线查询
    func searchRoutePlanning(type: NSInteger) {
        switch type {
        case 1: // 驾车
            let driving = AMapDrivingRouteSearchRequest()
            driving.requireExtension = true
            driving.origin = AMapGeoPoint.location(withLatitude: CGFloat(self.startCoordinate.latitude), longitude: CGFloat(self.startCoordinate.longitude))
            driving.destination = AMapGeoPoint.location(withLatitude: CGFloat(self.destinationCoordinate.latitude), longitude: CGFloat(self.destinationCoordinate.longitude))
            search.aMapDrivingRouteSearch(driving)
        case 2: // 公交
            let bus = AMapTransitRouteSearchRequest()
            bus.requireExtension = true
            bus.city = self.city
            bus.origin = AMapGeoPoint.location(withLatitude: CGFloat(self.startCoordinate.latitude), longitude: CGFloat(self.startCoordinate.longitude))
            bus.destination = AMapGeoPoint.location(withLatitude: CGFloat(self.destinationCoordinate.latitude), longitude: CGFloat(self.destinationCoordinate.longitude))
            search.aMapTransitRouteSearch(bus)
        case 3: // 步行
            let walk = AMapWalkingRouteSearchRequest()
            walk.origin = AMapGeoPoint.location(withLatitude: CGFloat(self.startCoordinate.latitude), longitude: CGFloat(self.startCoordinate.longitude))
            walk.destination = AMapGeoPoint.location(withLatitude: CGFloat(self.destinationCoordinate.latitude), longitude: CGFloat(self.destinationCoordinate.longitude))
            search.aMapWalkingRouteSearch(walk)
        default:
            break
        }
    }
    
    
    // MARK: - MAMapViewDelegate
    
    func mapView(_ mapView: MAMapView!, annotationView view: MAAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        print("name: \(String(describing: view.annotation.title))")
    }
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        // 目的地
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.isDraggable = false
            
//            let rightButton = UIButton.init(type: .detailDisclosure)
//            rightButton.addTarget(self, action: #selector(self.rightButtonAction), for: .touchUpInside)
//
//            annotationView!.rightCalloutAccessoryView = rightButton

            return annotationView!
        }
        
        // 自己
        if annotation.isKind(of: MAUserLocation.self) {
            let pointReuseIndetifier = "userLocationStyleReuseIndetifier"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
            
            if annotationView == nil {
                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView?.image = #imageLiteral(resourceName: "userPosition")
            
            customUserLocationView = annotationView
            
            return annotationView!
        }
        
        return nil
    }
    
    //设备方向改变，刷新数据
    func mapView(_ mapView:MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation:Bool ) {
        if(!updatingLocation && self.customUserLocationView != nil) {
            // 根据用户方向改变箭头的方向
            UIView.animate(withDuration: 0.1, animations: {
                let degree = userLocation.heading.trueHeading - Double(self.mapView.rotationDegree)
                let radian = (degree * Double.pi) / 180.0
                self.customUserLocationView.transform = CGAffineTransform.init(rotationAngle: CGFloat(radian))
            })
        }
        // 自己的经纬度
        self.startCoordinate = userLocation.coordinate
    }
    
    //MARK: - AMapSearchDelegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        print("定位自己的位置惜败")
        
    }
    
    // 获取查找的位置信息
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        
        mapView.removeAnnotations(mapView.annotations)
        
        if response.count == 0 {
            return
        }
        
        var annos = Array<MAPointAnnotation>()
        
//        for aPOI in response.pois {
            let aPOI = response.pois[0] as! AMapPOI
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(aPOI.location.latitude), longitude: CLLocationDegrees(aPOI.location.longitude))
            let anno = MAPointAnnotation()
            anno.coordinate = coordinate
            anno.title = aPOI.name
            anno.subtitle = aPOI.address
            annos.append(anno)
//        }
        mapView.addAnnotations(annos)
//        mapView.showAnnotations(annos, animated: true)
        mapView.selectAnnotation(annos.first, animated: true)
        
        // 终点的经纬度
        self.destinationCoordinate = coordinate
        
        self.searchRoutePlanning(type: 1)
    }
    
    // 获取规划路线
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        if response.route == nil {
            return
        }
        
        /**  距离 */
        var distance = NSInteger()
        
        /**  时间 */
        var duration = NSInteger()
        
        //获取到数据，添加导航视图
        self.view.addSubview(footer_view)
        
        let cell: WPAMapLocationCell = footer_view.tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! WPAMapLocationCell

        
        switch routeType {
        case 1, 3: // 驾车、步行
            //判断驾车/步行方案数组是否为空
            if response.route.paths.count > 0 {
                let path: AMapPath = response.route.paths[0] as! AMapPath
                distance = path.distance
                duration = path.duration
            }
            else {
                
            }
        default: // 公交
            //判断公交方案数组是否为空
            if response.route.transits.count > 0 {
                let transit: AMapTransit = response.route.transits[0] as! AMapTransit
                distance = transit.distance
                duration = transit.duration
            }
        }
        
        //时间
        let h = duration / 3600
        let m = (duration % 3600) / 60
        let s = (duration % 3600) % 60
        let time = (h > 0 ? String(format: "%d小时", h) : "") + (m > 0 ? String(format: "%d分钟", m) : "") + (duration < 60 ? (s > 0 ? String(format: "%d秒", s) : "") : "")
        
        switch routeType {
        case 1: //驾车
            cell.distance_label.text = distance > 1000 ? String(format: "%.1fkm", Float(distance) / 1000) : String(format: "%ldm", NSInteger(distance)) //默认显示驾车的距离
            footer_view.taxiDistance = Float(distance)
            cell.taxi_label.text = time != "" ? time : "距离太近"
        case 2: //公交
            footer_view.busDistance = Float(distance)
            cell.bus_label.text = time != "" ? time : (footer_view.taxiDistance > 5000 ? "距离太远" : "距离太近")
        case 3: //步行
            footer_view.walkDistance = Float(distance)
            cell.walk_label.text = time != "" ? time : "距离太远"
        default:
            break
        }
        
        //分别得到驾车、公交、步行路线规划
        if routeType < 3 {
            routeType = routeType + 1
            searchRoutePlanning(type: routeType)
        }
    }
    
    // MARK: - 跳转到地图APP
    
    @objc func goToOtherAppAction() {
        
        let alertController = UIAlertController.init(title: "选择地图", message: nil, preferredStyle: .actionSheet)
        
        weak var weakSelf = self
        alertController.addAction(UIAlertAction.init(title: "苹果地图", style: .default, handler: { (action) in
            let currentLocation = MKMapItem.forCurrentLocation()
            let toLocation = MKMapItem.init(placemark: MKPlacemark.init(coordinate: (weakSelf?.destinationCoordinate)!))
            toLocation.name = weakSelf?.address
            
            MKMapItem.openMaps(with: [currentLocation, toLocation], launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving, MKLaunchOptionsShowsTrafficKey : NSNumber.init(booleanLiteral: true)])
        }))
        
        if UIApplication.shared.canOpenURL(URL.init(string: "iosamap://path")!) {
            alertController.addAction(UIAlertAction.init(title: "高德地图", style: .default, handler: { (action) in
                let url = "iosamap://path?sourceApplication=applicationName" + "&sid=BGVIS1" + "&name=" + "我的位置" + "&did=BGVIS2" + "&dname=" + (weakSelf?.address)! + "&dev=0" + "&t=0"
                UIApplication.shared.open(URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, options: [:], completionHandler: nil)
            }))
        }
        
        if UIApplication.shared.canOpenURL(URL.init(string: "baidumap://map/maker")!) {
            alertController.addAction(UIAlertAction.init(title: "百度地图", style: .default, handler: { (action) in
                let url = "baidumap://map/direction?origin=" + "我的位置" + "&destination=" + (weakSelf?.address)! + "&mode=driving" + "&region=" + (weakSelf?.city)!
                UIApplication.shared.open(URL.init(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!, options: [:], completionHandler: nil)
            }))
        }
        
        alertController.addAction(UIAlertAction.init(title: "取消", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
}
