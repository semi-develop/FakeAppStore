//
//  Dictionary+Extension.swift
//  ssp
//
//  Created by Seong-ju Lee on 2020/07/06.
//  Copyright © 2020 Seong-ju Lee. All rights reserved.
//
import Foundation

extension Dictionary {
    
    /// Dictionary 객체를 JSON 문자열로 변환
    /// - Returns: 변환된 JSON 문자열
    func toString(_ options: JSONSerialization.WritingOptions = []) -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: options) else {
            return ""
        }
        return String(data: data, encoding: String.Encoding.utf8)!
    }
    
    /// Dictionary 객체를 URI Query 형태의 문자열로 변환
    /// - Parameter isEncode: value의 uri 인코딩 여부
    func toQuery(encode isEncode: Bool = true) -> String {
        var strQuery = ""
        for key in self.keys {
            if let value = self[key] as? String {
                if isEncode {
                    // URI Encoding
                    strQuery.append("\(key)=\(value.encodeUri())"+"&")
                } else {
                    strQuery.append("\(key)=\(value)"+"&")
                }
            } else if let value = self[key] as? Dictionary<String, Any> {
                if isEncode {
                    // URI Encoding
                    strQuery.append("\(key)=\(value.toString().encodeUri())"+"&")
                } else {
                    strQuery.append("\(key)=\(value)"+"&")
                }
            } else if let value = self[key] as? Array<Any> {
                if isEncode {
                    // URI Encoding
                    strQuery.append("\(key)=\(value.toString().encodeUri())"+"&")
                } else {
                    strQuery.append("\(key)=\(value)"+"&")
                }
            }
        }
        
        if strQuery.hasSuffix("&") {
            // 마지막 "&" 문자 제거
            strQuery = strQuery.substring(to: strQuery.count - 2)
        }
        
//        print(strQuery)
        return strQuery
    }
}

extension Dictionary where Key == String {
    /// Dictionary 객체에서 해당 키에 해당하는 문자열을 반환
    /// - Parameter strKey: 값을 가져오려는 key
    /// - Returns: 해당 key에 해당하는 값. 값이 없는 경우 빈 문자열 반환
    func getString(forKey strKey: String) -> String {
        let value = self[strKey] as? String ?? ""
        return value
    }

    /// Dictionary 객체에서 해당 키에 해당하는 Int 반환. 값이 문자열인 경우 Int로 변경해서 반환
    /// - Parameter strKey: 값을 가져오려는 key
    /// - Returns: 해당 key에 해당하는 값. 값이 없는 경우 0 반환
    func getInt(forKey strKey: String) -> Int {
        if let value = self[strKey] as? Int {
            return value
        }
        
        if let value = self[strKey] as? String {
            return value.toInt()
        }
        
        return 0
    }
    
    /// Dictionary에서 해당 key의 Dictionary 반환
    /// - Parameter strKey: 값을 조회할 key
    /// - Returns: 해당 key의 Dictionary (nil인 경우 빈 Dictionary 객체 반환)
    func getDictionary(forKey strKey: String) -> [String: Any] {
        let value = self[strKey] as? [String: Any] ?? [:]
        return value
    }
    
    /// Dictionary에서 해당 key의 Array 반환
    /// - Parameter strKey: 값을 조회할 key
    /// - Returns: 해당 key의 Array (nil인 경우 빈 Array 객체 반환)
    func getArray(forKey strKey: String) -> [Any] {
        let value = self[strKey] as? [Any] ?? []
        return value
    }
    
    func getDictionaryArray(forKey strKey: String) -> [[String: Any]] {
        let value = self[strKey] as? [[String: Any]] ?? []
        return value
    }
    
    /// Dictionary에서 해당 key의 Bool 값 반환
    /// - Parameter strKey: 값을 조회할 key
    /// - Returns: 해당 key의 Bool 값 (nil인 경우 빈 false 반환)
    func getBool(forKey strKey: String) -> Bool {
        let value = self[strKey] as? Bool ?? false
        return value
    }
}
