//
//  UserService.swift
//  tinder
//
//  Created by José Alves da Cunha on 20/02/21.
//

import Foundation

class UserService {
    
    static let shared = UserService()
    
    let users: [User] = [
        User(id: 101, name: "Hope", age: 2, match: true, description: "Sou uma doguinha muito amavel e carinhosa", photo: "dog1"),
        User(id: 102, name: "Geraldo", age: 1, match: true, description: "Sou muito arteiro", photo: "dog2"),
        User(id: 103, name: "Scooby", age: 3, match: false, description: "Sou grande porem docil", photo: "dog3"),
        User(id: 104, name: "K9", age: 3, match: false, description: "Cuidado sou policial", photo: "dog4"),
        User(id: 105, name: "Hulk", age: 4, match: false, description: "Só tenho cara de mal, mas sou um anjinho.", photo: "dog5"),
        User(id: 106, name: "Django", age: 5, match: true, description: "Sou fiel, é nois.", photo: "dog6")
    ]
    
    func searchUsers(completion: @escaping([User]?, Error?) -> ()) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            completion(self.users, nil)
        }
    }
}
