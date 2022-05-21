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
