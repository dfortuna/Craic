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
    
    private func collectionPath(ofReference collectionReference: FIRCollectionsReference) -> CollectionReference {
        let db = Firestore.firestore()
        let settings = db.settings
        db.settings = settings
        return db.collection(collectionReference.path)
    }
    
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
    
    func fetchDocumentsByKeyword<T:FIRObjectProtocol>(from collectionReference: FIRCollectionsReference, returning objectType: T.Type, keyword: String, field: String, callback: @escaping (Result<[T], FirebaseError>) -> ()) {
        
        collectionPath(ofReference: collectionReference).whereField(field, arrayContains: keyword).getDocuments { (querySnapshot, error) in
            
            let result =  self.checkResults(querySnapshot: querySnapshot, error: error, errorMessage: .documentNotFound, objectType: objectType)
            callback(result)
        }
    }
    
    func queryDocuments<T:FIRObjectProtocol>(from collectionReference: FIRCollectionsReference, returning objectType: T.Type, queryFields: [String: String], callback: @escaping (Result<[T], FirebaseError>) -> ()) {
        
        let path = collectionPath(ofReference: collectionReference)
        for (field, value) in queryFields {
            path.whereField(field, isEqualTo: value)
        }
        path.getDocuments { (snapshot, error) in
            let result = self.checkResults(querySnapshot: snapshot, error: error, errorMessage: .documentNotFound, objectType: objectType)
            callback(result)
        }
    }
    
    private func checkResults<T:FIRObjectProtocol>(querySnapshot: QuerySnapshot?, error: Error?, errorMessage: FirebaseError, objectType: T.Type) -> Result<[T], FirebaseError> {
        if error != nil {
            return (.failure(.documentNotFetched))
        } else {
            guard let snapshot = querySnapshot else {
                return (.failure(.documentNotFetched))
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
    
    func delete(documentID: String, in collectionReference: FIRCollectionsReference, callback: @escaping (Result<String, FirebaseError>) -> ()) {
        
        collectionPath(ofReference: collectionReference).document(documentID).delete { (error) in
            if error != nil {
                callback(.failure(.documentNotDeleted))
            } else {
                callback(.success(""))
            }
        }
    }
}
