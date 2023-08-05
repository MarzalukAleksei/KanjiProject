//
//  DataController.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/27.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    static let shared = DataController()
    
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
        let kan = Kanji(context: context)
        kan.body = kanji.body
        kan.kun = kanji.kun
        kan.on = kanji.on
        kan.translate = kanji.translate
        kan.level = kanji.level
        kan.examples = kanji.examples
        kan.number = kanji.number
        kan.rightAnswers = kanji.rightAnwers
        kan.wrongAnswers = kanji.wrongAnswers
        
        save(context: context)
    }
    
    func add(dictionary: DictionaryModel, context: NSManagedObjectContext) {
        let newDictionary = DictionaryCoreData(context: context)
        newDictionary.body = dictionary.body
        newDictionary.reading = dictionary.reading
        newDictionary.translate = dictionary.translate
//        newDictionary.references = dictionary.references
        newDictionary.examples = dictionary.examples
        newDictionary.number = dictionary.number

        save(context: context)
    }
    
    func deleteAllDictionaryData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = DictionaryCoreData.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAllKanjiData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Kanji.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
