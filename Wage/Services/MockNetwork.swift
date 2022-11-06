//
//  MockNetwork.swift
//  Wage
//
//  Created by Patrick Rugebregt on 06/11/2022.
//

import Foundation

//
//  Network.swift
//  Wage
//
//  Created by Patrick Rugebregt on 14/02/2022.
//

import Foundation
import Firebase
import FirebaseFirestore

class MockNetworkDownload: NetworkDownloadable {
    
    @Published private var isDoneDownloading = false
    private var db = Firestore.firestore()
    
    func removeWageFileOnline(_ wageFile: WageFile) {
        db.collection("data").document("\(wageFile.id)").delete { err in
            guard err == nil else {
                print(err!)
                return
            }
            print("removed \(wageFile.timeStamp)")
        }
    }
    
    func downloadAllData() async throws -> [QueryDocumentSnapshot] {
        return []
    }
}

class MockNetworkUpload {
        
    private var db = Firestore.firestore()
    private var user: User?
    @Published private var isDoneUploading = false
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUser(_:)), name: .shareUser, object: nil)
    }
    
    @objc func updateUser(_ notification: Notification) {
        guard let user = notification.userInfo?["user"] as? User else { return }
        self.user = user
    }
    
    func upload(wageFile: WageFile) {
        db.collection("data").document("\(wageFile.id)").setData([
            "id": wageFile.id,
            "instrument": wageFile.instrument.rawValue,
            "gigType": wageFile.gigType.rawValue,
            "artistType": wageFile.artistType.rawValue,
            "yearsOfExperience": wageFile.yearsOfExperience,
            "wage": wageFile.wage,
            "didStudy": wageFile.didStudy,
            "timeStamp": wageFile.timeStamp
        ]) { error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.isDoneUploading.toggle()
        }
    }
    
    func sendSuggestion(with text: String) {
        db.collection("Suggestions").addDocument(data: [
            "instrument": user?.instrument.rawValue ?? Instrument.Anders,
            "yearsOfExperience": user?.yearsOfExperience ?? 0,
            "didStudy": user?.didStudy ?? false,
            "suggestion": text
        ])
    }
    
}


