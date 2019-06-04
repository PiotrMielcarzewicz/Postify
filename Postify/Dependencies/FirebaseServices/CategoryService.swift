//
//  CategoryService.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 10/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CodableFirebase

/// sourcery: AutoDependency
protocol CategoryService: class {
    func getCategories(completion: @escaping Completion<[Category]>)
    func getCategory(id: String, completion: @escaping Completion<[Category]>)
    var cache: [Category] { get }
}

class CategoryServiceImp: CategoryService {
    private let categoriesReference: DatabaseReference = Database.database().reference().child("Categories")
    var cache: [Category] = []
    
    func getCategories(completion: @escaping Completion<[Category]>) {
        categoriesReference.observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let value = snapshot.value else {
                completion(.failure(PostifyError.missingSnapshot))
                return
            }
            do {
                let tokens = try FirebaseDecoder().decode([String: CategoryToken].self, from: value).map { $0.value }
                let categories = tokens.map { Category(token: $0) }
                self?.cache = categories
                completion(.success(categories))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func getCategory(id: String, completion: @escaping Completion<[Category]>) {
        categoriesReference.queryOrdered(byChild: "id").queryEqual(toValue: id).observeSingleEvent(of: .value) { [weak self] snapshot in
            guard let value = snapshot.value else {
                completion(.failure(PostifyError.missingSnapshot))
                return
            }
            do {
                let tokens = try FirebaseDecoder().decode([String: CategoryToken].self, from: value).map { $0.value }
                let categories = tokens.map { Category(token: $0) }
                self?.cache = categories
                completion(.success(categories))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}
