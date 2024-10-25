//
//  LocationService.swift
//  CarlApp
//
//  Created by Felicia Alamorean on 25.10.2024.
//

import UIKit
import CoreLocation
import FirebaseFirestore
import FirebaseAuth

class LocationService: NSObject {
    private let locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    private let db = Firestore.firestore()
    private let userID: String
    private var timer: Timer?

    init(userID: String) {
        self.userID = userID
        super.init()
        configureLocationManager()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        startLocationUpdateTimer()
    }

    private func startLocationUpdateTimer() {
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(updateLocationIfChanged), userInfo: nil, repeats: true)
    }

    @objc private func updateLocationIfChanged() {
        guard let currentLocation = locationManager.location else { return }
        print("Current Location: \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")

        if let lastLocation = lastLocation {
            let distance = currentLocation.distance(from: lastLocation)
            if distance > 10 {
                saveLocationToFirebase(currentLocation)
                self.lastLocation = currentLocation
            }
        } else {
            saveLocationToFirebase(currentLocation)
            lastLocation = currentLocation
        }
    }

    private func saveLocationToFirebase(_ location: CLLocation) {
        guard let userID = Auth.auth().currentUser?.uid else { return }

        let locationData: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]

        db.collection("users").document(userID).setData(["location": locationData], merge: true) { error in
            if let error = error {
                print("Error updating location in Firebase: \(error)")
            } else {
                print("Location updated successfully in Firebase: \(locationData)")
            }
        }
    }

    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
    }
}

extension LocationService: CLLocationManagerDelegate {
    
}
