//
//  readMoreVw.swift
//  FakeAppStore
//
//  Created by user on 2022/01/06.
//

import UIKit
import Foundation

class ReadMoreVw:UIView{
    var view:UIView!
    
    @IBOutlet weak var descLb: UILabel!
    @IBOutlet weak var readMoreLb: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(){
        view = Bundle.main.loadNibNamed("ReadMoreVw", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func sizeToHeight(){
        //descLb.sizeToFit()
        descLb.bounds = CGRect(x: 0, y: 0, width: 300, height: 40)
        
        view.bounds = descLb.bounds
        self.bounds = view.bounds
        print("view.bounds \(view.bounds)")
        print("self.bounds \(self.bounds)")
    }
    
    func readMore() {
        print("read more")
        readMoreLb.isHidden = true
        readMoreLb.numberOfLines = 0
        descLb.sizeToFit()
        
    }
}
