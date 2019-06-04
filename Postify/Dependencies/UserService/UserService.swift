//
//  UserService.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 03/04/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import CodableFirebase

enum UserState {
    case loggedIn(User)
    case loggedOut
}

/// sourcery: AutoDependency
protocol UserService: class {
    var state: UserState { get }
    func signIn(with credentials: Credentials, completion: @escaping Completion<User>)
    func signUp(with form: UserForm, completion: @escaping Completion<Void>)
    func signOut()
    func sendResetPasswordEmail(with email: String, completion: @escaping Completion<Void>)
    func updateUser(_ user: User, completion: @escaping Completion<Void>)
    func getUser(id: String, completion: @escaping Completion<User>)
    func validateCurrentSessionToken(completion: @escaping Completion<Void>)
}

class UserServiceImp: UserService {
    private let usersReference = Database.database().reference().child("Users")
    private let userStorage: UserStorageService
    
    init(userStorage: UserStorageService) {
        self.userStorage = userStorage
    }
    
    var state: UserState {
        if let user = userStorage.getUser(), let firUser = Auth.auth().currentUser, user.id == firUser.uid {
            return .loggedIn(user)
        } else {
            try? Auth.auth().signOut()
            userStorage.clearUser()
            return .loggedOut
        }
    }
    
    func signIn(with credentials: Credentials, completion: @escaping Completion<User>) {
        Auth.auth().signIn(withEmail: credentials.email, password: credentials.password) { [weak self] (result, error) in
            guard let `self` = self else { return }
            if let error = error  {
                completion(.failure(error))
                self.userStorage.clearUser()
                return
            }
            
            guard let userID = result?.user.uid else {
                try? Auth.auth().signOut()
                completion(.failure(PostifyError.failedToFetchUser))
                self.userStorage.clearUser()
                return
            }
            
            self.usersReference.child(userID).observeSingleEvent(of: .value, with: { [weak self] snapshot in
                guard let `self` = self else { fatalError("Self shouldn't be nil here") }
                guard let value = snapshot.value else {
                    try? Auth.auth().signOut()
                    self.userStorage.clearUser()
                    completion(.failure(PostifyError.missingSnapshot))
                    return
                }
                
                do {
                    let user = try FirebaseDecoder().decode(User.self, from: value)
                    let deviceToken = UIDevice.current.identifierForVendor!.uuidString
                    self.usersReference.child(userID + "/sessionToken").setValue(deviceToken)
                    completion(.success(user))
                    self.userStorage.saveUser(user)
                } catch {
                    try? Auth.auth().signOut()
                    completion(.failure(PostifyError.failedToFetchUser))
                    self.userStorage.clearUser()
                }
            })
        }
    }
    
    func signUp(with form: UserForm, completion: @escaping Completion<Void>) {
        Auth.auth().createUser(withEmail: form.email, password: form.password) { [weak self] (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = result else {
                completion(.failure(PostifyError.failedToFetchUser))
                return
            }
            
            self?.saveUserToDatabase(with: form,
                                     id: result.user.uid,
                                     completion: completion)
        }
    }
    
    func signOut() {
        try? Auth.auth().signOut()
        userStorage.clearUser()
    }
    
    func sendResetPasswordEmail(with email: String, completion: @escaping Completion<Void>) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func updateUser(_ user: User, completion: @escaping Completion<Void>) {
        let data = try! FirebaseEncoder().encode(user)
        usersReference.child(user.id).setValue(data) { [weak self] (error, reference) in
            if let error = error {
                completion(.failure(error))
            } else {
                self?.userStorage.saveUser(user)
                completion(.success(()))
                let deviceToken = UIDevice.current.identifierForVendor!.uuidString
                self?.usersReference.child(user.id + "/sessionToken").setValue(deviceToken)
            }
        }
    }
    
    func validateCurrentSessionToken(completion: @escaping Completion<Void>) {
        if let user = userStorage.getUser(), let firUser = Auth.auth().currentUser, user.id == firUser.uid {
            self.usersReference.child(user.id + "/sessionToken").observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value else {
                    try? Auth.auth().signOut()
                    self.userStorage.clearUser()
                    completion(.failure(PostifyError.missingSnapshot))
                    return
                }
                
                do {
                    let sessionToken = try FirebaseDecoder().decode(String.self, from: value)
                    let deviceToken = UIDevice.current.identifierForVendor!.uuidString
                    if sessionToken == deviceToken {
                        completion(.success(()))
                    } else {
                        try? Auth.auth().signOut()
                        completion(.failure(PostifyError.invalidSessionToken))
                        self.userStorage.clearUser()
                    }
                } catch {
                    try? Auth.auth().signOut()
                    completion(.failure(PostifyError.invalidSessionToken))
                    self.userStorage.clearUser()
                }
            }
        } else {
            try? Auth.auth().signOut()
            self.userStorage.clearUser()
            completion(.failure(PostifyError.invalidSessionToken))
        }
    }
    
    func getUser(id: String, completion: @escaping Completion<User>) {
        self.usersReference.child(id).observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let `self` = self else { fatalError("Self shouldn't be nil here") }
            guard let value = snapshot.value else {
                completion(.failure(PostifyError.missingSnapshot))
                return
            }
            
            do {
                let user = try FirebaseDecoder().decode(User.self, from: value)
                completion(.success(user))
            } catch {
                completion(.failure(PostifyError.failedToFetchUser))
            }
        })
    }
}

private extension UserServiceImp {
    func saveUserToDatabase(with form: UserForm, id: String, completion: @escaping Completion<Void>) {
        let user = User(id: id,
                        email: form.email,
                        firstName: form.firstName,
                        lastName: form.lastName,
                        phoneNumber: form.phoneNumber,
                        city: form.city,
                        country: form.country,
                        publicPhoneNumber: false)
        let data = try! FirebaseEncoder().encode(user)
        usersReference.child(id).setValue(data) { (error, reference) in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
