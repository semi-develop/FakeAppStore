//
//  BasicViewController.swift
//  FakeAppStore
//
//  Created by user on 2021/12/23.
//

import UIKit

class BaseViewController: UIViewController {
    lazy var NoNetworkVw = GoNetworkSetVw(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name:NSNotification.Name.networkStateNoti , object: nil)
    }
    
    
    func connectNetwork(is connect: Bool){
        print("network connect is \(connect)")
        if connect{
            NoNetworkVw.removeFromSuperview()
        }else{
            self.view.addSubview(NoNetworkVw)
        }
    }
    
    func networkError() {
        print("networkError")
        //connectNetwork(is: false)
    }
    
    
    func failRequest(){
        print("failRequest")
        let alert = UIAlertController(title: "오류", message: "다시 한번 시도해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler : nil))
        present(alert, animated: false, completion: nil)
    }
}

