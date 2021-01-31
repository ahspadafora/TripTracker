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
    
    // past trips table view datasource & delegate
    let tableViewDelegate = PastTripsTableViewDelegate()
    let tableViewDataSource = PastTripsTableViewDataSource()
    
    @IBOutlet weak var pastTripsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pastTripsTableView.delegate = tableViewDelegate
        pastTripsTableView.dataSource = tableViewDataSource
    }
}

class PastTripsTableViewDelegate: NSObject, UITableViewDelegate {
    // supports table editing
}

class PastTripsTableViewDataSource: NSObject, UITableViewDataSource {
    let numberOfRows = 5
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "pastTripCell", for: indexPath) as? PastTripTableViewCell else { return UITableViewCell() }
        return cell
    }
    
    
}



