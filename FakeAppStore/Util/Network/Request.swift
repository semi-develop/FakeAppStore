//
//  RequestGetData.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/11/27.
//

import Foundation

protocol SendAppListRequest{
    var url:String {get}
    func appListRequest(term: String)
}

class Request{
    private let stringUrl:String
    private let params:[String:Any]?
    private var sendUrl:URL?
    var data:Data?
    
    init(stringUrl:String, params:[String:Any]){
        self.stringUrl = Url.basicUrl + stringUrl
        self.params = params
        sendUrl = URL(string: self.stringUrl)
        
        guard let url = sendUrl else{return}
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        let queryItems = params.map{ URLQueryItem(name: "\($0)", value: "\($1)") }
        urlComponents?.queryItems = queryItems
        sendUrl = urlComponents?.url
    }
    
    init(stringUrl:String){
        self.stringUrl = Url.basicUrl + stringUrl
        self.params = nil
        sendUrl = URL(string: stringUrl)
    }
    
    func sendRequest(completion: @escaping (RequestState) -> ()){
        if !NetworkCheck.networkCk.isConnect(){ //혹시 모르니 한번 더 체크
            completion(.networkError)
        }else{
            if let url = sendUrl{
                URLSession.shared.dataTask(with: url){
                    (data, response, error) in
                    if let error = error{
                        completion(.fail)
                        print(error.localizedDescription)
                    }else if let data = data {
                        self.data = data
                        completion(.success)
                    }else{
                        completion(.fail)
                        print("data is nil")
                    }
                }.resume()
            }else{
                completion(.fail)
                print("url is nil")
            }
        }
    }
    
    
}
