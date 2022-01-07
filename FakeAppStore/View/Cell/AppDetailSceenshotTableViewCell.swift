//
//  AppDetailSceenshotTableViewCell.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/12/02.
//

import UIKit

class AppDetailSceenshotTableViewCell: UITableViewCell  {
    
    @IBOutlet weak var screenshotsSc: UIScrollView!
    @IBOutlet weak var screenshotsVw: UIView!
    
    var screenshotList:[String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
