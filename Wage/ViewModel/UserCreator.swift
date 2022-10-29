//
//  UserCreator.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import Foundation
import Firebase
import CocoaLumberjackSwift

class UserCreator: ObservableObject {
    
    @Published var user: User = User()
    var newUser: Bool {
        return user.newUser
    }
    
    init() {
        authenticateAnonymous()
    }
    
    private func authenticateAnonymous() {
        Auth.auth().signInAnonymously { authResult, error in
            guard error == nil else {
                DDLogInfo("FAILED TO LOGIN")
                DDLogError(error!.localizedDescription)
                return
            }
            DDLogInfo(authResult!)
        }
    }
    
    func updateInstrument(with instrument: Instrument) {
        user.updateInstrument(with: instrument)
    }
    
    func updateYearsExperience(amount: Int) {
        user.updateYearsExperience(amount: amount)
    }
    
    func updateDidStudy(_ bool: Bool) {
        user.updateDidStudy(bool)
    }
    
}
