//
//  DatabaseService.swift
//  ChatNow
//
//  Created by Zhihui Sun on 22/2/19.
//  Copyright © 2019 Sylvia Shen. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol DatabaseCodable {
    init(snapshot: DataSnapshot)
    func convertToDictionary() -> Any
}
struct DefaultCodable: DatabaseCodable {
    init(snapshot: DataSnapshot) {}
    func convertToDictionary() -> Any { return [] }
}

class DatabaseService<RecordCodable: DatabaseCodable> {
    private var databaseRef: DatabaseReference
    
    init(databaseName: String) {
        databaseRef = Database.database().reference().child(databaseName)
    }
    
    func observeValues(updateHandler: @escaping (([RecordCodable]) -> Void)) {
        databaseRef.observe(.value) { (snapshot) in
            var records: [RecordCodable] = []
            for messageSnapshot in snapshot.children.allObjects as! [DataSnapshot] {
                let record = RecordCodable(snapshot: messageSnapshot)
                records.append(record)
            }
            updateHandler(records)
        }
    }
    
    func addRecord(key: String, value: RecordCodable) {
        databaseRef.child(key).setValue(value.convertToDictionary())
    }
    
    func updateValue(key: String, value: Any) {
        databaseRef.child(key).setValue(value)
    }
}
