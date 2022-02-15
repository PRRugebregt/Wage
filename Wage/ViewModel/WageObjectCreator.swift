//
//  WageObjectCreatpr.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import Foundation

class WageObjectCreator {
    
    private var user: User = User()
    private var wageObject: WageFile?
    private var network = NetworkUpload()
    var wage: String = ""
    var gigType: GigType?
    var artistType: ArtistType?
    
    func createObject() {
        guard wage != "", let gigType = self.gigType, let artistType = self.artistType else { return }
        let wageInt = Int(wage)!
        wageObject = WageFile(id: Int64.random(in: 0..<Int64.max), wage: wageInt, artistType: artistType, gigType: gigType, yearsOfExperience: user.yearsOfExperience, didStudy: user.didStudy, instrument: user.instrument)
        PersistenceController.shared.createObject(wageFile: wageObject!)
        network.upload(wageFile: wageObject!)
    }
    
}
