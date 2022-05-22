//
//  CurrentParkingViewController.swift
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

import UIKit
import MapKit

// The CurrentParkingViewController aims to control and display the current parking page to user.
class CurrentParkingViewController: UIViewController {
    
    // Clarify a variable parkingDataManager to obtain the
    // data from the class of ParkingDataManager
    let parkingDataManager = ParkingDataManager()
    
    // Clarify of UI Labels including map views adn content Stack View
    @IBOutlet var centerLabel: UILabel!
    @IBOutlet var endCurrentParkingButton: UIButton!
    @IBOutlet var firstLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var contentStackView: UIStackView!
    
    // Set up a variable timer for timer function
    var timer: Timer?
    
    // Set up a variable sesssion for the logical test
    var session: CurrentParkingSession?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        session = parkingDataManager.readCurrentParkingSession()

        setUp()
    }
    
    // The setUp function aims to store the session information
    // It also does the boolean test whether there is a existing session or not
    func setUp() {
        if session == nil {
            centerLabel.isHidden = false
            endCurrentParkingButton.isHidden = true
            contentStackView.isHidden = true
            mapView.isHidden = true
        } else {
            centerLabel.isHidden = true
            endCurrentParkingButton.isHidden = false
            contentStackView.isHidden = false
            mapView.isHidden = false
        }
        if session != nil {

            if let annotation = session?.place.convertToAnnotation() {
                mapView.setRegion(MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200), animated: true)
                mapView.addAnnotation(annotation)
            }

            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
    }
    
    // Disappear the timer when the session is ended
    @objc func fireTimer() {
        guard let session = session else {
            return
        }

        firstLabel.text = "\(session.place.properties.street), \(session.place.properties.suburb)"

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"

        secondLabel.text = "Parking start time: \(dateFormatter.string(from: session.time))"

        /// time now - (time start + duration)
        
        let duration = session.duration // mins
        let interval = Date().timeIntervalSince(session.time)
        let timeLeft = (duration * 60) - Int(interval)

        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(timeLeft)

        thirdLabel.text = "Time Left: \(hours) hours, \(minutes) mins, \(seconds) seconds"
    }

    /// https://stackoverflow.com/questions/26794703/swift-integer-conversion-to-hours-minutes-seconds
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    // The button for ending the parking session
    @IBAction func onEndParkingTapped(_ sender: Any) {
        parkingDataManager.deleteCurrentParkingSession()
        session = nil
        setUp()
        timer = nil
        timer?.invalidate()
    }

}
