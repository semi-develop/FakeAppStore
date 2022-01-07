//
//  AppDetailDescTableViewCell.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/12/02.
//

import UIKit

class AppDetailDescTableViewCell: UITableViewCell {

    
    @IBOutlet weak var readMoreVw: ReadMoreVw!
    @IBOutlet weak var developerBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
