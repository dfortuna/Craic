//
//  RealmService.swift
//  Craic
//
//  Created by Denis Fortuna on 18/6/20.
//  Copyright © 2020 Denis Fortuna. All rights reserved.
//

import Foundation
import RealmSwift

class RealmService {
    
    private init() {}
    static let shared = RealmService()
    let realm = try! Realm()
    
    func create<T: Object>(_ object: T) {
        do {
            try realm.write {
                print("realm write")
                realm.add(object, update: .all)
                print("realm add")
            }
        } catch {
            print("create object error catched")
        }
    }
    
    func update<T: Object>(_ object: T, with dictionary: [String: Any?]){
        do {
            try realm.write {
                for (key, value) in dictionary {
                    object.setValue(value, forKey: key)
                }
            }
        } catch {
            print()
        }
    }
    
    func delete<T: Object>(_ object: T){
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            print()
        }
    }
    
    func updateObject(ofPrimaryKey id: String,
                      withAttributes dic: [String: Any?],
                      fromCollection collType: RealmCollectionTypes) {
        guard let doc = getDocument(PrimaryKey: id, fromCollection: collType) else { return }
        update(doc, with: dic)
    }
    
    func deleteObject(ofPrimaryKey id: String, fromCollection collType: RealmCollectionTypes) {
        guard let doc = getDocument(PrimaryKey: id, fromCollection: collType) else { return }
        delete(doc)
    }
    
    func getDocument(PrimaryKey id: String, fromCollection collType: RealmCollectionTypes) -> Object? {
        return realm.object(ofType: collType.path, forPrimaryKey: id)
    }
    
    func query<T: Object>(collection: RealmCollectionTypes,
                          attributes: [(field: String, operator: String, value: String)],
                          sortedByFiled sortedBy: String,
                          ascending: Bool,
                          documentType: T.Type) -> [T] {
        var predicate = ""
        for (index, attribute) in attributes.enumerated() {
            predicate += attribute.field + " " + attribute.operator + " " + "'" + attribute.value + "'"
            if index < attributes.count - 1 {
                predicate += " AND "
            }
        }
        
        let result = realm.objects(RealmCollectionTypes.localMessage.path)
            .filter(predicate).sorted(byKeyPath: sortedBy, ascending: ascending)
        
//        let test1 =  Array(result) as! [T]
        return  Array(result.compactMap{ $0 as? T })
    }
}
