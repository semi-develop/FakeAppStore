//
//  AppDetailBasicTableViewCell.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/12/02.
//

import UIKit

class AppDetailBasicTableViewCell: UITableViewCell {

    @IBOutlet weak var appImg: UIImageView!
    @IBOutlet weak var appNameLb: UILabel!
    @IBOutlet weak var appDeveloperLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
