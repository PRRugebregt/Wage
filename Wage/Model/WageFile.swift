//
//  WageFile.swift
//  Wage
//
//  Created by Patrick Rugebregt on 11/02/2022.
//

import Foundation

enum ArtistType: String, CaseIterable, Identifiable {
    var id: RawValue {
        rawValue
    }
    case Groot
    case Midden
    case Klein
}

enum GigType: String, CaseIterable, Identifiable {
    var id: RawValue {
        rawValue
    }
    case club
    case festival
    case theater
    case event
    case promo
    case other
}

class WageFiles {
    static let shared = WageFiles()
    private var isLocal = true
    private var networkDownload = NetworkDownload()

    var all: [WageFile] {
        get {
            if isLocal {
                return PersistenceController.shared.loadAllObjects()
            } else {
                loadNetworkFiles()
                return []
            }
        }
        set {}
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
            self.all = wageFiles
        }
    }
    
    func appendNewFile(_ file: WageFile) {
        all.append(file)
    }
    
}

struct WageFile: Identifiable, Equatable, Hashable {
    
    static func == (lhs: WageFile, rhs: WageFile) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    let id: Int64
    let wage: Int
    let artistType: ArtistType
    let gigType: GigType
    let yearsOfExperience: Int
    let didStudy: Bool
    let instrument: Instrument
    
    enum CodingKeys: String {
        case id
        case wage
        case artistType = "artist_type"
        case gigType = "gig_type"
    }
    
}
