//
//  SeachDetailViewController.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/11/28.
//

import UIKit

class AppDetailViewController: BaseViewController {
    @IBOutlet weak var appInfoTb: UITableView!
    
    var appInfo:AppInfo! //값을 넘겨받지 않으면 애초에 안넘어옴
    
    var readMore:Bool = false
    var readMoreSize:CGFloat = 0
    
    let screenshotMax = 3
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = nil
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController!.navigationBar.sizeToFit()
    }


}

extension AppDetailViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return Shared.AppDetailTbCell.count
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case Shared.AppDetailTbCell.basic:
            let cell = tableView.dequeueReusableCell(withIdentifier: "basic") as! AppDetailBasicTableViewCell
            cell.appImg.imgFromUrl(stringUrl: appInfo.artworkUrl512)
            cell.appImg.layer.cornerRadius = Shared.cornerRadius
            cell.appNameLb.text = appInfo.trackName
            cell.appDeveloperLb.text = appInfo.artistName
            return cell
            
        case Shared.AppDetailTbCell.screenshot:
            let cell = tableView.dequeueReusableCell(withIdentifier: "screenshot") as! AppDetailSceenshotTableViewCell
            
            //스샷 구하기
            if appInfo.screenshotUrls.count > 0{
                //url에서 이름 따와야함. 규칙성을 모르니, 일단 이렇게 하드코딩해서 써야함.
                var imgNm = appInfo.screenshotUrls[0].components(separatedBy: "/").last
                imgNm = imgNm?.components(separatedBy: ".").first?.replace(target: "bb", to: "")
                let imgSize = imgNm?.components(separatedBy: "x")
                
                //확정이에여?ㅋㅋㅋ
                let imgW = Int(imgSize![0])!
                let imgH = Int(imgSize![1])!
                
                let width = imgW > imgH ? CGFloat(Size.screenSizeW - Size.vertivalMargin*2) : CGFloat(Size.screenSizeW - Size.vertivalMargin*2)/1.5 //1.5배 줄이자 너무 커.. 
                
                let height =  width * CGFloat(imgH) / CGFloat(imgW)
                
                
                for (idx,imgUrl) in appInfo.screenshotUrls.enumerated(){
                    
                    let screenshot:UIImageView = {
                        
                        let view = UIImageView(frame: CGRect(x: CGFloat(idx)*(width+5), y: 0, width: width, height: height))
                        view.imgFromUrl(stringUrl: imgUrl)
                        
                        return view
                    }()
                    
                    cell.screenshotsVw.addSubview(screenshot)
                    
                    
                    cell.screenshotsSc.contentSize = CGSize(width: CGFloat(idx+1)*(width+5), height: height)
                    
                    //자동으로 늘어나야하는게 맞는데 왜 안늘어나지
                    cell.screenshotsSc.frame = CGRect(x: 0, y: 0, width: Size.screenSizeW, height: height)
                    cell.screenshotsVw.frame = CGRect(x: 0, y: 0, width: CGFloat(idx)*(width+5), height: height)
                }
                
            }
            return cell
//
        case Shared.AppDetailTbCell.desc:
            let cell = tableView.dequeueReusableCell(withIdentifier: "desc") as! AppDetailDescTableViewCell
            
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
        case Shared.AppDetailTbCell.basic:
            return 100.0
            
        case Shared.AppDetailTbCell.screenshot:
            //url에서 이름 따와야함. 규칙성을 모르니, 일단 이렇게 하드코딩해서 써야함.
            var imgNm = appInfo.screenshotUrls[0].components(separatedBy: "/").last
            imgNm = imgNm?.components(separatedBy: ".").first?.replace(target: "bb", to: "")
            let imgSize = imgNm?.components(separatedBy: "x")
            
            //확정이에여?ㅋㅋㅋ
            let imgW = Int(imgSize![0])!
            let imgH = Int(imgSize![1])!
            
            var cHeight = 0.0 //이거 나중에 추가 할 거 있으니까 미리 설정해놓는거 위에 요약 올려놔야함.
            
            if imgW >= imgH{ //한장만 들어감.
                let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2)
                let height = width * CGFloat(imgH) / CGFloat(imgW)
                
                cHeight += height
            }else{
                let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2 - Size.viewMargin*CGFloat(screenshotMax)) / CGFloat(screenshotMax)
                let height =  width * CGFloat(imgH) / CGFloat(imgW)
                
                cHeight += height
            }
            
            return cHeight
        case Shared.AppDetailTbCell.desc:
            let developBtnSize = 50.0
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
