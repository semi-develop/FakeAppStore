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

/// 실제로 외부 앱, 사파리 브라우저를 열기 전에 해당 주소값이 유효한지 체크한 결과값
enum OpenURLResult: Int {
    /// 정상 호출
    case OPEN
    /// 유효하지않은 주소
    case INVALID_URL
    /// 주소 내용이 없음
    case EMPTY_URL
    /// 앱이 설치되지 않음
    case APP_NOT_INSTALLED
}

private let characterEntities : [ Substring : Character ] = [
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">"
]

extension String {
    
    /// 연월일시분초 형태의 문자열을 Date객체로 변환
    /// - Returns: 변환된 Date 객체
    func toDateYMDHMS()-> Date? {
        var date:Date?
        var str = self
        str = str.replace(target: " ", to: "")
        str = str.replace(target: "-", to: "")
        str = str.replace(target: ":", to: "")
        str = str.replace(target: ".", to: "")
        
        if str.count >= 14 {
            let index1 = str.index(str.startIndex, offsetBy: 4)
            let index2 = str.index(index1, offsetBy: 2)
            let index3 = str.index(index2, offsetBy: 2)
            let index4 = str.index(index3, offsetBy: 2)
            let index5 = str.index(index4, offsetBy: 2)
            let index6 = str.index(index5, offsetBy: 2)
            
            let year = str[str.startIndex..<index1]
            let month = str[index1..<index2]
            let day = str[index2..<index3]
            let hour = str[index3..<index4]
            let min = str[index4..<index5]
            let sec = str[index5..<index6]
            
            let components = NSDateComponents()
            components.year = Int(year)!
            components.month = Int(month)!
            components.day = Int(day)!
            components.hour = Int(hour)!
            components.minute = Int(min)!
            components.second = Int(sec)!
            components.timeZone = TimeZone(abbreviation: "GMT+0:00")
            
            if let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) {
                date = calendar.date(from: components as DateComponents)
            }
        }

        return date
    }
    
    /// 연월일 형태의 문자열을 Date객체로 변환
    /// - Returns: 변환된 Date 객체
    func toDateYMD()-> Date? {
        var date:Date?
        var str = self
        str = str.replace(target: " ", to: "")
        str = str.replace(target: "-", to: "")
        str = str.replace(target: ":", to: "")
        str = str.replace(target: ".", to: "")
        
        if str.count >= 8 {
            let index1 = str.index(str.startIndex, offsetBy: 4)
            let index2 = str.index(index1, offsetBy: 2)
            let index3 = str.index(index2, offsetBy: 2)
            
            let year = str[str.startIndex..<index1]
            let month = str[index1..<index2]
            let day = str[index2..<index3]
            
            let components = NSDateComponents()
            components.year = Int(year)!
            components.month = Int(month)!
            components.day = Int(day)!
            components.timeZone = TimeZone(abbreviation: "GMT+0:00")
            
            if let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) {
                date = calendar.date(from: components as DateComponents)
            }
        }
        
        return date
    }
    
    /// 연월 형태의 문자열을 Date객체로 변환
    /// - Returns: 변환된 Date 객체
    func toDateYM()-> Date? {
        var date:Date?
        var str = self
        str = str.replace(target: " ", to: "")
        str = str.replace(target: "-", to: "")
        str = str.replace(target: ":", to: "")
        str = str.replace(target: ".", to: "")
        
        if str.count >= 6 {
            let index1 = str.index(str.startIndex, offsetBy: 4)
            let index2 = str.index(index1, offsetBy: 2)
            
            let year = str[str.startIndex..<index1]
            let month = str[index1..<index2]
            
            let components = NSDateComponents()
            components.year = Int(year)!
            components.month = Int(month)!
            components.timeZone = TimeZone(abbreviation: "GMT+0:00")
            
            if let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) {
                date = calendar.date(from: components as DateComponents)
            }
        }
        
        return date
    }
    
    /// 연 형태의 문자열을 Date객체로 변환
    /// - Returns: 변환된 Date 객체
    func toDateY()-> Date? {
        var date:Date?
        var str = self
        str = str.replace(target: " ", to: "")
        str = str.replace(target: "-", to: "")
        str = str.replace(target: ":", to: "")
        str = str.replace(target: ".", to: "")
        
        if str.count >= 4 {
            
            let index1 = str.index(str.startIndex, offsetBy: 4)

            let year = str[str.startIndex..<index1]
            
            let components = NSDateComponents()
            components.year = Int(year)!
            components.timeZone = TimeZone(abbreviation: "GMT+0:00")
            
            if let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian) {
                date = calendar.date(from: components as DateComponents)
            }
        }
        
        return date
    }
    
    /// 문자열을 Date 객체로 변환
    /// - Parameter strFormat: 문자열의 Date Format
    /// - Returns: 변경된 Date 객체
    func toDate(format strFormat: String) -> Date? {
        var date: Date?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        
        let locale: Locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = locale
        
        date = dateFormatter.date(from: self)
        return date
    }
        
    /// JSON 문자열을 객체(Dictionary, Array)로 변환
    /// - Parameter json: JSON 문자열
    /// - Returns: 변환된 Dictionary 또는 Array
    func toObject() -> Any? {
        let data = self.data(using: String.Encoding.utf8)
        do {
            let obj = try JSONSerialization.jsonObject(with: data!, options:[])
            return obj
        } catch  {
            return nil
        }
    }
    
    /// JSON 문자열을 Dictionary로 변환
    /// - Parameter json: JSON 문자열
    /// - Returns: 변환된 Dictionary
    func toDictionary() -> [String: Any]? {
        let data = self.data(using: String.Encoding.utf8)
        do {
            let obj = try JSONSerialization.jsonObject(with: data!, options:[]) as? [String: AnyObject]
            return obj
        } catch  {
            return nil
        }
    }
    
    /// JSON 문자열을 Array로 변환
    /// - Parameter json: JSON 문자열
    /// - Returns: 변환된 Array
    func toArray() -> [Any]? {
        let data = self.data(using: String.Encoding.utf8)
        
        do {
            let obj = try JSONSerialization.jsonObject(with: data!, options:[]) as? [Any]
            return obj
        } catch  {
            return nil
        }
    }
    
    /// 문자열을 Data 객체로 변환
    /// - Returns: 변환된 Data 객체
    func toData() -> Data? {
        return self.data(using: .utf8)
    }
    
    /// 날짜형식 문자열의 Date Format 변경
    /// - Parameters:
    ///   - strFrom: 현재 적용된 Date Format
    ///   - strTo: 변경할 Date Format
    /// - Returns: 변경된 Date Format의 문자열
    func changeDateFormat(from strFrom: String, to strTo: String) -> String {
        if let date = self.toDate(format: strFrom)?.toKST() {
            let strChangedFormat = date.toString(strTo)
            
            return strChangedFormat
        } else {
            return ""
        }
    }
    
    /// 세 자리마다 콤마 추가 (예: 2019 -> 2,019)
    /// - Returns: 콤마가 추가된 문자열
    func addComma()-> String {
        if self == "" {
            return ""
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        
        if let num = Float.init(self) {
            if let result = numberFormatter.string(from: NSNumber(value:num)) {
                return result
            }
        }
        return ""
    }
    
    /// 문자열에서 콤마 제거 (예: 2,019 -> 2019)
    /// - Returns: 콤마가 제거된 문자열
    func removeComma()-> String {
        let str = self.replacingOccurrences(of: ",", with: "")
        return str
    }
    
    /// URL을 통한 사파리 실행 또는 App Scheme을 통한 외부 앱 실행 여부 체크
    /// - Returns: OpenURLResult 형태의 결과 값
    func canOpenURL() -> OpenURLResult {
        if self.isEmpty {
            return .EMPTY_URL
        }
        
        if let url = URL(string: self) {
            if UIApplication.shared.canOpenURL(url) {
                // URL 객체 생성이 가능하고 이동할 수 있음
                return .OPEN
            } else {
                // URL 객체 생성은 가능하나 이동할 수 없음
                return .APP_NOT_INSTALLED
            }
        } else {
            // URL 객체 생성 불가(문자열이 URL형식이 아님)
            return .INVALID_URL
        }
    }
    
    /// 외부 앱 실행 또는 사파리 브라우저로 이동
    /// - Parameters:
    ///   - toSafari: 사파리 실행 여부. true는 사파리, false는 외부앱
    ///   - completion: OpenURLResult 형태의 결과 값 처리 콜백
    func openURL(toSafari: Bool = false, completion:((OpenURLResult) -> Void)?) {
        var str = self
        if toSafari {
            if !self.hasPrefix("http") && !self.hasPrefix("tel") {
                str = "http://\(str)"
            }
        }
        
        let openURLResult: OpenURLResult = self.canOpenURL()
        if openURLResult == .OPEN {
            let url = URL(string: str)!     // canOpenURL()에서 값이 확인되었으므로 force unwrap해도 안전함
            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:]) { (success) in
                    completion?(openURLResult)
                }
            }
        } else {
            completion?(openURLResult)
        }
    }
    
    /// 문자열 내 특정 문자열을 변경
    /// - Parameters:
    ///   - target: 변경해야 할 문자열
    ///   - to: 변경하고 싶은 문자열
    /// - Returns: 변경된 문자열
    func replace(target: String, to: String) -> String {
        return self.replacingOccurrences(of: target, with: to, options: NSString.CompareOptions.literal, range: nil)
    }
    
    /// UTF-8 형식으로 인코딩된 문자열을 decode
    /// - Returns: decode된 문자열
    func getUTF8DecodedString()-> String {
        let data = self.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII) {
            return message
        }
        return ""
    }
    
    /// 문자열을 UTF-8 형식으로 encode
    /// - Returns: encode된 문자열
    func getUTF8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8)
        return text ?? ""
    }
    
    /// 문자열 URIDecode 처리
    /// - Returns: URIDecode된 문자열
    func decodeUri() -> String {
        return self.removingPercentEncoding ?? ""
    }
    
    /// 문자열 URIEncode 처리
    /// - Returns: URIEncode된 문자열
    func encodeUri() -> String {
        // Remove preexisting encoding
        var percentEncoding = CharacterSet.alphanumerics    // 영문자 제외 인코딩
        percentEncoding.insert(charactersIn: "-_.!")   // 비예약 문자 제외

        let strEncoded = self.addingPercentEncoding(withAllowedCharacters: percentEncoding) ?? ""
        return strEncoded
    }
    
    /// 한글 또는 특문 포함된 url 인코딩
    /// - Returns: 인코딩된 문자열
    func makeURLString() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
        
    /// URL Query 형식의 String을 Dictionary로 Parsing
    /// - Returns: parsing된 Dictionary 객체
    func parseUrlQuery() -> [String: String] {
        if self.isEmpty {
            return [:]
        }
        
        var dicQuery: [String: String] = [:]
        for pair in self.components(separatedBy: "&") {
            if pair.components(separatedBy: "=").count == 2 { // key/value 쌍이 맞으면
                let key = pair.components(separatedBy: "=")[0]
                let value = pair.components(separatedBy:"=")[1].replacingOccurrences(of: "+", with: " ").removingPercentEncoding ?? ""
                dicQuery[key] = value
            }
        }
        return dicQuery
    }
    
    /// 쿠키 파싱
    /// - Returns: 파싱된 Dictionary
    func parseCookie() -> [String: Any] {
        var dicCookie = [String: Any]()
        
        if self.isEmpty {
            return dicCookie
        }
        
        let strCookies = self.replace(target: " ", to: "")
        for pair in strCookies.components(separatedBy: ";") {
            let key = pair.components(separatedBy: "=")[0]
            let value = pair.components(separatedBy: "=")[1]
            dicCookie[key] = value
        }
        
        return dicCookie
    }
    
    /// 문자열을 Int로 변경
    /// - Returns: 변경된 Int값 (변경 실패 시 0)
    func toInt() -> Int {
        let strNumber = self.removeComma()
        return Int(strNumber) ?? 0
    }
    
    /// 문자열을 Float으로 변경
    /// - Returns: 변경된 Float값 (변경 실패 시 0.0)
    func toFloat() -> Float {
        let strNumber = self.removeComma()
        return Float(strNumber) ?? 0.0
    }
    
    /// 문자열을 Bool로 변경
    /// - Returns: 변경된 Bool값 (변경 실패 시 false)
    func toBool() -> Bool {
        if self.lowercased() == "true" {
            return true
        }
        
        return false
    }
    
    /// 파일명에서 확장자 제거
    /// - Returns: 확장자가 제거된 파일명 문자열
    func removeFileExtension() -> String {
        let strFileName = self as NSString
        return strFileName.deletingPathExtension
    }
    
    /// 문자열에서 원하는 인덱스만큼 substiring
    /// - Parameters:
    ///   - iFrom: 시작 인덱스
    ///   - iTo: 마지막 인덱스
    /// - Returns: substring된 문자열
    func substring(from iFrom: Int = 0, to iTo: Int) -> String {
        if iFrom > self.count - 1 {
            return ""
        }
        
        var iTargetTo = iTo
        if iTo > self.count - 1 {
            iTargetTo = self.count - 1
        }
        
        let fromIndex = self.index(startIndex, offsetBy: iFrom)
        let toIndex = self.index(startIndex, offsetBy: (iTargetTo+1))  // 인덱스 생성 시 마지막 인덱스도 포함되도록 +1 시켜줌
        return String(self[fromIndex..<toIndex])
    }
    
    /// 문자열 마지막 공백문자 제거 (문자열 중간 공백문자는 유지)
    /// - Returns: 마지막 공백문자가 제거된 문자열
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    /// HTML 문자열 decode
    /// - Returns: decode된 문자열
    var htmlDecode : String {
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        func decode(_ entity : Substring) -> Character? {
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        var result = ""
        var position = startIndex
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            guard let semiRange = self[position...].range(of: ";") else {
                break
            }
            
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound
            
            if let decoded = decode(entity) {
                result.append(decoded)
            } else {
                result.append(contentsOf: entity)
            }
        }
        result.append(contentsOf: self[position...])
        return result
    }
    
    /// 정규식에 맞는 문자들만 추출
    /// - Parameters:
    ///   - regex: 추출 할 정규식
    /// - Returns: 추출된 문자 배열
    func extract(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    /// 문자열이 Number 형태인지 확인
    /// - Returns: Number 형태의 문자열 여부
    func isNumber() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9]+$", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                // 번호만 포함됨
                return true
            }
        } catch {
            // 에러 발생 > 프로세스 진행 실패
            return false
        }
        
        return false
    }
    
    /// count개의 연속된 숫자 또는 count개의 연속으로 동일 숫자가있는지 확인
    /// - Parameter count: 체크할 숫자의 갯수
    /// - Returns: 연속되거나 연속으로 동일한 숫자 포함 여부
    func hasStackNumber(count: Int) -> Bool {
        if self.count < count { // 체크할 갯수가 문자열 길이보다 큰 경우
            return false
        }
        
        let arrStr = Array(self)
        var iDiff = INTPTR_MAX
        var iCheckedCount = 0

        for i in 0..<(arrStr.count - 1) {
            let iBase = String(arrStr[i]).toInt()
            let iNext = String(arrStr[i+1]).toInt()
            let asdf = iBase - iNext
            if asdf == 0 || asdf == 1 || asdf == -1 {
                if iDiff == asdf {
                    iCheckedCount += 1
                } else {
                    iDiff = asdf
                    iCheckedCount = 2 // 두 개의 문자 비교이므로 체크 카운트 시작은 2부터
                }
            } else {
                iDiff = INTPTR_MAX
                iCheckedCount = 0
            }
            
            if iCheckedCount == count {
                return true
            }
        }

        return false
    }

    /// 색상 HEX 값으로 UIColor 생성하여 반환
    func toUIColor(alpha: CGFloat = 1.0) -> UIColor {
        var cString: String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.black
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                       green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                       blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                       alpha: alpha)
    }
    
    /// 문자열 내에서 특정 문자의 range 검색
    /// - Parameter str: 검색 할 문자
    /// - Returns: 해당 문자의 range
    func getRange(for str: String) -> NSRange {
        let strSelf = self as NSString
        let range = strSelf.range(of: str.lowercased())

        return range
    }
    
    /// SHA256 암호화
    /// - Returns: 암호화된 문자열
    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            let input = stringData as NSData
            let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
            var hash = [UInt8](repeating: 0, count: digestLength)
            CC_SHA256(input.bytes, UInt32(input.length), &hash)
            let digest = NSData(bytes: hash, length: digestLength)

            
            var bytes = [UInt8](repeating: 0, count: digest.length)
            digest.getBytes(&bytes, length: digest.length)

            var hexString = ""
            for byte in bytes {
                hexString += String(format: "%02x", UInt8(byte))
            }

            return hexString
        }
        
        return ""
    }
}


