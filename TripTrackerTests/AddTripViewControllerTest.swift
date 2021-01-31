//
//  AddTripViewControllerTest.swift
//  TripTrackerTests
//
//  Created by Amber Spadafora on 1/30/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import XCTest

class MockTripTracker: TripTrackingProvider {
    var points: [Location] = []
    
    var timeStarted: Date?
    
    func addPoint(location: Location) {
        points.append(Location(latitude: 2.0, longitude: 2.0, timestamp: Date(), speed: 2.0))
    }
    
    
}

class MockLocationProvider: LocationProvider {
    
    var tripStartedCompletionBlock: TripStartedCompletionBlock?
    var speedUpdateCompletionBlock: SpeedUpdateCompletionBlock?
    
    
    let trip: TripTrackingProvider = MockTripTracker()
    
    func requestAlwaysAuthIfNeeded() {
        // will do
    }
    
    func startTrip(startCompletion: @escaping TripStartedCompletionBlock, speedUpdateCompletion: @escaping SpeedUpdateCompletionBlock) {
        
        
        //self.tripStartedCompletionBlock = startCompletion
        //self.speedUpdateCompletionBlock = speedUpdateCompletion
        
        let location = Location(latitude: 2.0, longitude: 2.0, timestamp: Date(), speed: 2.0)
        trip.addPoint(location: location)
        startCompletion(self.trip)
        speedUpdateCompletion(self.trip)
        
    }
    
    var authStatus: LocationManagerAuthStatus?
    
    
}

class AddTripViewControllerTest: XCTestCase {

    var addTripViewController = AddTripViewController()
    let mockLocationProvider = MockLocationProvider()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_startTrip_ShouldSetAValueForTimeStarted() throws {
        addTripViewController.startTrip(locationManager: mockLocationProvider)
        assert(addTripViewController.timeStarted != nil)
    }
    
    func test_startTrip_ShouldSetAValueForCurrentSpeed() throws {
        addTripViewController.startTrip(locationManager: mockLocationProvider)
        assert(addTripViewController.currentSpeed != nil)
    }

}
