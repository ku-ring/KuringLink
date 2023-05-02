//
//  Account.swift
//  
//
//  Created by Jaesung Lee on 2023/05/01.
//

import Combine

// TODO: Firebase
public actor Account: ObservableObject {
    @Published var nickname: String?
    @Published var profileURL: String?
    
    func updateNickname() async {
        
    }
    
    func updateProfileImage() async {
        
    }
}
