//
//  SearchContents.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/12/02.
//

struct SearchContents:Decodable{
    var resultCount:Int
    var results:[AppInfo]?
}
