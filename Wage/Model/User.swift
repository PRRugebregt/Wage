//
//  User.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import Foundation

enum Instrument: String, CaseIterable, Identifiable {
    var id: RawValue {
        rawValue
    }
    case Vocalen
    case Piano
    case Keyboards
    case Gitaar
    case Drums
    case Bas
    case Viool
    case Cello
    case Contrabas
    case Percussie
    case Saxofoon
    case Trompet
    case Trombone
    case Klarinet
    case Hobo
    case Hoorn
    case KlassiekGitaar = "Klassiek Gitaar"
    case Fluit
    case Anders
}

struct User {
    
    var newUser: Bool
    var yearsOfExperience: Int
    var didStudy: Bool
    var instrument: Instrument
    private var coreDataObject: UserObject?
    
    init() {
        let users = PersistenceController.shared.fetchUser()
        
        guard users.count > 0 else {
            print("no user found")
            yearsOfExperience = 0
            instrument = .Anders
            didStudy = false
            newUser = true
            PersistenceController.shared.createUserObject(self)
            return
        }
        print("yes user found")
        newUser = false
        coreDataObject = users[0]
        yearsOfExperience = Int(users[0].yearsOfExperience)
        instrument = Instrument(rawValue: users[0].instrument!)!
        didStudy = users[0].didStudy
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
