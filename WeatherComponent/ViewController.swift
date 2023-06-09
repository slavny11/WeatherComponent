//
//  ViewController.swift
//  WeatherComponent
//
//  Created by Viacheslav on 30/03/23.
//

import UIKit
import CoreLocation
import WeatherKit

final class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    let weatherManager = WeatherService()

    let weatherView = WeatherView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUserLocation()
        setUpView()
    }

    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        getWeather(location: location)
    }

    func getWeather(location: CLLocation) {
        Task {
            do {
                let result = try await weatherManager.weather(for: location)
                weatherView.configure(with: result, location: location)
            } catch {
                print(String(describing: error))
            }
        }
    }

    func setUpView() {
        view.addSubview(weatherView)
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.topAnchor.constraint(equalTo: view.topAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

    }

}

