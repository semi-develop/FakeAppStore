//
//  NetworkManager.swift
//  FakeAppStore
//
//  Created by user on 2021/12/16.
//


import Foundation
import Network
import UIKit


class NetworkCheck{
    static let networkCk = NetworkCheck()
    
    private let monitor:NWPathMonitor
    private var isConnected: Bool = false
    
    init(){
        monitor = NWPathMonitor()
    }
    
    func startMonitor(){
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            NotificationCenter.default.post(name: Notification.Name.networkStateNoti, object: nil, userInfo: [Shared.networNotiInfoKey: self?.isConnected ?? true])
        }
    }
    
    func isConnect() -> Bool{
        return isConnected
    }
}




//private func getConenctionType(_ path:NWPath) {
//    print("getConenctionType 호출")
//    if path.usesInterfaceType(.wifi){
//        connectionType = .wifi
//        print("wifi에 연결")
//
//    }else if path.usesInterfaceType(.cellular) {
//        connectionType = .cellular
//        print("cellular에 연결")
//
//    }else if path.usesInterfaceType(.wiredEthernet) {
//        connectionType = .ethernet
//        print("wiredEthernet에 연결")
//
//    }else {
//        connectionType = .unknown
//        print("unknown ..")
//    }
//}
