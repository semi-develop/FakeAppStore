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
                
                    //일단 하드코딩해놨는데 나중에 바꿔라..
//                if imgW > imgH{
//                    let width = CGFloat(Size.screenSizeW - 30 - 10)
//                }else{
//                    let width = CGFloat(Size.screenSizeW - 30 - 10) / 3.0
//                }
                
                let width = imgW > imgH ? CGFloat(CGFloat(Size.screenSizeW - 30 - 10)) : CGFloat(Size.screenSizeW - 30 - 10)/1.5
                
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
                
                print("cell.screenshotsVw.frame \(cell.screenshotsVw.frame)")
                print("cell.screenshotsSc.frame \(cell.screenshotsSc.frame)")
                print("cell.screenshotsSc.contentSize \(cell.screenshotsSc.contentSize)")
            }
            return cell
//
        case Shared.AppDetailTbCell.desc:
            let cell = tableView.dequeueReusableCell(withIdentifier: "desc") as! AppDetailDescTableViewCell
            
            cell.readMoreVw.descLb.text = appInfo.description
            
            cell.developerBtn.setTitle(appInfo.artistName, for: .normal)
            
            
            return cell
//
//        case Shared.AppDetailTbCell.update:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "update") as! AppDetailDescTableViewCell
//            //cell.descLb.text = appInfo.releaseNotes
//
//            return cell
            
        default:
            let cell = UITableViewCell()
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        switch indexPath.row{
        case Shared.AppDetailTbCell.basic:
            return 100
            
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
                let height = CGFloat(Size.screenSizeW - 30) * CGFloat(imgH) / CGFloat(imgW)
                
                cHeight += height
            }else{
                //일단 하드코딩해놨는데 나중에 바꿔라..
                let width = CGFloat(Size.screenSizeW - 30 - 10) / 1.5
                let height =  width * CGFloat(imgH) / CGFloat(imgW)
                
                cHeight += height
            }
            
            return cHeight
        case Shared.AppDetailTbCell.desc:
            return 150;
        
        default:
            return 0
        }
    }
    

}
