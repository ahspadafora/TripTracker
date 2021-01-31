//
//  TripTracker.swift
//  TripTracker
//
//  Created by Amber Spadafora on 1/30/21.
//  Copyright © 2021 Amber Spadafora. All rights reserved.
//

import Foundation

class TripTracker {
    
    private var points: [Location] = []
    
    var tripIsEmpty: Bool {
        return points.isEmpty
    }
    var pointCount: Int {
        return points.count
    }
    
    func addPoint(location: Location) {
        points.insert(location, at: 0)
    }
    
    func getLastPoint() -> Location? {
        return points.last
    }
    func getFirstPoint() -> Location? {
        return points.first
    }
    
    func getAllPoints() -> [Location] {
        return points
    }
    
    func clearData() {
        self.points = []
    }

}
