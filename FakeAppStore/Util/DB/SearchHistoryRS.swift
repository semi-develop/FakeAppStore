//
//  RealmHelper.swift
//  KakaoBank
//
//  Created by Semi's MiniMac on 2021/11/27.
//

import Foundation
import RealmSwift

class SearchHistory: Object {
    @objc dynamic var id = 0
    @objc dynamic var text = ""
    @objc dynamic var date:Date = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }

}

class SearchHistoryRS{
    static let db:SearchHistoryRS = SearchHistoryRS()
    private let realm:Realm
    
    init(){
        realm = try! Realm()
        //print(Realm.Configuration.defaultConfiguration.fileURL!) //파일위치 체크
    }
    
    private func newID() -> Int {
        return realm.objects(SearchHistory.self).count+1
        
    }

    func insert(search text:String){
        let history = SearchHistory()
        
        history.id = newID()
        history.text = text
        try! realm.write {
            realm.add(history)
        }
    }
    
    func delete(){
        
    }
    
    func selectAll() -> [String]{
        let results = realm.objects(SearchHistory.self).sorted(byKeyPath: "date", ascending: false).distinct(by: ["text"])
        
        var returnArr:[String] = []
        for sh in results{
            returnArr.append(sh.text)
        }
        
        return returnArr
    }
    

    
    
}
