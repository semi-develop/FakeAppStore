//
//  AppDetailDescTableViewCell.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/12/02.
//

import UIKit

protocol ReadMoreDelegate: AnyObject{
    func readMoreIn(cell: AppDetailDescTableViewCell)
}

class AppDetailDescTableViewCell: UITableViewCell {

    
    @IBOutlet weak var readMoreVw: UIView!
    @IBOutlet weak var descLb: UILabel!
    @IBOutlet weak var readMoreBtn: UIButton!
    @IBOutlet weak var developerBtn: UIButton!

    var readMoreDelegate:ReadMoreDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func readMoreClick(_ sender: Any) {
        readMoreDelegate?.readMoreIn(cell: self )
    }
}
