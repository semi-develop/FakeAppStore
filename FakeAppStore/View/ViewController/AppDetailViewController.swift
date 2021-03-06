//
//  SeachDetailViewController.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/11/28.
//

import UIKit

class AppDetailViewController: BaseViewController {
    @IBOutlet weak var appInfoTb: UITableView!
    
    
    let totalCell = 3
    
    let basicCellId = "basic"
    let screenshotCellId = "screenshot"
    let detailCellId = "desc"
    
    let basicCellIdx = 0
    let screenshotCellIdx = 1
    let detailCellIdx = 2
    
    let screenshotMax = 3
    
    
    let developBtnSize = 50.0
    
    var appInfoVM:AppInfoVM!
    
    var readMore:Bool = false
    var readMoreSize:CGFloat = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController!.navigationBar.sizeToFit()
    }


}

extension AppDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return totalCell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case basicCellIdx:
            let cell = tableView.dequeueReusableCell(withIdentifier: basicCellId) as! AppDetailBasicTableViewCell
            return appInfoVM.setBasicCell(cell: cell)
            
        case screenshotCellIdx:
            let cell = tableView.dequeueReusableCell(withIdentifier: screenshotCellId) as! AppDetailSceenshotTableViewCell
            return appInfoVM.setScreenshotCell(cell: cell)
            
        case detailCellIdx:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailCellId) as! AppDetailDescTableViewCell
            
            if readMore{
                cell.readMoreVw.isHidden = true
            }else{
                cell.readMoreVw.isHidden = false
            }
            
            cell.readMoreDelegate = self
            
            return appInfoVM.setDetailCell(cell: cell)
            
        default:
            let cell = UITableViewCell()
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch indexPath.row{
        case basicCellIdx:
            return 100.0
            
        case screenshotCellIdx:
            var cHeight = 0.0 //?????? ????????? ?????? ??? ??? ???????????? ?????? ?????????????????? ?????? ?????? ???????????????.
            
            return cHeight + appInfoVM.setScreenshotCellHeight()
           
        case detailCellIdx:
            var height = Size.vertivalMargin*2 + developBtnSize + Size.viewMargin
            
            if readMore{
                height = height + readMoreSize
            }else{
                height = height + 61.0 //61 == 3????????? ??????. 3??? ??????????????? ?????????.
            }
            return height
        
        default:
            return 0
        }
    }
    

}

extension AppDetailViewController: ReadMoreDelegate{
    func readMoreIn(cell: AppDetailDescTableViewCell) {
        
        if !readMore{
            readMore = true
            cell.descLb.numberOfLines = 0
            cell.descLb.sizeToFit()
            
            readMoreSize = cell.descLb.bounds.height
            
            appInfoTb.reloadData()
        }
    }
}
