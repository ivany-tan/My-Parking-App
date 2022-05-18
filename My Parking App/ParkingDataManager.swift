//
//  ParkingDataManager.swift
//  My Parking App
//
//  Created by Ivan Tan on 16/5/2022.
//


import Foundation

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

    /// Call when press start parking
    func saveCurrentParkingSession(place: ParkingPlace, time: Date, duration: Int) {
        // TODO: Save current selected parking place to local
    }

    /// Call when user select current parking tab(viewWillAppear)
    func readCurrentParkingSession() -> CurrentParkingSession? {
        // TODO: Read current parking session if exists
        nil
    }

    func deleteCurrentParkingSession() {
        // TODO: Delete/Clear current parking session from local
    }

    // MARK: - Record(tab 3) functions

    func saveCurrentParkingToRecord(currentParkingSession: CurrentParkingSession) {
        // TODO: Save currentParkingSession to local parking records
    }

    func readRecords() -> [ParkingRecord] {
        // TODO: Read all local parking records
        []
    }

}

struct CurrentParkingSession {
    // TODO:
}

struct ParkingRecord {
    // TODO:
}
