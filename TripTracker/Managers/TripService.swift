//
//  TripService.swift
//  TripTracker
//
//  Created by Amber Spadafora on 1/31/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import Foundation
import CoreData

// handles all C.R.U.D operations for Trips in CoreData
final class TripService: NSObject {
    
    let managedObjectContext: NSManagedObjectContext
    let coreDataStack: CoreDataStack
    var fetchedResultsController: NSFetchedResultsController<Trip>?
    
    init(coreDataStack: CoreDataStack,managedObjectContext: NSManagedObjectContext) {
        
        let tripFetchRequest = NSFetchRequest<Trip>(entityName: "Trip")
        tripFetchRequest.sortDescriptors = []
        
        self.managedObjectContext = managedObjectContext
        self.coreDataStack = coreDataStack
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: tripFetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func addTrip(tripTracker: TripTracker){
        let trip = Trip(context: managedObjectContext)
        
        let tripPoints = tripTracker.getAllPoints()
                var points: Set<Point> = []
                for pt in tripPoints {
                    let point = Point(context: self.managedObjectContext)
                    point.latitude = pt.latitude
                    point.longitude = pt.longitude
                    points.insert(point)
                }
        // adds points to trip coredata object
        trip.addToPoints(points as NSSet)
        
        coreDataStack.saveContext(context: managedObjectContext)
        
        
    }
    
    func getTrips() -> [Trip]? {
        do {
            try self.fetchedResultsController?.performFetch()
            return self.fetchedResultsController?.fetchedObjects
        }
        catch {
            print("Fetching error: \(error.localizedDescription)")
        }
        return nil
    }
    
    func update(){}
    func delete(){}
    
    
}
