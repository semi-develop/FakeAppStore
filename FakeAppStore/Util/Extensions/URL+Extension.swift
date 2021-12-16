//
//  URL+Extension.swift
//  ssp
//
//  Created by Seong-ju Lee on 2021/04/23.
//
import Foundation
import UIKit

extension URL {
    /// URL의 query를 Dictionary로 변환
    /// - Returns: 변환된 Dictionary
    func parseQuery() -> [String: String] {
        let strQuery = self.query ?? ""
        let dicQuery = strQuery.parseUrlQuery()
        
        return dicQuery
    }
    
    /// 사파리에서 해당 URL 로드
    func openSafari() {
        UIApplication.shared.open(self, options: [:], completionHandler: nil)
    }
}
