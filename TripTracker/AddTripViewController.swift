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
    }
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        self.tripInProgress.toggle()
        
        DispatchQueue.main.async {
            switch self.tripInProgress {
            case true:
                sender.setTitle("End Trip", for: .normal)
                self.startTrip()
            case false:
                sender.setTitle("Start Trip", for: .normal)
                self.endTrip(locationManager: LocationManager.shared)
            }
        }
        
    }
    
    fileprivate func handleStartTripCallback(trip: TripTracker) {
        self.timeStarted = "\(trip.getLastPoint()!.timestamp)"
    }
    fileprivate func handleSpeedCallback(trip: TripTracker) {
        self.currentSpeed = "\(trip.getFirstPoint()!.speed)"
    }
    fileprivate func handleEndTripCallback(trip: TripTracker) {
        
    }
    
    func startTrip(locationManager: LocationProvider = LocationManager.shared) {
        locationManager.startTrip(startCompletion: handleStartTripCallback(trip:), speedUpdateCompletion: handleSpeedCallback(trip:), errorCompletion: { (trip, error) in
            print(error.localizedDescription)
            // present notification letting user know they need to check their location settings
        })
        
    }
    
    func endTrip(locationManager: LocationProvider = LocationManager.shared) {
        locationManager.endTrip { (_) in
           self.timeStarted = nil
           self.currentSpeed = nil
        }
    }

}
