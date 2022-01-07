//
//  SearchContentTableViewCell.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/11/30.
//

import UIKit
import Cosmos

class SearchContentTableViewCell: UITableViewCell {

    @IBOutlet weak var appImg: UIImageView!
    @IBOutlet weak var appNameLb: UILabel!
    @IBOutlet weak var ratingVw: CosmosView!
    @IBOutlet weak var ratingLb: UILabel!
    @IBOutlet weak var screenshotsVw: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
