//
//  UIView+Extension.swift
//  Homeplus
//
//  Created by Seong-ju Lee on 2020/07/06.
//  Copyright © 2020 Seong-ju Lee. All rights reserved.
//
import UIKit
import Photos

extension UIView {

    /// UIView의 layer에 border 적용
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    /// UIView의 layer에 corner radius 적용
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    /// UIView의 layer에 border color 적용
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
    
    /// view가 포함된 UIViewController
    var parentVC: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.next
            if let vc = parentResponder as? UIViewController {
                return vc
            }
        }
        
        return nil
    }

    /// UIView의 특정 모서리에 corner radius 적용
    /// - Parameters:
    ///   - corners: corner radius를 적용 할 부분 (topLeft, topRight, bottomLeft, bottomRight, allCorners)
    ///   - radius: corner radius 수치
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    /// UIView를 캡쳐하여 사진첩에 저장 (Info.plist에 Privacy - Photo Library Additions Usage Description 추가 필요)
    func saveToPhotoAlbum() {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            DispatchQueue.main.async {
                let image = self.toImage()
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                print("이미지 저장 완료")
            }
        }  else if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization { (result) in
                self.saveToPhotoAlbum()
            }
        } else {
            print("사진첩 접근 권한 없음")
        }
    }
    
    /// UIView를 캡쳐하여 UIImage 객체로 반환
    /// - Returns: 캡쳐된 UIImage 객체
    func toImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat.default()
            let renderer = UIGraphicsImageRenderer(bounds: bounds, format: format)
            return renderer.image {
                _ in self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
    
    enum ViewSide: String {
        case Left = "Left", Right = "Right", Top = "Top", Bottom = "Bottom"
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat, padding:CGFloat?) {
        
        let border = CALayer()
        border.borderColor = color
        border.name = side.rawValue
        switch side {
        case .Left: border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .Right: border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        case .Top: border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .Bottom: border.frame = CGRect(x: padding ?? 0, y: frame.height - thickness, width: frame.width, height: thickness)
        }
        
        border.borderWidth = thickness
        
        layer.addSublayer(border)
    }
    
    func removeBorder(toSide side: ViewSide) {
        guard let sublayers = self.layer.sublayers else { return }
        var layerForRemove: CALayer?
        for layer in sublayers {
            if layer.name == side.rawValue {
                layerForRemove = layer
            }
        }
        if let layer = layerForRemove {
            layer.removeFromSuperlayer()
        }
    }
}
