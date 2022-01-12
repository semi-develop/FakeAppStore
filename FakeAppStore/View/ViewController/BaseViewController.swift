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
        
        self.connectNetwork(is: NetworkCheck.networkCk.isConnect())
        
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
    
    func imgSizeArrayFromUrl(url:String) -> (width:Int, height:Int){ //하드 코딩해야하는 부분임.. 크기에 대해 값이 내려오진않는다.
        
        var imgNm = url.components(separatedBy: "/").last
        imgNm = imgNm?.components(separatedBy: ".").first?.replace(target: "bb", to: "")
        let imgSize = imgNm?.components(separatedBy: "x")

        return (width: Int(imgSize![0])!, height: Int(imgSize![1])!)
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
        let alert = UIAlertController(title: "오류", message: "네트워크 에러. 다시 시도해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler : nil))
        present(alert, animated: false, completion: nil)
        //connectNetwork(is: false)
    }
    
    
    func failRequest(){
        print("failRequest")
        let alert = UIAlertController(title: "오류", message: "다시 한번 시도해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler : nil))
        present(alert, animated: false, completion: nil)
    }
}

