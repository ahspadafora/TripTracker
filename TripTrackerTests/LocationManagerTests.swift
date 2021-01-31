//
//  LocationManagerTests.swift
//  TripTrackerTests
//
//  Created by Amber Spadafora on 1/30/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import XCTest

class LocationManagerTests: XCTestCase {

    var locationManager: LocationManager? = LocationManager()
    
    override func setUpWithError() throws {
        locationManager = LocationManager()
    }

    override func tearDownWithError() throws {
        locationManager = nil
    }
    
    func test_didRequestAuthIsTrue_whenauthStatusHasAValue() throws {
        locationManager?.authStatus = .notDetermined
        assert((locationManager!.didRequestAuthorization))
    }
    
    func test_whenAuthStatusIsNil_didRequestAuthIsFalse() throws {
         
        assert(locationManager?.authStatus == nil && locationManager?.didRequestAuthorization == false)
    }
    
    func test_startTrip_Completion_shouldReturnTripWithPoints() throws {
        locationManager?.startTrip(startCompletion: { (trip) in
            assert(trip.tripIsEmpty == false)
        }, speedUpdateCompletion: { _ in }) {_,_  in}
    }

    func testEndTrip_EndTrip_shouldReturnTripWithEmptyPoints() throws {
        locationManager?.endTrip { (trip) in
            assert(trip.tripIsEmpty)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
