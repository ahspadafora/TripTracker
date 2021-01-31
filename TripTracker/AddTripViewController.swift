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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startStopButtonTapped(_ sender: UIButton) {
        tripInProgress.toggle()
        DispatchQueue.main.async {
            switch self.tripInProgress {
            case true:
                sender.setTitle("End Trip", for: .normal)
                self.startTrip()
            case false:
                sender.setTitle("Start Trip", for: .normal)
                self.endTrip()
            }
        }
        
    }
    
    func startTrip() {
        LocationManager.shared.startTrip(startCompletion: { (trip) in
            DispatchQueue.main.async {
                self.timeStartedLabel.text = "\(trip.points.last!.latitude)"
            }
        }) { (trip) in
            DispatchQueue.main.async {
                if self.tripInProgress {
                    self.currentSpeedLabel.text = "\(trip.points.first!.speed)"
                }
            }
        }
    }
    
    func endTrip() {
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
