//
//  WageFileLoader.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI
import Firebase

class WageFileLoader: ObservableObject {
    
    @Published var wageFiles: [WageFile] = []
    init() {
        self.loadLocalFiles()
    }
    private var networkDownload = NetworkDownload()
    var isLocal = UserDefaults.standard.object(forKey: "isLocal") as? Bool ?? true {
        didSet {
            UserDefaults.standard.setValue(isLocal, forKey: "isLocal")
        }
    }
    
    func loadLocalFiles() {
        if isLocal {
            self.wageFiles = WageFiles.shared.all
        } else {
            loadNetworkFiles()
        }
    }
    
    private func loadNetworkFiles() {
        networkDownload.downloadAllData { queryDocuments in
            var wageFiles = [WageFile]()
            for file in queryDocuments {
                let data = file.data()
                let id = data["id"] as! Int64
                let instrument = Instrument(rawValue: data["instrument"] as! String)
                let gigType = GigType(rawValue: data["gigType"] as! String)
                let artistType = ArtistType(rawValue: data["artistType"] as! String)
                let yearsOfExperience = data["yearsOfExperience"] as! Int
                let wage = data["wage"] as! Int
                let didStudy = data["didStudy"] as! Bool
                let wageFile = WageFile(id: id, wage: wage, artistType: artistType!, gigType: gigType!, yearsOfExperience: yearsOfExperience, didStudy: didStudy, instrument: instrument!)
                wageFiles.append(wageFile)
            }
            self.wageFiles = wageFiles
        }
    }
    
    func sortFiles(by option: String) {
        switch option {
        case "Gage":
            wageFiles.sort(by: {$0.wage > $1.wage})
        case "Jaren Ervaring":
            wageFiles.sort(by: {$0.yearsOfExperience > $1.yearsOfExperience})
        case "Instrument":
            wageFiles.sort(by: {$0.instrument.rawValue < $1.instrument.rawValue})
        case "Artiest Type":
            wageFiles.sort(by: {$0.artistType.rawValue < $1.artistType.rawValue})
        case "Gig Type":
            wageFiles.sort(by: {$0.gigType.rawValue < $1.gigType.rawValue})
        case "Gestudeerd":
            wageFiles.sort(by: {$0.didStudy && !$1.didStudy})
        default :
            wageFiles.sort(by: {$0.wage > $1.wage})
        }
    }
    
    func filterResults(with options: FilterOptions) {
        print(options)
        var filteredWageFiles = WageFiles.shared.all
        if let gigType = options.gigType {
            filteredWageFiles = filteredWageFiles.filter({$0.gigType == gigType})
        }
        if let artistType = options.artistType {
            filteredWageFiles = filteredWageFiles.filter({$0.artistType == artistType})
        }
        if let maximum = options.wageHighLimit {
            filteredWageFiles = filteredWageFiles.filter({$0.wage < maximum})
        }
        if let minimum = options.wageLowLimit {
            filteredWageFiles = filteredWageFiles.filter({$0.wage > minimum})
        }
        self.wageFiles = filteredWageFiles
    }
    
}
