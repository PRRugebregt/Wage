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
    @Published var isLoading: Bool = false
    var filters: FilterOptions?
    var networkDownload: NetworkDownloadable? {
        didSet {
            loadAllFiles()
        }
    }
    var wageFileManageable: WageFileManageable?
    
    @Published var isLocal = UserDefaults.standard.object(forKey: "isLocal") as? Bool ?? false {
        didSet {
            UserDefaults.standard.setValue(isLocal, forKey: "isLocal")
        }
    }
    @Published var isPrettyView = UserDefaults.standard.object(forKey: "isPrettyView") as? Bool ?? false {
        didSet {
            UserDefaults.standard.setValue(isPrettyView, forKey: "isPrettyView")
        }
    }
    
    func loadAllFiles() {
        wageFiles = []
        if isLocal {
            print("local")
            self.wageFiles = wageFileManageable?.fetchAllFiles() ?? []
            print(filters.debugDescription) 
            if filters != nil {
                filterResults(with: filters!)
            }
        } else {
            print("Online")
            isLoading = true
            self.loadNetworkFiles()
        }
    }
    
    private func loadNetworkFiles() {
        networkDownload?.downloadAllData { queryDocuments in
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
            self.isLoading = false
            self.wageFiles = wageFiles
            if self.filters != nil {
                self.filterResults(with: self.filters!)
            }
        }
    }
    
    func sortFiles(by option: String) {
        print(wageFiles.count)
        switch option {
        case "Gage":
            wageFiles.sort(by: {$0.wage > $1.wage})
        case "Jaren Ervaring":
            wageFiles.sort(by: {$0.yearsOfExperience > $1.yearsOfExperience})
        case "Instrument":
            wageFiles.sort(by: {$0.instrument.rawValue.capitalized < $1.instrument.rawValue})
        case "Artiest Type":
            wageFiles.sort(by: {$0.artistType.rawValue < $1.artistType.rawValue})
        case "Gig Type":
            wageFiles.sort(by: {$0.gigType.rawValue < $1.gigType.rawValue})
        case "Gestudeerd":
            wageFiles.sort(by: {$0.didStudy && !$1.didStudy})
        default :
            wageFiles.sort(by: {$0.wage > $1.wage})
        }
        for wage in wageFiles {
            print(wage.wage)
        }
    }
    
    func filterResults(with options: FilterOptions) {
        self.filters = options
        print(options)
        var filteredWageFiles = self.wageFiles
        if let gigType = options.gigType {
            filteredWageFiles = filteredWageFiles.filter({$0.gigType == gigType})
        }
        if let artistType = options.artistType {
            filteredWageFiles = filteredWageFiles.filter({$0.artistType == artistType})
        }
        if let instrumentType = options.instrumentType {
            filteredWageFiles = filteredWageFiles.filter({$0.instrument == instrumentType})
        }
        if let maximum = options.wageHighLimit {
            filteredWageFiles = filteredWageFiles.filter({$0.wage < maximum})
        }
        if let minimum = options.wageLowLimit {
            filteredWageFiles = filteredWageFiles.filter({$0.wage > minimum})
        }
        self.wageFiles = filteredWageFiles
    }
    
    func setFilterOptions(with options: FilterOptions) {
        self.filters = options
    }
    
    func removeFilters() {
        self.filters = nil
    }
    
}
