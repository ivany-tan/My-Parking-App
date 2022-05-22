//
//  SearchPlaceViewController.swift
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
import UIKit

// The SearchPlaceViewController aims to control and display the searching result to user.
class SearchPlaceViewController: UITableViewController, UISearchBarDelegate {
    
    // Set up a variable places to store the parking place
    var places: [ParkingPlace] = []
    
    // Set up a variable filteredPlaces to store the filtered parking place
    var filteredPlaces: [ParkingPlace] = []

    // Set up a variable parkingDataManager to store the data from ParkingDataManager
    let parkingDataManager = ParkingDataManager()
    
    // Set up a variable selectedPlace to store the data from ParkingPlace
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
    
    // Display the search bar on the page
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
