//
//  CustomTabBarController.swift
//  FakeAppStore
//
//  Created by user on 2022/01/03.
//

import Foundation
import UIKit

class CustomTabBarController:UITabBarController{
    let NoNetworkVw = GoNetworkSetVw(frame: CGRect(x: 0, y: 0, width: Size.screenSizeW, height: Size.screenSizeH))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !NetworkCheck.networkCk.isConnect(){
            self.connectNetwork(is: false)
        }
        
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name.networkStateNoti,
            object: nil, queue: nil){
                noti in
                print("networkStateNoti")
                guard let isConnect = (noti.userInfo?[Noti.networNotiInfoKey] as? Bool) else{return}
                DispatchQueue.main.async {
                    self.connectNetwork(is: isConnect)
                }
            }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.networkStateNoti , object: nil)
    }
    
    
    func connectNetwork(is connect: Bool){
        print("network connect is \(connect)")
        if connect{
            //NoNetworkVw.removeFromSuperview()
        }else{
            self.selectedViewController?.view.addSubview(NoNetworkVw)
            
//            for imgVw in self.selectedViewController!.presentingViewController!.view.subviews
//            {
//                print("view is \(imgVw)")
//            }
        }
    }
}
