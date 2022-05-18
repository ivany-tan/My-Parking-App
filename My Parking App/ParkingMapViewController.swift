//
//  ParkingMapViewController.swift
//  My Parking App
//
//  Created by Ivan Tan on 16/5/2022.
//


import UIKit
import MapKit

class ParkingMapViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var searchTextField: UITextField!
    var selectedPlace: ParkingPlace?

    let parkingDataManager = ParkingDataManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpMapView()

        searchTextField.delegate = self
        searchTextField.rightViewMode = .always
        // placeholder view for the search button
        searchTextField.rightView = UIView(frame: .init(x: 0, y: 0, width: 40, height: 20))
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = searchTextField.text else {
            return true
        }

        searchAndLocate(placeKeyword: keyword)

        return true
    }

    @IBAction func onSearchTapped(_ sender: Any) {
        guard let keyword = searchTextField.text else {
            return
        }

        /// surrey hills station
        searchAndLocate(placeKeyword: keyword)
    }

    func searchAndLocate(placeKeyword: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = placeKeyword

        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard
                let response = response,
                let firstResult = response.mapItems.first else {
                return
            }

            self.mapView.setRegion(
                .init(center: firstResult.placemark.coordinate, latitudinalMeters: 200, longitudinalMeters: 200),
                animated: true
            )
        }
    }

    func setUpMapView() {
        let initialLocation = CLLocation(latitude: -33.8679073, longitude: 151.1887139)
        let coordinateRegion = MKCoordinateRegion(
            center: initialLocation.coordinate,
              latitudinalMeters: 10000,
              longitudinalMeters: 10000)
        mapView.setRegion(coordinateRegion, animated: true)

        let annotations = parkingDataManager.readParkingPlaces().map { place in
            place.convertToAnnotation()
        }
        mapView.addAnnotations(annotations)

        mapView.delegate = self
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let view = view.annotation as? ParkingPlaceAnnotation

        self.selectedPlace = view?.parkingPlace
        performSegue(withIdentifier: "showParkingDetail", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showParkingDetail",
           let parkingDetailViewController = segue.destination as? ParkingDetailViewController {
            parkingDetailViewController.place = selectedPlace!
        }
    }
}
