//
//  UIImageView+Extension.swift
//  FakeAppStore
//
//  Created by user on 2021/12/23.
//

import Foundation
import UIKit


extension UIImageView{
    
    
    func imgFromUrl(stringUrl: String){
        guard let url = URL(string: stringUrl) else{return}
        URLSession.shared.dataTask(with: url){
            (data, response, error) in
            guard let data2 = data else{return}
            DispatchQueue.main.async {
                self.image = UIImage(data: data2)
            }
        }.resume()
    }
}
