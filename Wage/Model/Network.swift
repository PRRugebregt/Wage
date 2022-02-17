//
//  Network.swift
//  Wage
//
//  Created by Patrick Rugebregt on 14/02/2022.
//

import Foundation
import Firebase

protocol NetworkDownloadable {
    func downloadAllData(completionHandler: @escaping (_ queryDocuments: [QueryDocumentSnapshot]) -> ()) 
}

class NetworkUpload {
        
    private var db = Firestore.firestore()
    @Published private var isDoneUploading = false
    
    func upload(wageFile: WageFile) {
        db.collection("data").document("\(wageFile.id)").setData([
            "id": wageFile.id,
            "instrument": wageFile.instrument.rawValue,
            "gigType": wageFile.gigType.rawValue,
            "artistType": wageFile.artistType.rawValue,
            "yearsOfExperience": wageFile.yearsOfExperience,
            "wage": wageFile.wage,
            "didStudy": wageFile.didStudy
        ]) { error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            self.isDoneUploading.toggle()
        }
    }
    
    func sendSuggestion(with text: String) {
        let user = User()
        db.collection("Suggestions").addDocument(data: [
            "instrument": user.instrument.rawValue,
            "yearsOfExperience": user.yearsOfExperience,
            "didStudy": user.didStudy,
            "suggestion": text
        ])
    }
    
}

class NetworkDownload: NetworkDownloadable {
    
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
