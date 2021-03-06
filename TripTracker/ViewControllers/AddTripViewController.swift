//
//  AddTripViewController.swift
//  TripTracker
//
//  Created by Amber Spadafora on 1/29/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import UIKit

// TO DO: Add LocationManagerDelegate


class AddTripViewController: UIViewController {
    
    var tripService: TripService?
    let coreDataStack = CoreDataStack()
    
    @IBOutlet weak var startStopButton: UIButton!
    
    @IBOutlet weak var timeStartedLabel: UILabel!
    @IBOutlet weak var currentSpeedLabel: UILabel!
    
    var tripInProgress = false
    
    var timeStarted: String? {
        didSet {
            DispatchQueue.main.async {
                guard let timeStarted = self.timeStarted else {
                    self.timeStartedLabel?.text = ""
                    return
                }
                self.timeStartedLabel?.text = timeStarted
            }
        }
    }
    
    var currentSpeed: String? {
        didSet {
            DispatchQueue.main.async {
                guard let currentSpeed = self.currentSpeed else {
                    self.currentSpeedLabel?.text = ""
                    return
                }
                self.currentSpeedLabel?.text = currentSpeed
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tripService = TripService(coreDataStack: self.coreDataStack, managedObjectContext: coreDataStack.mainContext)
        LocationManager.shared.requestAlwaysAuthIfNeeded(callback: { authStatus in
            guard let authStatus = authStatus else { fatalError("requestAlwaysAuth should return a non-nil authStatus") }
            if authStatus == .denied {
                let alert = UIAlertController(title: "Location settings are turned off", message: "Please update your settings", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                self.present(alert, animated: false)
            }
        })
    }
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        self.tripInProgress.toggle()
        
        DispatchQueue.main.async {
            switch self.tripInProgress {
            case true:
                sender.setTitle("End Trip", for: .normal)
                self.startTrip(locationManager: LocationManager.shared)
            case false:
                sender.setTitle("Start Trip", for: .normal)
                self.endTrip(locationManager: LocationManager.shared)
            }
        }
        
    }
    
//    fileprivate func startTripCallback(tripTracker: TripTracker) {
//        self.timeStarted = "\(tripTracker.getLastPoint()!.timestamp)"
//    }
    fileprivate func speedCallback(tripTracker: TripTracker) {
        self.currentSpeed = "\(tripTracker.getFirstPoint()!.speed)"
    }
    fileprivate func endTripCallback(tripTracker: TripTracker) {
        self.timeStarted = nil
        self.currentSpeed = nil
        if tripTracker.pointCount != 0 {
            self.tripService?.addTrip(tripTracker: tripTracker)
            _ = self.tripService?.getTrips()
        }
        
    }
    
    func startTrip(locationManager: LocationManager = LocationManager.shared) {
        
        locationManager.startTrip(startCompletion: { tripTracker in
            self.timeStarted = "\(tripTracker.getLastPoint()!.timestamp)"
            
        }, speedUpdateCompletion: speedCallback(tripTracker:), errorCompletion: { (trip, error) in
            print(error.localizedDescription)
            // present notification letting user know they need to check their location settings
        })
        
    }
    
    func endTrip(locationManager: LocationManager = LocationManager.shared) {
        locationManager.endTrip(completion: endTripCallback(tripTracker:))
    }
    
}
