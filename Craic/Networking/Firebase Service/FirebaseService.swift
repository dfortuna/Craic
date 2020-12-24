//
//  FirebaseService.swift
//  Project4
//
//  Created by Denis Fortuna on 7/11/18.
//  Copyright © 2018 Denis Fortuna. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FirebaseService {
    
    private init() {}
    static let shared = FirebaseService()
    private var listeners = [String: ListenerRegistration]()
    
    private func getDataBaseReference() -> Firestore {
        return Firestore.firestore()
    }
    
    private func collectionPath(ofReference collectionReference: FIRCollectionsReference) -> CollectionReference {
        let db = getDataBaseReference()
        let settings = db.settings
        db.settings = settings
        
        return db.collection(collectionReference.path)
    }
    
    //MARK: - Write
    
    func create<T: FIRObjectProtocol>(for encodableObject: T, in collectionReference: FIRCollectionsReference, callback: @escaping (Result<String, FirebaseError>) -> ()) {
        do {
            let json = try encodableObject.toJson(excluding: ["id"])
            let documentID = encodableObject.id
            collectionPath(ofReference: collectionReference).document(documentID).setData(json)
            callback(.success("000"))
        } catch {
            callback(.failure(.documentNotCreated))
        }
    }
    
    func getDocument<T: FIRObjectProtocol>(documentID: String, documentType: T.Type, fromCollection path: FIRCollectionsReference,callback: @escaping (Result<T, FirebaseError>) -> ()) {
        
        collectionPath(ofReference: path).document(documentID).getDocument { (document, error) in
            if let document = document, document.exists {
                if let documentResult = document.toObject(objectType: documentType){
                    callback(.success(documentResult))
                }
            } else {
                callback(.failure(.documentNotFound))
            }
        }
    }
    
    func fetchWithListener<T:FIRObjectProtocol>(from collectionReference: FIRCollectionsReference,
                                                returning objectType: T.Type,
                                                callback: @escaping (Result<[T], FirebaseError>) -> ()) {
        
        let listener = collectionPath(ofReference: collectionReference).addSnapshotListener { (querySnapshot, error) in
            let result =  self.checkResults(querySnapshot: querySnapshot, error: error, errorMessage: .documentNotFound, objectType: objectType)
            callback(result)
        }
        listeners[collectionPath(ofReference: collectionReference).path] = listener
    }
    
    
    func fetchDocumentsByKeyword<T:FIRObjectProtocol>(from collectionReference: FIRCollectionsReference,
                                                      returning objectType: T.Type,
                                                      keyword: String,
                                                      field: String,
                                                      callback: @escaping (Result<[T], FirebaseError>) -> ()) {
        
        collectionPath(ofReference: collectionReference)
            .whereField(field, arrayContains: keyword)
            .getDocuments { (querySnapshot, error) in
            
            let result =  self.checkResults(querySnapshot: querySnapshot, error: error, errorMessage: .documentNotFound, objectType: objectType)
            callback(result)
        }
    }
    
    func queryDocuments<T:FIRObjectProtocol>(from collectionReference: FIRCollectionsReference,
                                             returning objectType: T.Type,
                                             operatorKeyValue: [(key: String, op: String, value: String)],
                                             orderByField field: String?,
                                             descending: Bool?,
                                             callback: @escaping (Result<[T], FirebaseError>) -> ()) {
        
        var query: Query?
        if !operatorKeyValue.isEmpty {
            let path = collectionPath(ofReference: collectionReference)
            if operatorKeyValue.count <= 1 {
                if let queryResult = queryRouter(path: path,
                                                 key: operatorKeyValue.first!.key,
                                                 value: operatorKeyValue.first!.value,
                                                 queryOperator: operatorKeyValue.first!.op) {
                    query = queryResult
                }
            } else {
                query = addQuery(path: path, operatorKeyValue: operatorKeyValue)
            }
            
            if let f = field, let d = descending {
                query?.order(by: f, descending: d)
            }
            
            query?.getDocuments() { (querySnapshot, err) in
                let results = self.checkResults(querySnapshot: querySnapshot, error: err, errorMessage: .documentNotFound, objectType: objectType)
                callback(results)
            }
        }
    }
    
    private func addQuery(path: Query, operatorKeyValue: [(key: String, op: String, value: String)]) -> Query {
        
        var queryPath = path
        var opKeyValMutable = operatorKeyValue

        if !opKeyValMutable.isEmpty {
            if  let key = opKeyValMutable.first?.key,
                let op = opKeyValMutable.first?.op,
                let value = opKeyValMutable.first?.value {
                
                opKeyValMutable = opKeyValMutable.filter { $0.key != key}
                if let queryResult = queryRouter(path: path, key: key, value: value, queryOperator: op) {
                    queryPath = queryResult
                }
            } else {
                opKeyValMutable = opKeyValMutable.compactMap{ $0 }
            }
        }
        return queryPath
    }
    
    private func queryRouter(path: Query, key: String, value: String, queryOperator: String) -> Query? {
        switch queryOperator {
        case "==":
            return path.whereField(key, isEqualTo: value)
        case ">=":
            return path.whereField(key, isGreaterThanOrEqualTo: value)
        case "<=":
            return path.whereField(key, isLessThanOrEqualTo: value)
        case ">":
            return path.whereField(key, isGreaterThan: value)
        case "<":
            return path.whereField(key, isLessThan: value)
        default:
            return nil
        }
    }
    
    
    private func checkResults<T:FIRObjectProtocol>(querySnapshot: QuerySnapshot?,
                                                   error: Error?,
                                                   errorMessage: FirebaseError,
                                                   objectType: T.Type) -> Result<[T], FirebaseError> {
        if error != nil {
            return (.failure(errorMessage))
        } else {
            guard let snapshot = querySnapshot else {
                return (.failure(errorMessage))
            }
            var documentsResult = [T]()
            for document in snapshot.documents {
                if let documentResult = document.toObject(objectType: objectType) {
                    documentsResult.append(documentResult)
                }
            }
            return (.success(documentsResult))
        }
    }
    
    func removeListener(from collectionReference: FIRCollectionsReference) {
        guard let listener = listeners[collectionPath(ofReference: collectionReference).path] else {return }
        listener.remove()
    }
    
    func update(objectID: String,
                in collectionReference: FIRCollectionsReference,
                dataToUpdate: [String: AnyObject],
                callback: @escaping (Result<String, FirebaseError>) -> ()) {
        
        collectionPath(ofReference: collectionReference).document(objectID).updateData(dataToUpdate) { (error) in
            if error != nil {
                callback(.failure(.documentNotUpdated))
            } else {
              callback(.success("Document Updated!"))
            }
        }
    }
    
    func updateMergeData(objectID: String,
                         in collectionReference: FIRCollectionsReference,
                         dataToUpdate: [String: Any],
                         callback: @escaping (Result<String, FirebaseError>) -> ()) {
        
        collectionPath(ofReference: collectionReference).document(objectID).setData(dataToUpdate, merge: true) { (error) in
            if error != nil {
                callback(.failure(.dataNotMerged))
            } else {
                callback(.success("Data Merged!"))
            }
        }
    }
    
    func updateFieldArrayUnion(objectID: String,
                               in collectionReference: FIRCollectionsReference,
                               fieldName: String,
                               fieldValue: String ) {
        collectionPath(ofReference: collectionReference).document(objectID).updateData([
            fieldName: FieldValue.arrayUnion([fieldValue])
        ])
    }
    
    func updateFieldArrayRemove(objectID: String,
                               in collectionReference: FIRCollectionsReference,
                               fieldName: String,
                               fieldValue: String ) {
        collectionPath(ofReference: collectionReference).document(objectID).updateData([
            fieldName: FieldValue.arrayRemove([fieldValue])
        ])
    }
    
    func delete(documentID: String, in collectionReference: FIRCollectionsReference, callback: @escaping (Result<String, FirebaseError>) -> ()) {
        
        collectionPath(ofReference: collectionReference).document(documentID).delete { (error) in
            if error != nil {
                callback(.failure(.documentNotDeleted))
            } else {
                callback(.success(""))
            }
        }
    }
    
    
    //Increment(n) or decrement(-n) a numeric field by giving number n
    func incrementField(field: String,
                        documentID: String,
                        incrementBy n: Int,
                        collectionReference: FIRCollectionsReference) {
        collectionPath(ofReference: collectionReference).document(documentID)
            .updateData([field: FieldValue.increment(Int64(n))])
    }
    
    
    //Search for field and value across all collections with name collectionID, across the whole database
    func collectionGroupQuery<T:FIRObjectProtocol>(collectionID: String, field: String, queryOperator: String, value: String, returning objectType: T.Type, callback: @escaping (Result<[T], FirebaseError>) -> ()) {
        
        let colGroupReference = getDataBaseReference().collectionGroup(collectionID)
        let query = queryRouter(path: colGroupReference, key: field, value: value, queryOperator: queryOperator)
        query?.getDocuments(completion: { (snapshot, error) in
            
            print("***************************************")
            print(error)
            let result = self.checkResults(querySnapshot: snapshot, error: error, errorMessage: .dataNotMerged, objectType: objectType)
            callback(result)
        })
    }
    
    
    func batchDelete<T:FIRObjectProtocol>(forDocuments documents: [T],
                                           reference: FIRCollectionsReference,
                                           callback: @escaping (Result<String, FirebaseError>) -> ()) {
        
        let batch = getDataBaseReference().batch()
        
        for document in documents {
            let collectionReference = collectionPath(ofReference: reference).document(document.id)
            batch.deleteDocument(collectionReference)
        }
        
        batch.commit { (error) in
            if error != nil {
                callback(.failure(.documentNotDeleted))
            } else {
                callback(.success("000"))
            }
        }
    }
}
