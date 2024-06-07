//
//  CalculateDistanceExt.swift
//  couple-telecathic
//
//  Created by Alfonso Kenji Prayogo on 05/06/24.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {

    /// Calculates the distance in meters between this coordinate and another.
    ///
    /// - Parameter other: The other coordinate to calculate the distance to.
    /// - Returns: The distance in meters as a `CLLocationDistance`.
    func distance(from other: CLLocationCoordinate2D) -> CLLocationDistance {
        let firstLocation = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let secondLocation = CLLocation(latitude: other.latitude, longitude: other.longitude)
        return firstLocation.distance(from: secondLocation)
    }
}


