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
    var all: [WageFile] { get }
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
    
    init(networkDownload: NetworkDownloadable) {
        self.networkDownload = networkDownload
    }
    
    func appendNewFile(_ file: WageFile) {
        all.append(file)
    }
    
    func fetchAllFiles() -> [WageFile] {
        all
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
