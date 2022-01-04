//
//  BasicViewController.swift
//  FakeAppStore
//
//  Created by user on 2021/12/23.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    
    
    func networkError() {
        print("networkError")
        //connectNetwork(is: false)
    }
    
    
    func failRequest(){
        print("failRequest")
        let alert = UIAlertController(title: "오류", message: "다시 한번 시도해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler : nil))
        present(alert, animated: false, completion: nil)
    }

}

