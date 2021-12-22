//
//  Shared.swift
//  FakeAppStore
//
//  Created by user on 2021/12/14.
//

import Foundation

struct Shared{
    struct Url{
        static let basicUrl = "https://itunes.apple.com/"
        static let searchStore = "search?"
    }
    
    static let searchApiBaseParams:[String:Any] = ["country":"KR",
                                                   "lang":"ko_kr",
                                                   "media":"software",
                                                   "limit":"10"]
    
    enum RequestState{
        case success
        case fail
        case networkError
    }
    
    static let segueListToDetail = "goDetail"
    
    static let cornerRadius = 10.0
    
    struct AppDetailTbCell{
        static let basic = 0
        static let summary = 1
        static let screenshot = 2
        static let desc = 3
        static let update = 4
        static let count = 5 //마지막
    }
    
    struct AppDetailSummaryCVCell{
        static let review = 0
        static let ageLimit = 1
        static let developer = 2
        static let lang = 3
        static let count = 4 //마지막
    }
    
    static let systemSettingUrl = "App-prefs:root=General&path=USAGE/CELLULAR_USAGE"

    static let networNotiInfoKey = "isConnected"
}
