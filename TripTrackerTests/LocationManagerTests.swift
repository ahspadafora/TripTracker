//
//  LocationManagerTests.swift
//  TripTrackerTests
//
//  Created by Amber Spadafora on 1/30/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import XCTest

class LocationManagerTests: XCTestCase {

    var locationManager = LocationManager()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        locationManager = LocationManager()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testDidRequestAuthwhenAuthStatusIsNotDetermined() throws {
        locationManager.authStatus = .notDetermined
        assert(locationManager.didRequestAuthorization)
        try tearDownWithError()
    }
    
    func testDidNotRequestAuthWhenAuthStatusIsNil() throws {
         
        assert(locationManager.authStatus == nil && locationManager.didRequestAuthorization == false)
    }
    
    func testStartTrip_startCompletionReturnsTripWithPointsLogged() throws {
        locationManager.startTrip(startCompletion: { (trip) in
            assert(trip.points.isEmpty == false)
        }) {_ in}
    }

    func testEndTrip_EndCompletionReturnsTripWithEmptyPointsArray() throws {
        locationManager.endTrip { (trip) in
            assert(trip.points.isEmpty)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
