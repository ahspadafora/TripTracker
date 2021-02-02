//
//  TripTrackerTests.swift
//  TripTrackerTests
//
//  Created by Amber Spadafora on 2/1/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import XCTest

class TripTrackerTests: XCTestCase {
    let tripTracker = TripTracker()
    let location = Location(latitude: 2.0, longitude: 2.0, timestamp: Date(), speed: 2.0)
    let loc2 = Location(latitude: 5.0, longitude: 2.3, timestamp: Date(), speed: 1.0)
    let loc3 = Location(latitude: 5.3, longitude: 2.5, timestamp: Date(), speed: 1.5)
    
    override func setUpWithError() throws {
        tripTracker.addPoint(location: location)
        tripTracker.addPoint(location: loc2)
        tripTracker.addPoint(location: loc3)
    }

    func testTripTrackerHasThreePoints() {
        assert(tripTracker.pointCount == 3)
    }
    
    func test_tripTracker_tripIsEmpty_afterClearDataIsCalled() {
        assert(tripTracker.tripIsEmpty == false)
        tripTracker.clearData()
        assert(tripTracker.tripIsEmpty)
    }
    
    func test_tripTracker_firstPointIndexIsEqualToLastPointAdded() {
        assert(tripTracker.getFirstPoint() == loc3)
    }

}
