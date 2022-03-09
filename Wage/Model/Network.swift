//
//  Network.swift
//  Wage
//
//  Created by Patrick Rugebregt on 14/02/2022.
//

import Foundation
import Firebase
import FirebaseFirestore

protocol NetworkDownloadable {
    func downloadAllData(completionHandler: @escaping (_ queryDocuments: [QueryDocumentSnapshot]) -> ())
    func removeWageFileOnline(_ wageFile: WageFile)
}

class NetworkUpload {
        
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

class NetworkDownload: NetworkDownloadable {

    func removeWageFileOnline(_ wageFile: WageFile) {
        db.collection("data").document("\(wageFile.id)").delete { err in
            guard err == nil else {
                print(err!)
                return
            }
            print("removed \(wageFile.timeStamp)")
        }
    }
    
    private var db = Firestore.firestore()
    @Published private var isDoneDownloading = false
    
    func downloadAllData(completionHandler: @escaping (_ queryDocuments: [QueryDocumentSnapshot]) -> ()) {
        db.collection("data").getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            guard let documents = snapshot?.documents else { return }
            completionHandler(documents)
        }
    }
    
}
