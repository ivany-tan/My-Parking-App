import MapKit

struct Root: Codable {
    let features: [ParkingPlace]
}

struct ParkingPlace: Codable {
    let type: String
    let properties: Properties
    let geometry: Geometry

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

struct Geometry: Codable {
    let type: String
    let coordinates: [Double]
}

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
