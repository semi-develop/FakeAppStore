//
//  UIButton+Extension.swift
//  ssp
//
//  Created by Seong-ju Lee on 2021/05/26.
//
import UIKit

extension UIButton {
    @IBInspectable var normalBackgroundColor: UIColor {
        set {
            self.setBackgroundColor(newValue, for: .normal)
        }
        get {
            return .clear
        }
    }
    
    @IBInspectable var highlightedBackgroundColor: UIColor {
        set {
            self.setBackgroundColor(newValue, for: .highlighted)
        }
        get {
            return .clear
        }
    }
    
    @IBInspectable var selectedBackgroundColor: UIColor {
        set {
            self.setBackgroundColor(newValue, for: .selected)
        }
        get {
            return .clear
        }
    }
    
    @IBInspectable var disabledBackgroundColor: UIColor {
        set {
            self.setBackgroundColor(newValue, for: .disabled)
        }
        get {
            return .clear
        }
    }
    
    
    /// State에 따라 배경색이 변경되도록 처리
    /// - Parameters:
    ///   - color: 적용할 색상
    ///   - state: state
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(backgroundImage, for: state)
    }
}
