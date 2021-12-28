//
//  BasicViewController.swift
//  FakeAppStore
//
//  Created by user on 2021/12/23.
//

import UIKit

class BaseViewController: UIViewController {

    let NoNetworkVw = goNetworkSetVw(frame: CGRect(x: 0, y: 0, width: Size.screenSizeW, height: Size.screenSizeH))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("BaseViewController viewDidLoad")
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "MessageReceived"),object: nil))
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests(completionHandler: { requests in
            print(requests)
        })
//
//        NotificationCenter.default.addObserver(
//                forName: NSNotification.Name.networkStateNoti,
//                object: nil, queue: nil){
//                    noti in
//                    print("NSNotification networkStateNoti")
//                    guard let isConnect = (noti.userInfo?[Noti.networNotiInfoKey] as? Bool) else{return}
//                    DispatchQueue.main.async {
//                        self.connectNetwork(is: isConnect)
//                    }
//                }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.networkStateNoti , object: nil)
    }
    
    func connectNetwork(is connect: Bool){
        print("network connect is \(connect)")
        if connect{
            self.view.addSubview(NoNetworkVw)
        }else{
            NoNetworkVw.removeFromSuperview()
        }
    }
    
    func networkError() {
        print("networkError")
        connectNetwork(is: false)
    }
}

