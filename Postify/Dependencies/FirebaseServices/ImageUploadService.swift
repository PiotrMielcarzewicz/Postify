//
//  ImageUploadService.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 11/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import FirebaseStorage

/// sourcery: AutoDependency
protocol ImageUploadService {
    func uploadImage(_ image: UIImage, id: String, completion: @escaping Completion<URL>)
}

class ImageUploadServiceImp: ImageUploadService {
    private let storageRef = Storage.storage().reference().child("images")
    
    func uploadImage(_ image: UIImage, id: String, completion: @escaping Completion<URL>) {
        guard let data = image.jpegData(compressionQuality: 1.0) else {
            fatalError("Data shouldn't be nil here")
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        storageRef.child(id).putData(data, metadata: metadata) { [weak self] (metadata, error) in
            guard metadata != nil else {
                completion(.failure(PostifyError.missingMetadata))
                return
            }
            
            if let error = error {
                completion(.failure(error))
            } else {
                self?.getDownloadURL(id: id, completion: completion)
            }
        }
    }
}

private extension ImageUploadServiceImp {
    func getDownloadURL(id: String, completion: @escaping Completion<URL>) {
        storageRef.child(id).downloadURL { (url, error) in
            guard let downloadURL = url else {
                completion(.failure(PostifyError.missingURL))
                return
            }
            
            completion(.success(downloadURL))
        }
    }
}
