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
    
    
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }

    func gradatient(startColor:UIColor, endColor:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0 , 1.0] //https://zeddios.tistory.com/948
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
}
