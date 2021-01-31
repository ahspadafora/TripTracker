//
//  AddTripViewControllerTest.swift
//  TripTrackerTests
//
//  Created by Amber Spadafora on 1/30/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import XCTest

class MockLocationProvider: LocationProvider {
    func startTrip(startCompletion: @escaping TripStartedCompletionBlock, speedUpdateCompletion: @escaping SpeedUpdateCompletionBlock, errorCompletion: @escaping ErrorHandlingCompletionBlock) {
        
        let location = Location(latitude: 2.0, longitude: 2.0, timestamp: Date(), speed: 2.0)
        trip.addPoint(location: location)
        
        startCompletion(self.trip)
        speedUpdateCompletion(self.trip)
        
    }
    
    var errorHandlingCompletionBlock: ErrorHandlingCompletionBlock?
    
    var error: Error?
    
    
    var tripStartedCompletionBlock: TripStartedCompletionBlock?
    var speedUpdateCompletionBlock: SpeedUpdateCompletionBlock?
    
    
    var trip: TripTracker = TripTracker()
    
    func requestAlwaysAuthIfNeeded() {}
    
    func endTrip(completion: @escaping TripEndedCompletionBlock) {
        completion(self.trip)
    }
    
    var authStatus: LocationManagerAuthStatus?
    
    
}

class AddTripViewControllerTest: XCTestCase {

    var addTripViewController: AddTripViewController?
    var mockLocationProvider: MockLocationProvider?
    
    override func setUpWithError() throws {
        addTripViewController = AddTripViewController()
        mockLocationProvider = MockLocationProvider()
        
    }

    override func tearDownWithError() throws {
        addTripViewController = nil
        mockLocationProvider = nil
    }

    func test_whenAddTripVCIsInitialized_timeStartedIsNil() throws {
        assert(addTripViewController?.timeStarted == nil)
    }
    func test_startTrip_setsAValueForTimeStarted() throws {
        assert(addTripViewController?.timeStarted == nil)
        addTripViewController?.startTrip(locationManager: mockLocationProvider!)
        assert(addTripViewController?.timeStarted != nil)
    }
    
    func test_startTrip_setsAValueForCurrentSpeed() throws {
        assert(addTripViewController?.currentSpeed == nil)
        addTripViewController?.startTrip(locationManager: mockLocationProvider!)
        assert(addTripViewController?.currentSpeed != nil)
    }
    
    func test_endTrip_shouldSetCurrentSpeedToNil() throws {
        addTripViewController?.startTrip(locationManager: mockLocationProvider!)
        assert(addTripViewController?.currentSpeed != nil)
        addTripViewController?.endTrip(locationManager: mockLocationProvider!)
        
        assert(addTripViewController?.currentSpeed == nil)
    }

}
