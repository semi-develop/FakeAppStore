//
//  AppDetailFeatureTableViewCell.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/12/02.
//

import UIKit

class AppDetailSummaryTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource{

    let collectviewCellId = "review"
    
    @IBOutlet weak var summaryCV: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        summaryCV.delegate = self
        summaryCV.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Shared.AppDetailSummaryCVCell.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectviewCellId, for: indexPath) as! AppDetailSummaryCollectionViewCell
    
        //작성
        
        return cell
    }
    
    
}
