//
//  Diary.swift
//  Rin Go
//
//  Created by 会津慎弥 on 2016/07/24.
//  Copyright © 2016年 会津慎弥. All rights reserved.
//

import RealmSwift

class Diary: Object {
    static let realm = try! Realm()
    
    dynamic private var id = 0
    dynamic var date = ""
    dynamic var action_id = 0
    dynamic var action_memo = ""
    dynamic var status_id = 0
    dynamic var other = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    static func create() -> Diary {
        let diary = Diary()
        diary.id = lastId()
        return diary
    }
    
    static func loadAll() -> [Diary] {
        let diarys = realm.objects(Diary).sorted("id", ascending: false)
        var ret: [Diary] = []
        for diary in diarys {
            ret.append(diary)
        }
        return ret
    }
    
    static func lastId() -> Int {
        if let diary = realm.objects(Diary).last {
            return diary.id + 1
        } else {
            return 1
        }
    }
    
    // addのみ
    func save() {
        try! Diary.realm.write {
            Diary.realm.add(self)
        }
    }
    
    func update(method: (() -> Void)) {
        try! Diary.realm.write {
            method()
        }
    }
}
