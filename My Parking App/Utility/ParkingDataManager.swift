//
//  ParkingDataManager.swift
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

import Foundation

// Clarify a struct of CurrentParkigSession to store the relevant data
struct CurrentParkingSession: Codable {
    var place: ParkingPlace
    var time: Date
    var duration: Int // mins
}

// Clarify a struct of ParkingRecord to store the relevant data
struct ParkingRecord {
    // TODO:
}

// Clarify a class of ParkingDataManager.
// This class aims to store the current session and store data extracting from the API into local.
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
        ///
        /// https://cocoacasts.com/ud-5-how-to-store-a-custom-object-in-user-defaults-in-swift
        func saveCurrentParkingSession(place: ParkingPlace, time: Date, duration: Int) {
            let session = CurrentParkingSession(place: place, time: time, duration: duration)

            do {
                let data = try JSONEncoder().encode(session)

                UserDefaults.standard.set(data, forKey: "currentParkingSession")
            } catch {
                print("Unable to Encode Parking Session (\(error))")
            }
        }

        /// Call when user select current parking tab(viewWillAppear)
        func readCurrentParkingSession() -> CurrentParkingSession? {
            // Read/Get Data
            if let data = UserDefaults.standard.data(forKey: "currentParkingSession") {
                do {
                    let currentParkingSession = try JSONDecoder().decode(CurrentParkingSession.self, from: data)

                    return currentParkingSession
                } catch {
                    print("Unable to Decode Parking Session (\(error))")

                    return nil
                }
            }

            return nil
        }

        func deleteCurrentParkingSession() {
            UserDefaults.standard.set(nil, forKey: "currentParkingSession")
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
