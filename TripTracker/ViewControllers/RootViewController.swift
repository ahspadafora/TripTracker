//
//  RootViewController.swift
//  TripTracker
//
//  Created by Amber Spadafora on 1/31/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import UIKit

class RootViewController: UITabBarController {
    let coreDataStack = CoreDataStack()
    var tripService: TripService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tripService = TripService(coreDataStack: self.coreDataStack, managedObjectContext: coreDataStack.mainContext)
        
        for child in self.children {
            if let addTripVC = child as? AddTripViewController {
                addTripVC.tripService = self.tripService
            }
            if let pastTripsVC = child as? PastTripsViewController {
                pastTripsVC.tripService = self.tripService
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
