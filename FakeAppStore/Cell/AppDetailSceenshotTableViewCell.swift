//
//  AppDetailSceenshotTableViewCell.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/12/02.
//

import UIKit

class AppDetailSceenshotTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    var screenshotList:[String] = []

    let collectviewCellId = "screenshot"
    
    @IBOutlet weak var collectionVw: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionVw.delegate = self
        collectionVw.dataSource = self
        collectionVw.collectionViewLayout.invalidateLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return screenshotList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectviewCellId, for: indexPath) as! AppDetailSceenshotCollectionViewCell
        
        cell.screenshotImg.imgFromUrl(url: screenshotList[indexPath.row])
        cell.screenshotImg.layer.cornerRadius = Shared.cornerRadius
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 194, height: 368) //사진 크기 1/4
    }
}
