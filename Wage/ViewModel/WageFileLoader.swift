//
//  WageFileLoader.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore

class WageFileLoader: ObservableObject {
    
    enum SortOptions: String, CaseIterable, Identifiable {
        var id: String {
            rawValue
        }
        case dateHigh = "Datum (meest recent)"
        case dateLow = "Datum (oudste eerst)"
        case wageHigh = "Gage (hoog naar laag)"
        case wageLow = "Gage (laag naar hoog)"
        case yearsOfExperienceHigh = "Jaren Ervaring (hoog naar laag)"
        case yearsOfExperienceLow = "Jaren Ervaring (laag naar hoog)"
        case instrument = "Instrument"
        case gigtype = "Gig type"
        case artistType = "Show grootte"
        case didStudy = "Gestudeerd"
    }
    
    @Published var wageFiles: [WageFile] = []
    @Published var isLoading: Bool = false
    var filters: FilterOptions?
    var networkDownload: NetworkDownloadable? 
    var wageFileManageable: WageFileManageable?
    var isLocal: Bool = true {
        didSet {
            loadAllFiles()
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
                guard let id = data["id"] as? Int64 else { return }
                guard let instrumentRaw = data["instrument"] as? String else { return }
                guard let instrument = Instrument(rawValue: instrumentRaw) else { return }
                guard let gigTypeRaw = data["gigType"] as? String else { return }
                guard let gigType = GigType(rawValue: gigTypeRaw) else { return }
                guard let artistTypeRaw = data["artistType"] as? String else { return }
                guard let artistType = ArtistType(rawValue: artistTypeRaw) else { return }
                guard let yearsOfExperience = data["yearsOfExperience"] as? Int else { return }
                guard let wage = data["wage"] as? Int else { return }
                guard let didStudy = data["didStudy"] as? Bool else { return }
                guard let firTimeStamp = data["timeStamp"] as? Timestamp else { return }
                let timeStamp = firTimeStamp.dateValue()
                let wageFile = WageFile(id: id, wage: wage, artistType: artistType, gigType: gigType, yearsOfExperience: yearsOfExperience, didStudy: didStudy, instrument: instrument, timeStamp: timeStamp)
                wageFiles.append(wageFile)
            }
            self.isLoading = false
            self.wageFiles = wageFiles
            if self.filters != nil {
                self.filterResults(with: self.filters!)
            }
        }
    }
    
    func deleteWageFile(with indexes: IndexSet) {
        indexes.forEach { index in
            let wageFileToDelete = wageFiles[index]
            networkDownload?.removeWageFileOnline(wageFileToDelete)
            PersistenceController.shared.removeFromCoreData(wageFileToDelete)
            wageFiles.remove(at: index)
        }
    }
    
    func sortFiles(by option: String) {
        print(wageFiles.count)
        switch option {
        case SortOptions.dateHigh.rawValue:
            wageFiles.sort(by: {$0.timeStamp > $1.timeStamp})
        case SortOptions.dateLow.rawValue:
            wageFiles.sort(by: {$0.timeStamp < $1.timeStamp})
        case SortOptions.wageHigh.rawValue:
            wageFiles.sort(by: {$0.wage > $1.wage})
        case SortOptions.wageLow.rawValue:
            wageFiles.sort(by: {$0.wage < $1.wage})
        case SortOptions.yearsOfExperienceHigh.rawValue:
            wageFiles.sort(by: {$0.yearsOfExperience > $1.yearsOfExperience})
        case SortOptions.yearsOfExperienceLow.rawValue:
            wageFiles.sort(by: {$0.yearsOfExperience < $1.yearsOfExperience})
        case SortOptions.instrument.rawValue:
            wageFiles.sort(by: {$0.instrument.rawValue < $1.instrument.rawValue})
        case SortOptions.artistType.rawValue:
            wageFiles.sort(by: {$0.artistType.rawValue < $1.artistType.rawValue})
        case SortOptions.gigtype.rawValue:
            wageFiles.sort(by: {$0.gigType.rawValue < $1.gigType.rawValue})
        case SortOptions.didStudy.rawValue:
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
