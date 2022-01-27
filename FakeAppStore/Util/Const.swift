//
//  Shared.swift
//  FakeAppStore
//
//  Created by user on 2021/12/14.
//

import Foundation
import UIKit




struct SegueName{
    static let `segueListToDetail` = "goDetail"
}


struct Url{
    static let systemSettingUrl = "App-prefs:root=General&path=USAGE/CELLULAR_USAGE"
    static let basicUrl = "https://itunes.apple.com/"
    static let searchStore = "search?"
    
    static let searchStoreBaseParams:[String:Any] = ["country":"KR",
                                                   "lang":"ko_kr",
                                                   "media":"software",
                                                   "limit":"10"]
    
}

enum RequestState{
    case success
    case fail
    case networkError
}

struct Size{
    static let screenSizeW = UIScreen.main.bounds.width
    static let screenSizeH = UIScreen.main.bounds.height
    static let screenPointX = UIScreen.main.bounds.origin.x
    static let screenPointY = UIScreen.main.bounds.origin.y
    static let vertivalMargin = 15.0
    static let horizonMargin = 15.0
    static let viewMargin = 5.0
}

struct Radius{
    static let appIcon = 10.0
    static let screenshot = 10.0
}

struct Noti{
    static let networNotiInfoKey = "isConnected"
}

func imgSizeArrayFromUrl(url:String) -> (width:Int, height:Int){ //하드 코딩해야하는 부분임.. 크기에 대해 값이 내려오진않는다.

    var imgNm = url.components(separatedBy: "/").last
    imgNm = imgNm?.components(separatedBy: ".").first?.replace(target: "bb", to: "")
    let imgSize = imgNm?.components(separatedBy: "x")

    return (width: Int(imgSize![0])!, height: Int(imgSize![1])!)
}
