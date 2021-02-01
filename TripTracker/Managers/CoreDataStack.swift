//
//  CoreDataStack.swift
//  TripTracker
//
//  Created by Amber Spadafora on 1/31/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    public static let modelName = "TripTracker"
    static let model: NSManagedObjectModel = {
        guard let modelURL = Bundle.main.url(forResource: modelName, withExtension: "momd") else {
            return NSManagedObjectModel()
        }
        return NSManagedObjectModel(contentsOf: modelURL) ?? NSManagedObjectModel()
    }()
    
    init(){}
    
    public lazy var mainContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataStack.modelName, managedObjectModel: CoreDataStack.model)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
        return container
    }()
    
//    // for Unit Testing
//    func newDerivedContext() -> NSManagedObjectContext {
//        let context = storeContainer.newBackgroundContext()
//        return context
//    }
    
    func saveContext(context: NSManagedObjectContext){
        context.perform {
            do {
                try context.save()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
}
