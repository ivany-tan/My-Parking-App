import Foundation
import UIKit

class SearchPlaceViewController: UITableViewController, UISearchBarDelegate {

    var places: [ParkingPlace] = []
    var filteredPlaces: [ParkingPlace] = []

    let parkingDataManager = ParkingDataManager()

    var selectedPlace: ParkingPlace?

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Please enter street name or suburb"
        navigationItem.searchController = searchController

        places = ParkingDataManager().readParkingPlaces()
        filteredPlaces = places
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPlaces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath)

        let place = filteredPlaces[indexPath.row]
        cell.textLabel?.text = "\(place.properties.street), \(place.properties.suburb)"
        cell.detailTextLabel?.attributedText = place.properties.popUpAttributedString

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlace = filteredPlaces[indexPath.row]

        performSegue(withIdentifier: "showParkingDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showParkingDetail",
           let parkingDetailViewController = segue.destination as? ParkingDetailViewController {
            parkingDetailViewController.place = selectedPlace!
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchKeyword = searchBar.text?.lowercased() else {
            return
        }

        if searchKeyword.isEmpty {
            filteredPlaces = places
            tableView.reloadData()
            return
        }

        let places = places.filter { place in
            if place.properties.street.lowercased().contains(searchKeyword) ||
                place.properties.suburb.lowercased().contains(searchKeyword) {
                return true
            }

            return false
        }

        self.filteredPlaces = places
        tableView.reloadData()
    }
}
