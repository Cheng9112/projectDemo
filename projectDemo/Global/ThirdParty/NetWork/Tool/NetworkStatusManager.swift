//
//  NetworkStatusManager.swift
//  projectDemo
//
//  Created by Cheng on 2022/4/28.
//

import UIKit
import Alamofire

enum NetworkStatus {
    case unknown
    case notReachable
    case reachableWiFi
    case reachableCellular
    
    public var encode: Int {
        switch self {
        case .unknown:
            return 0
        case .notReachable:
            return 1
        case .reachableWiFi:
            return 2
        case .reachableCellular:
            return 3
        }
    }
    
    public var statusStr: String {
        switch self {
        case .unknown:
            return "未知"
        case .notReachable:
            return "无网络"
        case .reachableWiFi:
            return "Wi-Fi"
        case .reachableCellular:
            return "手机流量"
        }
    }
}

class NetworkStatusManager: NSObject {

    static let shared = NetworkStatusManager()
    
    private lazy var manager: NetworkReachabilityManager? = NetworkReachabilityManager.init()
    
    public var networkStatus: NetworkStatus = .unknown
    
    override init() {
        super.init()
    }
    
    func networkReachablility(status: @escaping(NetworkStatus) -> Void) {
        
        manager?.startListening(onUpdatePerforming: { [weak self] networkStatus in
            
            switch networkStatus {
            case .notReachable:
                self?.networkStatus = .notReachable
                status(.notReachable)
                break;
            case .reachable(.ethernetOrWiFi):
                self?.networkStatus = .reachableWiFi
                status(.reachableWiFi)
                break;
            case .reachable(.cellular):
                self?.networkStatus = .reachableCellular
                status(.reachableCellular)
                break;
            default:
                self?.networkStatus = .unknown
                status(.unknown)
                break;
            }
        })
    }
}
