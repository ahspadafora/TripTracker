//
//  LocationService.swift
//  TripTracker
//
//  Created by Amber Spadafora on 1/30/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import Foundation
import CoreLocation


struct Location {
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

protocol LocationProvider {
    
    func requestAlwaysAuthIfNeeded()
    func startTrip(startCompletion: @escaping TripStartedCompletionBlock, speedUpdateCompletion: @escaping SpeedUpdateCompletionBlock)
    
    var authStatus: LocationManagerAuthStatus? { get set }
    
    var tripStartedCompletionBlock: TripStartedCompletionBlock? { get set }
    var speedUpdateCompletionBlock: SpeedUpdateCompletionBlock? { get set }
    
}

enum LocationManagerAuthStatus {
    case notDetermined
    case restricted
    case denied
    case authorizedAlways
    case authorizedWhenInUse
}

typealias TripStartedCompletionBlock = (TripTrackingProvider) -> Void
typealias TripEndedCompletionBlock = (TripTrackingProvider) -> Void
typealias SpeedUpdateCompletionBlock = (TripTrackingProvider) -> Void

// responsible for requesting authorization & users location
class LocationManager: NSObject, LocationProvider {
    
    static let shared = LocationManager()
    
    var authStatus: LocationManagerAuthStatus? {
        didSet {
            self.didRequestAuthorization = true
        }
    }
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        
        locationManager.delegate = self
        locationManager.activityType = .fitness
        
        locationManager.desiredAccuracy = .greatestFiniteMagnitude
        return locationManager
    }()
    
    var didRequestAuthorization = false
    
    func requestAlwaysAuthIfNeeded() {
        //get cl auth status
        let clauthStatus = CLLocationManager.authorizationStatus()
        if clauthStatus == .notDetermined {
            self.authStatus = .notDetermined
            self.locationManager.requestAlwaysAuthorization()
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
    
    func startTrip(startCompletion: @escaping TripStartedCompletionBlock, speedUpdateCompletion: @escaping SpeedUpdateCompletionBlock) {

        locationManager.startUpdatingLocation()

        self.tripStartedCompletionBlock = startCompletion
        self.speedUpdateCompletionBlock = speedUpdateCompletion

    }

    func endTrip(completion: @escaping (TripTrackingProvider) -> Void) {
        locationManager.stopUpdatingLocation()

        self.tripTracker.points = []
        self.tripTracker.timeStarted = nil
        completion(self.tripTracker)
    }
    
    var tripTracker: TripTrackingProvider = TripTracker()
    
}

extension LocationManager: CLLocationManagerDelegate {
    // called when location manager gets authorization change
    // if authorized, location manager should begin location update (depending on whether the setting for automatic trip tracking is on)
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
        
    }
    
    // called each time the location manager gets a location update
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // TODO: Create coredata object from location updates
        
        guard let location = locations.first else { return }
        tripTracker.addPoint(location: Location(CLLocation: location))
        if tripTracker.points.count == 1 {
            tripTracker.timeStarted = location.timestamp
            self.tripStartedCompletionBlock?(self.tripTracker)
        }
        
        self.speedUpdateCompletionBlock?(self.tripTracker)
    }
    
}

protocol TripTrackingProvider {
    var points: [Location] { get set }
    var timeStarted: Date? { get set }
    
    func addPoint(location: Location)
}

class TripTracker: TripTrackingProvider {
    
    var points: [Location] = []
    var timeStarted: Date? = nil
    
    func addPoint(location: Location) {
        points.insert(location, at: 0)
    }

}
