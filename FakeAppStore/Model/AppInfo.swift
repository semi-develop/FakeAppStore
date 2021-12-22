//
//  SearchContents.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/11/27.
//

struct AppInfo:Decodable{
    var screenshotUrls:[String]
    var ipadScreenshotUrls:[String]
    var appletvScreenshotUrls:[String]
    var artworkUrl60:String
    var artworkUrl512:String
    var artworkUrl100:String
    var artistViewUrl:String
    var features:[String]
    var supportedDevices:[String]
    var advisories:[String]
    var isGameCenterEnabled:Bool
    var kind:String
    var minimumOsVersion:String
    var trackCensoredName:String //app name
    var languageCodesISO2A:[String]
    var fileSizeBytes:String
    var formattedPrice:String
    var contentAdvisoryRating:String //연령제한
    var averageUserRatingForCurrentVersion:Double //없을때 값 내려오나 확인필요
    var userRatingCountForCurrentVersion:Int //없을때 값 내려오나 확인필요
    var averageUserRating:Double //없을때 값 내려오나 확인필요
    var trackViewUrl:String
    var trackContentRating:String //연령제한 contentAdvisoryRating와 차이 모르겠음
    var bundleId:String
    var trackId:Int
    var trackName:String //app name trackCensoredName와 차이 모르겠음
    var releaseDate:String
    var primaryGenreName:String
    var genreIds:[String]
    var isVppDeviceBasedLicensingEnabled:Bool
    var currentVersionReleaseDate:String
    var releaseNotes:String
    var primaryGenreId:Int
    var currency:String
    var version:String
    var wrapperType:String
    var sellerName:String
    var artistId:Int
    var artistName:String
    var genres:[String]
    var price:Float
    var description:String
    var userRatingCount:Int
}
