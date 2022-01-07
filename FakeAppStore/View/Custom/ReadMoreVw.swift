//
//  readMoreVw.swift
//  FakeAppStore
//
//  Created by user on 2022/01/06.
//

import UIKit
import Foundation

class ReadMoreVw:UIView{
    @IBOutlet weak var descLb: UILabel!
    @IBOutlet weak var readMoreLb: UILabel!
    
    
    private let xibName = "ReadMoreVw"
    
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
    
    func readMore() {
        print("read more")
        readMoreLb.isHidden = true
        readMoreLb.numberOfLines = 0
        
    }
}
