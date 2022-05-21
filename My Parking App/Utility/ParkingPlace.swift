//
//  ParkingPlace.swift
//  My Parking App
//
//  Created by Unicorn Studio
//  Group member: Yujie Tan 14343103
//  Group member: Tingyu Lu 14093367
//
//  Assignment 3, for 41889 & 42889 Application Development in the IOS Environment IOS Application Development
//
//  Copyright © 2022 Unicorn Studio All rights reserved.
//

import MapKit

// Clarify a struct of root to store the features from API
struct Root: Codable {
    let features: [ParkingPlace]
}

// Clarify a struct of ParkingPlace to store the type, properties and other Geometry Information
struct ParkingPlace: Codable {
    let type: String
    let properties: Properties
    let geometry: Geometry

    // Create a function aims to store the longitude and latitude information
    func convertToAnnotation() -> MKAnnotation {
        let longitude = geometry.coordinates[0]
        let latitude = geometry.coordinates[1]

        return ParkingPlaceAnnotation(
            parkingPlace: self,
            coordinate: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
        )
    }
}

// Clarify a class of ParkingPlaceAnnotation to store the location information of the current session
class ParkingPlaceAnnotation: NSObject, MKAnnotation {
    let parkingPlace: ParkingPlace
    let coordinate: CLLocationCoordinate2D

    init(
        parkingPlace: ParkingPlace,
        coordinate: CLLocationCoordinate2D
    ) {
        self.parkingPlace = parkingPlace
        self.coordinate = coordinate

        super.init()
    }
}

// Clarify a struct of Gemoetry to store the relevant data
struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

// Clarify a struct of Properties to store the relevant data
struct Properties: Codable {
    let objectid, meterID: Int
    let locationID: String
    let statusID: Int
    let coinPaymentAccepted, phonePaymentAccepted, creditCardPaymentAccepted, street: String
    let suburb: String
    let approxPaySpaces: Int
    let popup: String

    /// https://www.hackingwithswift.com/example-code/system/how-to-convert-html-to-an-nsattributedstring
    var popUpAttributedString: NSAttributedString? {
        let modifiedFont = String(format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(18)\">%@</span>", popup)

        return try? NSAttributedString(
            data: Data(modifiedFont.utf8),
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }

    enum CodingKeys: String, CodingKey {
        case objectid = "OBJECTID"
        case meterID = "Meter_ID"
        case locationID = "Location_ID"
        case statusID = "Status_ID"
        case coinPaymentAccepted = "CoinPaymentAccepted"
        case phonePaymentAccepted = "PhonePaymentAccepted"
        case creditCardPaymentAccepted = "CreditCardPaymentAccepted"
        case street = "Street"
        case suburb = "Suburb"
        case approxPaySpaces = "ApproxPaySpaces"
        case popup = "Popup"
    }
}
