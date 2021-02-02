//
//  TripTracker.swift
//  TripTracker
//
//  Created by Amber Spadafora on 1/30/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import Foundation

class TripTracker {
    
    private var locations: [Location] = []
    
    var tripIsEmpty: Bool {
        return locations.isEmpty
    }
    var pointCount: Int {
        return locations.count
    }
    
    func addPoint(location: Location) {
        locations.insert(location, at: 0)
    }
    
    func getLastPoint() -> Location? {
        return locations.last
    }
    func getFirstPoint() -> Location? {
        return locations.first
    }
    
    func getAllPoints() -> [Location] {
        return locations
    }
    
    func clearData() {
        self.locations = []
    }

}
