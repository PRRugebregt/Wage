//
//  User.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import Foundation
import CocoaLumberjackSwift

enum Instrument: String, CaseIterable, Identifiable, Codable {
    var id: RawValue {
        rawValue
    }
    case Vocalen,
         Piano,
         Keyboards,
         Gitaar,
         Drums,
         Bas,
         Viool,
         Cello,
         Contrabas,
         Percussie,
         Saxofoon,
         Trompet,
         Trombone,
         Klarinet,
         Hobo,
         Hoorn,
         KlassiekGitaar = "Klassiek Gitaar",
         Fluit,
         Anders
}

struct User {
    
    var isNewUser: Bool
    var yearsOfExperience: Int
    var didStudy: Bool
    var instrument: Instrument
        
    init() {
        guard let user = PersistenceController.shared.fetchUser() else {
            DDLogInfo("[User] no user found")
            yearsOfExperience = 0
            instrument = .Anders
            didStudy = false
            isNewUser = true
            PersistenceController.shared.createUserObject(self)
            return
        }
        
        DDLogInfo("[User] user found: \(user)")
        isNewUser = false
        yearsOfExperience = Int(user.yearsOfExperience)
        instrument = Instrument(rawValue: user.instrument ?? "Anders") ?? .Anders
        didStudy = user.didStudy
        NotificationCenter.default.post(Notification(name: .shareUser, object: nil, userInfo: ["user":self]))        
    }
    
    mutating func updateInstrument(with instrument: Instrument) {
        self.instrument = instrument
        PersistenceController.shared.modifyUserObject(with: self)
    }
    
    mutating func updateYearsExperience(amount: Int) {
        yearsOfExperience = amount
        PersistenceController.shared.modifyUserObject(with: self)
    }
    
    mutating func updateDidStudy(_ bool: Bool) {
        didStudy = bool
        PersistenceController.shared.modifyUserObject(with: self)
    }
}
