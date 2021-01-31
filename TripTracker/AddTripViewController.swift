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
                // label optional due to AddTripVC testing
                self.timeStartedLabel?.text = self.timeStarted!
            }
        }
    }
    var currentSpeed: String? {
        didSet {
            DispatchQueue.main.async {
                // label optional due to AddTripVC testing
                self.currentSpeedLabel?.text = self.currentSpeed!
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        
        print("tripInProgress is currently \(self.tripInProgress)")
        self.tripInProgress.toggle()
        print("tripInProgress is currently \(self.tripInProgress)")
        
        
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
    
    func handleStartCallback(trip: TripTrackingProvider) {
        self.timeStarted = "\(trip.points.last!.timestamp)"
    }
    
    func startTrip(locationManager: LocationProvider = LocationManager.shared) {
        
        locationManager.startTrip(startCompletion: handleStartCallback(trip:)) { (trip) in
            self.currentSpeed = "\(trip.points.first!.speed)"
        }
//        LocationManager.shared.startTrip(startCompletion: { (trip) in
//            DispatchQueue.main.async {
//                self.timeStarted = "\(trip.points.last!.timestamp)"
//            }
//        }) { (trip) in
//            DispatchQueue.main.async {
//                if self.tripInProgress {
//                    self.currentSpeed = "\(trip.points.first!.speed)"
//                }
//            }
//        }
        
    }
    
    func endTrip(locationManager: LocationProvider) {
        
        LocationManager.shared.endTrip { (_) in
            DispatchQueue.main.async {
                self.timeStartedLabel.text = " "
                self.currentSpeedLabel.text = " "
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
