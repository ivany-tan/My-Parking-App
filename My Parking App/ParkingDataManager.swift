import Foundation

struct CurrentParkingSession: Codable {
    var place: ParkingPlace
    var time: Date
    var duration: Int // mins
}

struct ParkingRecord {
    // TODO:
}

class ParkingDataManager {

    static let shared: ParkingDataManager = ParkingDataManager()

    func readParkingPlaces() -> [ParkingPlace] {
        guard
           let fileName = Bundle.main.url(forResource: "Parking_meters", withExtension: "geojson"),
           let propertiesData = try? Data(contentsOf: fileName)
           else {
             return []
         }

        let properties = try! JSONDecoder().decode(Root.self, from: propertiesData)

        return properties.features
    }

    // MARK: - Current Parking(tab 2) function


    // MARK: - Record(tab 3) functions

    func saveCurrentParkingToRecord(currentParkingSession: CurrentParkingSession) {
        // TODO: Save currentParkingSession to local parking records
    }

    func readRecords() -> [ParkingRecord] {
        // TODO: Read all local parking records
        []
    }

}
