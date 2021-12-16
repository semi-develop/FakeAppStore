//
//  Array+Extension.swift
//  ssp
//
//  Created by Seong-ju Lee on 2020/07/06.
//  Copyright © 2020 Seong-ju Lee. All rights reserved.
//
import Foundation

extension Array {
    
    /// Array 객체를 JSON 문자열로 변환
    /// - Returns: 변환된 JSON 문자열
    func toString() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8)!
    }
}
