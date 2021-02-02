//
//  Location.swift
//  TripTracker
//
//  Created by Amber Spadafora on 2/1/21.
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
