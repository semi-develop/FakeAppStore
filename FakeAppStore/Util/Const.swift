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
