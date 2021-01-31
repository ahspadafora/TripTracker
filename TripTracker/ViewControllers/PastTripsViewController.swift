//
//  ViewController.swift
//  TripTracker
//
//  Created by Amber Spadafora on 1/29/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import UIKit

class PastTripsViewController: UIViewController {
    
    var locationManager: LocationProvider = LocationManager()
    var tripService: TripService?
    
    
    
    // past trips table view datasource & delegate
    let tableViewDelegate = PastTripsTableViewDelegate()
    let tableViewDataSource = PastTripsTableViewDataSource()
    
    @IBOutlet weak var pastTripsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableViewDataSource.tripService = self.tripService
        
        pastTripsTableView.delegate = tableViewDelegate
        pastTripsTableView.dataSource = tableViewDataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.pastTripsTableView.reloadData()
    }
    
}

class PastTripsTableViewDelegate: NSObject, UITableViewDelegate {
    // supports table editing
}

class PastTripsTableViewDataSource: NSObject, UITableViewDataSource {
    
    var trips: [Trip]? = []
    var tripService: TripService? {
        didSet {
            let tripCount = tripService?.getTrips()
            print("trip count at setting tripService is = \(tripCount?.count)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tripService?.getTrips()?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pastTripCell", for: indexPath) as? PastTripTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    
    
    
}



