//
//  LocationManager.swift
//  projectDemo
//
//  Created by Cheng on 2021/11/22.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    public static let shared = LocationManager()
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// 定位服务必须设置为全局变量
    lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        /// 刷新频率
        manager.distanceFilter = kCLLocationAccuracyNearestTenMeters
        /// 定位精确度
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        /// 首先请求总是访问权限
        manager.requestAlwaysAuthorization()
        /// 然后请求使用期间访问权限
        manager.requestWhenInUseAuthorization()
        /// 是否允许系统自动暂停位置更新服务，默认为 true，设置为 false，否则会自动暂停定位服务，app 20分钟后就不会上传位置了
        manager.pausesLocationUpdatesAutomatically = false
        /// 允许后台定位
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    /// 定时器
    var locationTimer: Timer?
    
    /// 请求后台持续GPS定位服务
    func availableLocationService() {
        let locationServicesEnabled = CLLocationManager.locationServicesEnabled()
        guard locationServicesEnabled else {
            UIView().makeToast("您的定位服务已关闭,请到[设置]->[隐私]中打开[定位服务]为了App记录您的实时位置和行走轨迹")
            return
        }
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .notDetermined, .authorizedWhenInUse:
            startLocation()
            break
        default: break

        }
    }
    /// 进入前台
    @objc private func didBecomeActive() {
        DDLogInfo("进入前台")
        locationTimer?.invalidate()
        locationTimer = nil
    }
    /// 进入后台
    @objc private func didEnterBackground() {
        DDLogInfo("进入后台")
//        if locationTimer == nil {
//            locationTimer = Timer.scheduledTimer(timeInterval: 150, target: self, selector: #selector(startLocation), userInfo: nil, repeats: true)
//        }
    }
    /// 计时器事件
    @objc private func timerDidAction() {
//        startLocation()
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+5) { [weak self] in
//            self?.endLocation()
//        }
//        let _ = LocationBgTask.shared.beginNewBackgroundTask()
    }
    /// 开始定位
    @objc private func startLocation() {
        DDLogInfo("开始定位")
        locationManager.startUpdatingLocation()
    }
    /// 结束定位
    @objc private func endLocation() {
        DDLogInfo("结束定位")
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // WGS-84 坐标，GPS 原生数据
        guard let coor = locations.last?.coordinate else { return }
        DDLogInfo("WGS84:\(coor)")
    }
        
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DDLogInfo("定位失败 error为\(error)")
    }
}
