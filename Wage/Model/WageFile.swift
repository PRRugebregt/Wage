//
//  WageFile.swift
//  Wage
//
//  Created by Patrick Rugebregt on 11/02/2022.
//

import Foundation

enum ArtistType: String, CaseIterable, Identifiable, Codable {
    var id: RawValue {
        rawValue
    }
    case Groot
    case Midden
    case Klein
}

enum GigType: String, CaseIterable, Identifiable, Codable {
    var id: RawValue {
        rawValue
    }
    case club
    case festival
    case theater 
    case privefeest
    case bedrijfsfeest
    case bruiloft
    case musical
    case radio
    case tv
    case studiodag
    case orkest
    case repetitie
    case anders
}

protocol WageFileManageable {
    var all: [WageFile] { get set }
    func appendNewFile(_ file: WageFile)
    func fetchAllFiles() -> [WageFile]
}

class WageFiles: WageFileManageable {
    
    private var networkDownload: NetworkDownloadable
    var all: [WageFile] {
        get {
            return PersistenceController.shared.loadAllObjects()
        }
        set {}
    }
    
    init(dependencies: HasNetwork) {
        self.networkDownload = dependencies.injectNetwork()
    }
    
    func appendNewFile(_ file: WageFile) {
        all.append(file)
    }
    
    func fetchAllFiles() -> [WageFile] {
        all
    }
    
}

struct WageFile: Identifiable, Equatable, Codable {
    
    let id: Int64
    let wage: Int
    let artistType: ArtistType
    let gigType: GigType
    let yearsOfExperience: Int
    let didStudy: Bool
    let instrument: Instrument
    let timeStamp: Date
    var dateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: timeStamp)
    }
    
    init(
        id: Int64,
        wage: Int,
        artistType: ArtistType,
        gigType: GigType,
        yearsOfExperience: Int,
        didStudy: Bool,
        instrument: Instrument,
        timeStamp: Date
    ) {
        self.id = id
        self.wage = wage
        self.artistType = artistType
        self.gigType = gigType
        self.yearsOfExperience = yearsOfExperience
        self.didStudy = didStudy
        self.instrument = instrument
        self.timeStamp = timeStamp
    }
    
    init?(firestoreDictionary: [String: Any]) {
        self.id = firestoreDictionary["id"] as? Int64 ?? 0
        let instrumentRaw = firestoreDictionary["instrument"] as? String ?? "Anders"
        self.instrument = Instrument(rawValue: instrumentRaw) ?? .Anders
        let gigTypeRaw = firestoreDictionary["gigType"] as? String ?? "anders"
        self.gigType = GigType(rawValue: gigTypeRaw) ?? .anders
        let artistTypeRaw = firestoreDictionary["artistType"] as? String ?? "Midden"
        self.artistType = ArtistType(rawValue: artistTypeRaw) ?? .Midden
        self.yearsOfExperience = firestoreDictionary["yearsOfExperience"] as? Int ?? 0
        self.wage = firestoreDictionary["wage"] as? Int ?? 0
        self.didStudy = firestoreDictionary["didStudy"] as? Bool ?? false
        self.timeStamp = firestoreDictionary["timeStamp"] as? Date ?? .now
    }
    
    static func == (lhs: WageFile, rhs: WageFile) -> Bool {
        lhs.id == rhs.id
    }
    
}

private enum CodingKeys: String, CodingKey {
    case id, wage, yearsOfExperience, didStudy, instrument, timeStamp, dateFormatted
    case artistType = "artist_type"
    case gigType = "gig_type"
}
