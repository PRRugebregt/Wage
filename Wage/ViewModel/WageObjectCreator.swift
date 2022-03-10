//
//  WageObjectCreatpr.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import Foundation
import SwiftUI

class WageObjectCreator {
    
    private var wageObject: WageFile?
    private var network = NetworkUpload()
    private var user: User? {
        PersistenceController.shared.user
    }
    var wage: String = ""
    var gigType: GigType?
    var artistType: ArtistType?
    var instrument: Instrument?
    
    func createObject() {
        guard let wageInt = Int(wage), let gigType = self.gigType, let artistType = self.artistType else { return }
        wageObject = WageFile(id: Int64.random(in: 0..<Int64.max), wage: wageInt, artistType: artistType, gigType: gigType, yearsOfExperience: user?.yearsOfExperience ?? 0, didStudy: user?.didStudy ?? false, instrument: instrument ?? .Anders, timeStamp: Date.now)
        if let wageObject = wageObject {
            PersistenceController.shared.createObject(wageFile: wageObject)
            network.upload(wageFile: wageObject)
        }
    }
    
}
