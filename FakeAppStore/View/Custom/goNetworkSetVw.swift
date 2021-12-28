//
//  goNetworkSetVw.swift
//  FakeAppStore
//
//  Created by user on 2021/12/24.
//

import UIKit
import Foundation


class goNetworkSetVw:UIView{
    
    
    @IBAction func goSetting(_ sender: UIButton) {
            UIApplication.shared.open(URL(string: Url.systemSettingUrl)!)
    }
}
