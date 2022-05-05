//
//  NetworkStatusManager.swift
//  projectDemo
//
//  Created by Cheng on 2022/4/28.
//

import UIKit
import Alamofire

enum NetworkStatus {
    case notReachable
    case unknown
    case reachableWiFi
    case reachableCellular
}

class NetworkStatusManager: NSObject {

    static let shared = NetworkStatusManager()
    
    var networkStatus: NetworkStatus = .unknown
    
    override init() {
        super.init()
    }
    
    func networkReachablility(status: @escaping(NetworkStatus) -> Void) {
        
        let manager = NetworkReachabilityManager.init()
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
