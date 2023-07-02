//
//  DataController.swift
//  KanjiProject
//
//  Created by ブラック狼 on 2023/06/27.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "SavedData")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Faild to load the data ---> \(error.localizedDescription)")
            }
            
        }
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
        
        save(context: context)
    }
    
    func addUserKanji(kanji: KanjiModel, context: NSManagedObjectContext) {
        let newKanji = Kanji(context: context)
        newKanji.body = kanji.body
        newKanji.kun = kanji.kun
        newKanji.on = kanji.on
        
        save(context: context)
    }
    
    func deleteAllKanjiData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Kanji.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}