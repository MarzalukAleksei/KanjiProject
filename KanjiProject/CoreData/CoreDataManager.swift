//
//  DataController.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/27.
//

import SwiftUI
import CoreData

class CoreDataManager: ObservableObject {
    static let shared = CoreDataManager()
    
    let container = NSPersistentContainer(name: "SavedData")
    let options = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]

    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                
                print("Faild to load the data ---> \(error.localizedDescription)")
                    
            }
            
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved")
        } catch {
            print("Could not sava data...")
        }
    }
    
    func add(kanji: KanjiModel, context: NSManagedObjectContext) {
        let kanjiEntity = UsersKanji(context: context)
        let data = JSONManager.methoods.encodeToJSON(kanji)
        kanjiEntity.kanji = String(data: data, encoding: .utf8)
        kanjiEntity.timeStamp = Date()
        save(context: context)
    }
    
    func add(kanji: KanjiModel, context: NSManagedObjectContext, _ object: FetchedResults<UsersKanji>) {
        if getKanjiModel(object).contains(where: { $0.body == kanji.body }) {
            return
        }
        
        let kanjiEntity = UsersKanji(context: context)
        let data = JSONManager.methoods.encodeToJSON(kanji)
        kanjiEntity.kanji = String(data: data, encoding: .utf8)
        kanjiEntity.timeStamp = Date()
        save(context: context)
        
    }
    
    private func decodeKanjiModel(coreDataString: String?) -> KanjiModel? {
        guard let coreDataString = coreDataString,
              let data = coreDataString.data(using: .utf8) else { return nil }
        let result: KanjiModel? = JSONManager.methoods.decodeToModel(data)
        return result
    }
    
    func getKanjiModel(_ object: FetchedResults<UsersKanji>) -> [KanjiModel] {
        let result = object.compactMap { decodeKanjiModel(coreDataString: $0.kanji) }
        
        return result
    }
    
//    func add(kanji: KanjiModel, context: NSManagedObjectContext) {
//        let kan = Kanji(context: context)
//        kan.body = kanji.body
//        kan.kun = kanji.kun
//        kan.on = kanji.on
//        kan.translate = kanji.translate
//        kan.level = kanji.level
//        kan.examples = kanji.examples
//        kan.number = kanji.number
//        kan.rightAnswers = kanji.rightAnwers
//        kan.wrongAnswers = kanji.wrongAnswers
//        kan.lastAnswerRight = kan.lastAnswerRight
//
//        save(context: context)
//    }
    
//    func add(dictionary: DictionaryModel, context: NSManagedObjectContext) {
//        let newDictionary = DictionaryCoreData(context: context)
//        newDictionary.body = dictionary.body
//        newDictionary.reading = dictionary.reading
//        newDictionary.translate = dictionary.translate
////        newDictionary.references = dictionary.references
//        newDictionary.examples = dictionary.examples
//        newDictionary.number = dictionary.number
//
//        save(context: context)
//    }
    
    func deleteAllUsersKanjiData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = UsersKanji.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func delete(_ kanji: KanjiModel, _ usersKanji: FetchedResults<UsersKanji>, context: NSManagedObjectContext) {
        
        if let object = usersKanji/*.filter({ kanji == CoreDataManager.shared.decodeKanjiModel(coreDataString: $0.kanji) }).first*/.first(where: { kanji == CoreDataManager.shared.decodeKanjiModel(coreDataString: $0.kanji) }) {
            context.delete(object)
        }
        
        
        do {
            try context.save()
        } catch {
            print("Delete Error")
        }
    }
    
//    func deleteAllKanjiData(context: NSManagedObjectContext) {
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Kanji.fetchRequest()
//        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//
//        do {
//            try context.execute(deleteRequest)
//            try context.save()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
}
