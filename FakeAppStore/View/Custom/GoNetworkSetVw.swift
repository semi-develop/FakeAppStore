//
//  goNetworkSetVw.swift
//  FakeAppStore
//
//  Created by user on 2021/12/24.
//

import UIKit
import Foundation


class GoNetworkSetVw:UIView{
    private let xibName = "GoNetworkSetVw"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        let view = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    @IBAction func goSetting(_ sender: UIButton) {
            UIApplication.shared.open(URL(string: Url.systemSettingUrl)!)
    }
}
