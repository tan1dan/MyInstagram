//
//  StorageManager.swift
//  MyInstagram
//
//  Created by Иван Знак on 20/02/2024.
//

import Foundation
import FirebaseStorage

class StorageManager {
    static let shared = StorageManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    private var productsRef: StorageReference {
        storage.child("posts")
    }
    
    func upload(id: String, image: Data){
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        productsRef.child(id).putData(image, metadata: metadata)
    }
    
    func download(id: String, completion: @escaping (Result<Data, Error>) -> ()){
        
        productsRef.child(id).getData(maxSize: 2 * 1024 * 1024) { data, error in
            guard let data = data else {
                if let error = error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(data))
        }
    }
}
