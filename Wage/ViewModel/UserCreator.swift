//
//  UserCreator.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import Foundation
import Firebase

class UserCreator: ObservableObject {
    
    @Published var user: User = User()
    var newUser: Bool {
        return user.newUser
    }
    
    init() {
        authenticateAnonymous()
    }
    
    func authenticateAnonymous() {
        Auth.auth().signInAnonymously { authResult, error in
            guard error == nil else {
                print("FAILED TO LOGIN")
                print(error!.localizedDescription)
                return
            }
            print(authResult!)
        }
    }
    
    func updateInstrument(with instrument: Instrument) {
        user.updateInstrument(with: instrument)
    }
    
    func updateYearsExperience(amount: Int) {
        print(amount)
        user.updateYearsExperience(amount: amount)
    }
    
    func updateDidStudy(_ bool: Bool) {
        user.updateDidStudy(bool)
    }
    
}
