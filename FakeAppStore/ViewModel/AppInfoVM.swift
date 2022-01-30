//
//  AppInfoModel.swift
//  FakeAppStore
//
//  Created by user on 2022/01/24.
//

import Foundation
import SwiftUI

protocol AppInfoVMProtocol {
    var appInfos: [AppInfo]? { get set }
    var selAppInfoVM: AppInfoTestVM!{ get set } //없을수가 없음
    var errorMessage: Observable<String?> { get set }
    var error: Observable<Bool> { get set }
    func update(keyword: String)
    func setError(_ message: String)

}

class AppInfoVM: AppInfoVMProtocol{
    
    let screenshotMax = 3
    
    let requestState:Observable<RequestState> = Observable(RequestState.none)
    
    var appInfos: [AppInfo]?
    var selAppInfoVM: AppInfoTestVM!
    
    var errorMessage: Observable<String?> = Observable(nil)
    var error: Observable<Bool> = Observable(false)

    
    func update(keyword: String) {
        appListRequest(term: keyword)
    }
    
    func count() -> Int{
        return appInfos?.count ?? 0
    }
    
    func setSearchCell(cell: SearchContentTableViewCell, index: Int) -> SearchContentTableViewCell{
        guard let appInfo = appInfos?[index] else {return cell}
        cell.appImg.imgFromUrl(stringUrl: appInfo.artworkUrl60)
        cell.appImg.layer.cornerRadius = Radius.appIcon
        cell.appNameLb.text = appInfo.trackName
        cell.ratingVw.rating = appInfo.averageUserRating
        cell.ratingLb.text = String(appInfo.userRatingCount)
        
        //스샷 구하기
        guard appInfo.screenshotUrls.count > 0 else{return cell}

        cell.screenshotsVw.removeAllSubviews() //뒤에 자꾸 잔여 뷰가 남는다. 지우자.

        let imgSize = imgSizeArrayFromUrl(url: appInfo.screenshotUrls[0])

        if imgSize.width >= imgSize.height{ //한장만 들어감.
            let screenshot:UIImageView = {
                let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2)
                let height = width * CGFloat(imgSize.height) / CGFloat(imgSize.width)

                let view = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
                view.imgFromUrl(stringUrl: appInfo.screenshotUrls[0])
                view.layer.cornerRadius = Radius.screenshot
                view.clipsToBounds = true

                return view
            }()

            cell.screenshotsVw.addSubview(screenshot)

        }else{
            let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2 - Size.viewMargin*CGFloat(screenshotMax)) / CGFloat(screenshotMax)
            let height =  width * CGFloat(imgSize.height) / CGFloat(imgSize.width)

            let screenshotCnt = appInfo.screenshotUrls.count > screenshotMax ? screenshotMax : appInfo.screenshotUrls.count

            for idx in 0...screenshotCnt-1{

                let screenshot:UIImageView = {

                    let view = UIImageView(frame: CGRect(x: CGFloat(idx)*(width + Size.viewMargin), y: 0, width: width, height: height))
                    view.imgFromUrl(stringUrl: appInfo.screenshotUrls[idx])
                    view.layer.cornerRadius = Radius.screenshot
                    view.clipsToBounds = true

                    return view
                }()

                cell.screenshotsVw.addSubview(screenshot)
            }
        }

        return cell
    }
    
    func setSelAppInfo(index:Int){
        selAppInfoVM = AppInfoTestVM(appInfo: appInfos![index])
    }
    
    func clearData(){
        self.appInfos = nil
    }
    
    
    
    func imgHeight(index: Int) -> CGFloat{
        guard let appInfo = appInfos?[index] else {return 0.0}
        guard appInfo.screenshotUrls.count > 0 else{return 0.0}
        let imgSize = imgSizeArrayFromUrl(url: appInfo.screenshotUrls[0])

        if imgSize.width >= imgSize.height{ //한장만 들어감.
            let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2)
            let height = width * CGFloat(imgSize.height) / CGFloat(imgSize.width)

            return height
        }else{
            let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2 - Size.viewMargin*CGFloat(screenshotMax)) / CGFloat(screenshotMax)
            let height =  width * CGFloat(imgSize.height) / CGFloat(imgSize.width)

            return height
        }
    }
        

    func setError(_ message: String) {
            self.errorMessage = Observable(message)
            self.error = Observable(true)
        }

}


extension AppInfoVM{
    
    var url: String {
        return Url.searchStore
    }

    func appListRequest(term: String) {

        var searchRequestParams = Url.searchStoreBaseParams
        searchRequestParams["term"] = term

        let request = Request(stringUrl: url,params: searchRequestParams)
        request.sendRequest{
            networkState in
            DispatchQueue.main.async {
                switch networkState{
                case .success:
                    guard let searchContents = try? JSONDecoder().decode(SearchContents.self, from: request.data!) else{
                        //fail
                        self.requestState.value = .fail
                        print("에러!")
                        return
                    }

                    print("성공!")
                    guard let infos = searchContents.results else{return}
                    self.appInfos = infos
                    self.requestState.value = .success
                    break

                case .fail:
                    //fail
                    self.requestState.value = .fail
                    print("에러!")
                    break

                case .networkError:
                    //network error
                    self.requestState.value = .networkError
                    break
                case .none:
                    break
                }
            }
        }
    }
    
}

 
class AppInfoTestVM{
    let screenshotZoom = 1/1.5
    
    var appInfo:AppInfo
    
    init(appInfo:AppInfo){
        self.appInfo = appInfo
    }
    
    func setBasicCell(cell: AppDetailBasicTableViewCell) -> AppDetailBasicTableViewCell{
        cell.appImg.imgFromUrl(stringUrl: appInfo.artworkUrl512)
        cell.appImg.layer.cornerRadius = Radius.appIcon
        cell.appNameLb.text = appInfo.trackName
        cell.appDeveloperLb.text = appInfo.artistName
        
        return cell
    }
    
    func setScreenshotCell(cell: AppDetailSceenshotTableViewCell) -> AppDetailSceenshotTableViewCell{
        
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
    }
    
    func setDetailCell(cell: AppDetailDescTableViewCell) -> AppDetailDescTableViewCell{
        cell.descLb.text = appInfo.description
        cell.developerBtn.setTitle(appInfo.artistName, for: .normal)
        
        return cell
    }
    
    func setScreenshotCellHeight() -> CGFloat{
        let imgSize = imgSizeArrayFromUrl(url: appInfo.screenshotUrls[0])
        
        if imgSize.width >= imgSize.height{ //한장만 들어감.
            let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2)
            let height = width * CGFloat(imgSize.height) / CGFloat(imgSize.width)
            
            return height
        }else{
            let width = CGFloat(Size.screenSizeW - Size.vertivalMargin*2)*screenshotZoom
            let height =  width * CGFloat(imgSize.height) / CGFloat(imgSize.width)
            
            return height
        }
        
    }
    
}
