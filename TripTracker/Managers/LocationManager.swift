//
//  LocationService.swift
//  TripTracker
//
//  Created by Amber Spadafora on 1/30/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import Foundation
import CoreLocation


struct Location: Equatable {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var speed: Double
}

extension Location {
    init(CLLocation: CLLocation) {
        self.latitude = CLLocation.coordinate.latitude
        self.longitude = CLLocation.coordinate.longitude
        self.timestamp = CLLocation.timestamp
        self.speed = CLLocation.speed
    }
}

typealias TripStartedCompletionBlock = (TripTracker) -> Void
typealias TripEndedCompletionBlock = (TripTracker) -> Void
typealias SpeedUpdateCompletionBlock = (TripTracker) -> Void
typealias ErrorHandlingCompletionBlock = (TripTracker, Error) -> Void

protocol LocationProvider {
    
    func requestAlwaysAuthIfNeeded()
    
    func startTrip(startCompletion: @escaping TripStartedCompletionBlock, speedUpdateCompletion: @escaping SpeedUpdateCompletionBlock, errorCompletion: @escaping ErrorHandlingCompletionBlock)
    func endTrip(completion: @escaping TripEndedCompletionBlock)
    
    var authStatus: LocationManagerAuthStatus? { get set }
    
    var tripStartedCompletionBlock: TripStartedCompletionBlock? { get set }
    var speedUpdateCompletionBlock: SpeedUpdateCompletionBlock? { get set }
    var errorHandlingCompletionBlock: ErrorHandlingCompletionBlock? { get set }
    var error: Error? { get set }
}

enum LocationManagerAuthStatus {
    case notDetermined
    case restricted
    case denied
    case authorizedAlways
    case authorizedWhenInUse
}


// responsible for requesting authorization & users location
class LocationManager: NSObject, LocationProvider {
    
    static let shared = LocationManager()
    
    let tripTracker: TripTracker = TripTracker()
    var authStatus: LocationManagerAuthStatus? {
        didSet {
            self.didRequestAuthorization = true
        }
    }
    var error: Error?
    
    private lazy var coreLocationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.activityType = .fitness
        
        locationManager.desiredAccuracy = .greatestFiniteMagnitude
        return locationManager
    }()
    
    var didRequestAuthorization = false
    
    func requestAlwaysAuthIfNeeded() {
        // get coreLocation authorization status
        let clauthStatus = CLLocationManager.authorizationStatus()
        
        // convert to our LocationManagerAuthStatus
        if clauthStatus == .notDetermined {
            self.authStatus = .notDetermined
            self.coreLocationManager.requestAlwaysAuthorization()
            return
        }
        if clauthStatus == .authorizedWhenInUse {
            self.authStatus = .authorizedWhenInUse
            return
        }
        if clauthStatus == .authorizedAlways {
            self.authStatus = .authorizedAlways
            return
        }
        self.authStatus = .denied
        
    }
    
    var tripStartedCompletionBlock: TripStartedCompletionBlock?
    var speedUpdateCompletionBlock: SpeedUpdateCompletionBlock?
    var errorHandlingCompletionBlock: ErrorHandlingCompletionBlock?
    
    // starts location updating, sends back info to update UI using completion handlers
    func startTrip(startCompletion: @escaping TripStartedCompletionBlock, speedUpdateCompletion: @escaping SpeedUpdateCompletionBlock, errorCompletion: @escaping ErrorHandlingCompletionBlock) {

        coreLocationManager.startUpdatingLocation()

        self.tripStartedCompletionBlock = startCompletion
        self.speedUpdateCompletionBlock = speedUpdateCompletion
        self.errorHandlingCompletionBlock = errorCompletion

    }

    // ends location updating
    func endTrip(completion: @escaping TripEndedCompletionBlock) {
        coreLocationManager.stopUpdatingLocation()
        completion(self.tripTracker)
        self.tripTracker.clearData()
    }
    
    
    
}

extension LocationManager: CLLocationManagerDelegate {
    
    // if authorized, location manager should begin location update
    // if not authorized, TODO: handle
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse:
            self.authStatus = .authorizedWhenInUse
        case .authorizedAlways:
            self.authStatus = .authorizedAlways
        default:
            self.authStatus = .denied
        }
    }

    // called when location manager fails at retrieving users location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error = error
        self.errorHandlingCompletionBlock?(self.tripTracker, error)
    }
    
    // called each time the location manager gets a location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        tripTracker.addPoint(location: Location(CLLocation: location))
        let tripIsJustStarting = self.tripTracker.pointCount == 1
        
        if tripIsJustStarting {
            self.tripStartedCompletionBlock?(self.tripTracker)
        }
        
        self.speedUpdateCompletionBlock?(self.tripTracker)
    }
    
}

