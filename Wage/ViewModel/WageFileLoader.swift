//
//  WageFileLoader.swift
//  Wage
//
//  Created by Patrick Rugebregt on 12/02/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import CocoaLumberjackSwift

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

class WageFileLoader: ObservableObject {
    
    typealias Dependencies = HasNetwork & HasWageFileManageable & HasFiltering
    
    @Published var wageFiles: [WageFile] = []
    @Published var isLoading: Bool = false
    var onlineResults: [WageFile] = []
    var filters: FilterOptions?
    var dependencies: Dependencies!
    lazy var networkDownload: NetworkDownloadable = dependencies.injectNetwork()
    lazy var wageFileManageable: WageFileManageable = dependencies.injectWageFileManageable()
    lazy var filtering: Filtering = dependencies.injectFiltering()
    var isLocal = true {
        didSet {
            Task {
                await loadAllFiles()
            }
        }
    }
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func loadAllFiles() async {
        if isLocal {
            DDLogInfo("Loading local files only")
            DDLogInfo(filters.debugDescription)
            DispatchQueue.main.async {
                self.wageFiles = self.wageFileManageable.fetchAllFiles()
            }
        } else {
            DDLogInfo("Loading online results")
            guard let onlineResults = try? await loadNetworkFiles() else { return }
            DispatchQueue.main.async {
                self.isLoading = true
                self.wageFiles = onlineResults
            }
        }
        
        if let filters {
            filterResults(with: filters)
        }
    }
    
    func loadNetworkFiles() async throws -> [WageFile] {
        do {
            let queryDocuments = try await networkDownload.downloadAllData()
            var wageFiles = [WageFile]()
            
            for file in queryDocuments {
                let data = file.data()
                guard let wageFile = WageFile(firestoreDictionary: data) else {
                    DDLogInfo("wagefile conversion failed from firestore dictionary")
                    continue
                }
                wageFiles.append(wageFile)
            }
            DispatchQueue.main.async {
                self.isLoading = false
            }
            return wageFiles
        } catch {
            throw error
        }
    }
    
    func deleteWageFile(with indexes: IndexSet) {
        indexes.forEach { index in
            let wageFileToDelete = wageFiles[index]
            networkDownload.removeWageFileOnline(wageFileToDelete)
            PersistenceController.shared.removeFromCoreData(wageFileToDelete)
            wageFiles.remove(at: index)
        }
    }
    
    func sortFiles(by option: SortOptions) {
        DDLogInfo("Number of wageFiles \(wageFiles.count)")
        switch option {
        case SortOptions.dateHigh:
            wageFiles.sort(by: {$0.timeStamp > $1.timeStamp})
        case SortOptions.dateLow:
            wageFiles.sort(by: {$0.timeStamp < $1.timeStamp})
        case SortOptions.wageHigh:
            wageFiles.sort(by: {$0.wage > $1.wage})
        case SortOptions.wageLow:
            wageFiles.sort(by: {$0.wage < $1.wage})
        case SortOptions.yearsOfExperienceHigh:
            wageFiles.sort(by: {$0.yearsOfExperience > $1.yearsOfExperience})
        case SortOptions.yearsOfExperienceLow:
            wageFiles.sort(by: {$0.yearsOfExperience < $1.yearsOfExperience})
        case SortOptions.instrument:
            wageFiles.sort(by: {$0.instrument.rawValue < $1.instrument.rawValue})
        case SortOptions.artistType:
            wageFiles.sort(by: {$0.artistType.rawValue < $1.artistType.rawValue})
        case SortOptions.gigtype:
            wageFiles.sort(by: {$0.gigType.rawValue < $1.gigType.rawValue})
        case SortOptions.didStudy:
            wageFiles.sort(by: {$0.didStudy && !$1.didStudy})
        }
    }
    
    func filterResults(with options: FilterOptions) {
        self.wageFiles = filtering.filterWageFiles(wageFiles, with: options)
    }
    
    func setFilterOptions(with options: FilterOptions) {
        self.filters = options
    }
    
    func removeFilters() {
        self.filters = nil
    }
    
}
