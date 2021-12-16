//
//  UILabel+Extension.swift
//  ssp
//
//  Created by Seong-ju Lee on 2021/05/31.
//
import UIKit

extension UILabel {
    /// UILabel 내부 특정 문자 표시 변경
    /// - Parameters:
    ///   - arrTexts: 변경 할 문자 배열
    ///   - color: 변경 할 색상
    ///   - font: 변경 할 폰트
    func changePartTexts(_ arrTexts: [String], color: UIColor?, font: UIFont? = nil) {
        let color = color ?? self.textColor
        let font = font ?? self.font
        
        if let strText = self.text {
            let strLower: NSString = strText.lowercased() as NSString
            let attribute = NSMutableAttributedString.init(string: strText)
            for strChangeText in arrTexts {
                let range = (strLower).range(of: strChangeText.lowercased())
                attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: color!, range: range)
                attribute.addAttribute(NSAttributedString.Key.font, value: font!, range: NSMakeRange(0, strText.count))
                attribute.addAttribute(NSAttributedString.Key.font, value: font!, range: range)
            }
            self.attributedText = attribute
        }
    }


}
