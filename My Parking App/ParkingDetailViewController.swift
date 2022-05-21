import MapKit
import UIKit

class ParkingDetailViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var parkingDurationLabel: UILabel!
    @IBOutlet var parkingDurationSlider: UISlider!

    var place: ParkingPlace!

    override func viewDidLoad() {
        super.viewDidLoad()

        firstLabel.text = place.properties.street + place.properties.suburb
        secondLabel.text = "Accept Card: \(place.properties.creditCardPaymentAccepted)"
        thirdLabel.attributedText = place.properties.popUpAttributedString

        let annotation = place.convertToAnnotation()
        mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
        mapView.addAnnotation(annotation)
    }

    @IBAction func onDurationChanged(_ sender: Any) {
        let hours = Int(parkingDurationSlider.value)
        let mins = Int((parkingDurationSlider.value * 60).truncatingRemainder(dividingBy: 60))

        parkingDurationLabel.text = "Parking Duration (\(hours)hr \(mins)min)"
    }
    @IBAction func onStartParkingTapped(_ sender: Any) {
        ParkingDataManager.shared.saveCurrentParkingSession(
            place: place,
            time: Date(),
            duration: Int(parkingDurationSlider.value * 60)
        )
        
        let alertController = UIAlertController(title: "Parking Started", message: "Your parking has already started", preferredStyle: .alert)
        
        alertController.addAction(
            .init(title: "OK", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)

                self.tabBarController?.selectedIndex = 1
            })
        )
        
        self.present(alertController, animated: true)
    }
}
