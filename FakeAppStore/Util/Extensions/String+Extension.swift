//
//  String+Extension.swift
//  ssp
//
//  Created by Seong-ju Lee on 2020/07/06.
//  Copyright © 2020 Seong-ju Lee. All rights reserved.
//
import Foundation
import CommonCrypto
import UIKit


extension String {
    
  
    
    /// 문자열 마지막 공백문자 제거 (문자열 중간 공백문자는 유지)
    /// - Returns: 마지막 공백문자가 제거된 문자열
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    
    func replace(target: String, to: String) -> String {
        return self.replacingOccurrences(of: target, with: to, options: NSString.CompareOptions.literal, range: nil)
    }
    
}


