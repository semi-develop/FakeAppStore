//
//  SeachDetailViewController.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/11/28.
//

import UIKit

class AppDetailViewController: UIViewController {
    @IBOutlet weak var 메: UITableView!
    
    var appInfo:AppInfo! //값을 넘겨받지 않으면 애초에 안넘어옴
    var appImg:UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController!.navigationBar.sizeToFit()
    }


}

extension AppDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Shared.AppDetailTbCell.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case Shared.AppDetailTbCell.basic:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic") as! AppDetailBasicTableViewCell
            cell.appImg.imgFromUrl(url: appInfo.artworkUrl512)
            cell.appImg.layer.cornerRadius = Shared.cornerRadius
            cell.appNameLb.text = appInfo.trackName
            cell.appDeveloperLb.text = appInfo.artistName
            return cell
            
        case Shared.AppDetailTbCell.summary:
            let cell = tableView.dequeueReusableCell(withIdentifier: "summary") as! AppDetailSummaryTableViewCell
            return cell
            
        case Shared.AppDetailTbCell.screenshot:
            let cell = tableView.dequeueReusableCell(withIdentifier: "screenshot") as! AppDetailSceenshotTableViewCell
            cell.screenshotList = appInfo.screenshotUrls

            return cell
            
        case Shared.AppDetailTbCell.desc:
            let cell = tableView.dequeueReusableCell(withIdentifier: "desc") as! AppDetailDescTableViewCell
            cell.descLb.text = appInfo.description
            
            return cell
            
        case Shared.AppDetailTbCell.update:
            let cell = tableView.dequeueReusableCell(withIdentifier: "update") as! AppDetailDescTableViewCell
            cell.descLb.text = appInfo.releaseNotes
            
            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row{
        case Shared.AppDetailTbCell.basic:
            return 100
            
        case Shared.AppDetailTbCell.summary:
            return 0 //수정중
            
        case Shared.AppDetailTbCell.screenshot:
            return 348
            
        case Shared.AppDetailTbCell.desc:
            return UITableView.automaticDimension
            
        case Shared.AppDetailTbCell.update:
            return UITableView.automaticDimension
            
        default:
            return 0
        }
    }
    

}
