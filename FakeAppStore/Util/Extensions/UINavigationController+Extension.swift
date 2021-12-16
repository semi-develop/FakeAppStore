//
//  UINavigationController+Extension.swift
//  ssp
//
//  Created by Seong-ju Lee on 2020/07/06.
//  Copyright © 2020 Seong-ju Lee. All rights reserved.
//
import UIKit

extension UINavigationController {
    /// 안내 얼럿을 띄운 후 navigationController에서 ViewController를 pop한다
    /// - Parameters:
    ///   - isAnimate: 애니메이션 여부
    ///   - strAlertMessage: 얼럿 타이틀
    func pop(animate isAnimate: Bool = true, alertMessage strAlertMessage: String? = nil, completion: (() -> Void)? = nil) {
        if let strAlertMessage = strAlertMessage {
            DispatchQueue.main.async {
//                AlertVC.show(message: strAlertMessage,
//                             buttonTitles: [ALERT_BUTTON_OK]) { (index) in
//                    self.popVC(animate: isAnimate, completion: completion)
//                }
            }
        } else {
            self.popVC(animate: isAnimate, completion: completion)
        }
    }
    
    private func popVC(animate isAnimate: Bool, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popViewController(animated: isAnimate)
        CATransaction.commit()
    }
    
    func popToRoot(animate isAnimate: Bool = true, alertMessage strAlertMessage: String? = nil, completion: (() -> Void)? = nil) {
        if let strAlertMessage = strAlertMessage {
            DispatchQueue.main.async {
//                AlertVC.show(message: strAlertMessage,
//                             buttonTitles: [ALERT_BUTTON_OK]) { (index) in
//                    self.popToRootVC(animate: isAnimate, completion: completion)
//                }
            }
        } else {
            self.popToRootVC(animate: isAnimate, completion: completion)
        }
    }
    
    private func popToRootVC(animate isAnimate: Bool, completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.popToRootViewController(animated: isAnimate)
        CATransaction.commit()
    }
    
    func push(_ viewController: UIViewController, animated isAnimated: Bool = true, completion: (() -> Void)? = nil) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        self.pushViewController(viewController, animated: isAnimated)
        CATransaction.commit()
    }
}
