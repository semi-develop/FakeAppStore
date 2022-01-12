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
    
    let screenshotZoom = 1/1.5
    
    let developBtnSize = 50.0
    
    
    var appInfo:AppInfo! //값을 넘겨받지 않으면 애초에 안넘어옴
    
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
            cell.appImg.imgFromUrl(stringUrl: appInfo.artworkUrl512)
            cell.appImg.layer.cornerRadius = Radius.appIcon
            cell.appNameLb.text = appInfo.trackName
            cell.appDeveloperLb.text = appInfo.artistName
            return cell
            
        case screenshotCellIdx:
            let cell = tableView.dequeueReusableCell(withIdentifier: screenshotCellId) as! AppDetailSceenshotTableViewCell
            
            //스샷 구하기
            guard appInfo.screenshotUrls.count > 0 else{return cell}
            
            cell.screenshotsVw.removeAllSubviews() //뒤에 자꾸 잔여 뷰가 남는다. 지우자.
            
            let imgSize = imgSizeArrayFromUrl(url: appInfo.screenshotUrls[0])
            
            let width = imgSize.width > imgSize.height ? CGFloat(Size.screenSizeW - Size.vertivalMargin*2) : CGFloat(Size.screenSizeW - Size.vertivalMargin*2)*screenshotZoom
            
            let height =  width * CGFloat(imgSize.height) / CGFloat(imgSize.width)

            
            for (idx,imgUrl) in appInfo.screenshotUrls.enumerated(){
                
                let screenshot:UIImageView = {
                    
                    let view = UIImageView(frame: CGRect(x: CGFloat(idx)*(width+5) + Size.horizonMargin, y: 0, width: width, height: height))
                    view.imgFromUrl(stringUrl: imgUrl)
                    view.layer.cornerRadius = Radius.screenshot
                    view.clipsToBounds = true
                    
                    return view
                }()
                
                cell.screenshotsVw.addSubview(screenshot)
                
                
                cell.screenshotsSc.contentSize = CGSize(width: CGFloat(idx+1)*(width+5) + Size.horizonMargin*2, height: height)
                
                //자동으로 늘어나야하는게 맞는데 왜 안늘어나지
                cell.screenshotsSc.frame = CGRect(x: 0, y: 0, width: Size.screenSizeW, height: height)
                cell.screenshotsVw.frame = CGRect(x: 0, y: 0, width: CGFloat(idx)*(width+5), height: height)
            }
                
            
            return cell
//
        case detailCellIdx:
            let cell = tableView.dequeueReusableCell(withIdentifier: detailCellId) as! AppDetailDescTableViewCell
            
            if readMore{
                cell.readMoreVw.isHidden = true
            }else{
                cell.readMoreVw.isHidden = false
            }
            
            cell.descLb.text = appInfo.description
            cell.readMoreDelegate = self
            cell.developerBtn.setTitle(appInfo.artistName, for: .normal)
            
            return cell
            
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
            
            guard appInfo.screenshotUrls.count > 0 else{return 0}
            
            let imgSize = imgSizeArrayFromUrl(url: appInfo.screenshotUrls[0])
            
            var cHeight = 0.0 //이거 나중에 추가 할 거 있으니까 미리 설정해놓는거 위에 요약 올려놔야함.
            
            if imgSize.width >= imgSize.height{ //한장만 들어감.
                let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2)
                let height = width * CGFloat(imgSize.height) / CGFloat(imgSize.width)
                
                cHeight += height
            }else{
                let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2)*screenshotZoom
                let height =  width * CGFloat(imgSize.height) / CGFloat(imgSize.width)
                
                cHeight += height
            }
            
            return cHeight
           
        case detailCellIdx:
            var height = Size.vertivalMargin*2 + developBtnSize + Size.viewMargin
            
            if readMore{
                height = height + readMoreSize
            }else{
                height = height + 61.0 //61 == 3줄짜리 높이. 3줄 이하일때는 여백임.
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
