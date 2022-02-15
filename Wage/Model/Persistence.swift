//
//  Persistence.swift
//  Wage
//
//  Created by Patrick Rugebregt on 10/02/2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
 //   let user = User()
    let container: NSPersistentContainer
    var wageFileLoader: WageFileLoader?

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Wage")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

    }
    
    func createObject(wageFile: WageFile) {
        WageFiles.shared.appendNewFile(wageFile)
        wageFileLoader?.loadLocalFiles()
        let object = WageObject(context: container.viewContext)
        object.artistType = wageFile.artistType.rawValue
        object.gigType = wageFile.gigType.rawValue
        object.wage = Int32(wageFile.wage)
        object.idNumber = wageFile.id
        object.instrument = wageFile.instrument.rawValue
        object.didStudy = wageFile.didStudy
        object.yearsOfExperience = Int16(wageFile.yearsOfExperience)
        print(object)
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func loadAllObjects() -> [WageFile] {
        let coreDataObjects = loadFromCoreData()
        var wageFiles = [WageFile]()
        for object in coreDataObjects {
            let wageFile = WageFile(
                id: object.idNumber,
                                    wage: Int(object.wage),
                                    artistType: ArtistType(rawValue: object.artistType!)!,
                                    gigType: GigType(rawValue: object.gigType!)!,
                                    yearsOfExperience: Int(object.yearsOfExperience),
                                    didStudy: object.didStudy,
                                    instrument: Instrument(rawValue: object.instrument!)!)
            wageFiles.append(wageFile)
        }
        return wageFiles
    }
    
    func save() {
        do {
            try container.viewContext.save()
        } catch {
            print(error)
        }
    }
    
    func loadFromCoreData() -> [WageObject] {
        let request: NSFetchRequest<WageObject> = WageObject.fetchRequest()
        do {
            let result = try container.viewContext.fetch(request)
            return result
        } catch {
            print(error)
        }
        return []
    }
    
    func fetchUser() -> [UserObject] {
        let request: NSFetchRequest<UserObject> = UserObject.fetchRequest()
        do {
            let result = try container.viewContext.fetch(request)
            return result
        } catch {
            print(error)
        }
        return []
    }
    
    
    func createUserObject(_ object: User) {
        let userObject = UserObject(context: container.viewContext)
        userObject.instrument = object.instrument.rawValue
        userObject.didStudy = object.didStudy
        userObject.yearsOfExperience = Int16(object.yearsOfExperience)
        save()
    }
    
    func modifyUserObject(with user: User) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserObject")
        do {
            let objects = try container.viewContext.fetch(request)
            if let results = objects as? [NSManagedObject] {
                print("1")
                guard results.count > 0 else { return }
                print("2")
                let object = results[0]
                object.setValue(user.didStudy, forKey: "didStudy")
                object.setValue(user.yearsOfExperience, forKey: "yearsOfExperience")
                object.setValue(user.instrument.rawValue, forKey: "instrument")
                save()
            }
        } catch {
            print(error)
        }
    }
    
}
