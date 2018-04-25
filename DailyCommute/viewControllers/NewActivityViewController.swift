//
//  NewActivityViewController.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/23/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class NewActivityViewController: UIViewController {
    
    enum TrackingState {
        case started
        case stopped
        case none
    }
    
    // MARK: IBOutlets
    
    @IBOutlet private  weak var timeLabel: UILabel?
    @IBOutlet private weak var distanceLabel: UILabel?
    @IBOutlet private weak var startButton: UIButton?
    @IBOutlet private weak var stopButton: UIButton?
    @IBOutlet private weak var closeButton: UIButton?
    
    // MARK: Variables
    
    private var activity: Activity?
    private let locationService = LocationService.shared
    private var seconds = 0
    private var timer: Timer?
    private var distance = Measurement(value: 0, unit: UnitLength.meters)
    private var locationList: [CLLocation] = []
    private var state: TrackingState = .none {
        didSet {
            self.updateButtonsForState()
        }
    }
    
    // MARK: UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.state = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
    }
}

// MARK: IBActions

private extension NewActivityViewController {
    
    @IBAction func startActivity(_ sender: UIButton) {
        self.startTracking()
    }
    
    @IBAction func stopActivity(_ sender: UIButton) {
        self.stopTracking()
    }
    
    
    @IBAction func closeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Activity Tracking

extension NewActivityViewController {
    
    func startTracking() {
        self.state = .started
        self.seconds = 0
        self.distance = Measurement(value: 0, unit: UnitLength.meters)
        self.locationList.removeAll()
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.updateSecondsCount()
        }
        self.startLocationUpdates()
    }
    
    func startLocationUpdates() {
        self.locationService.delegate = self
        self.locationService.activityType = .fitness
        self.locationService.distanceFilter = 10
        self.locationService.startUpdatingLocation()
    }
    
    private func stopTracking() {
        self.state = .stopped
        self.timer?.invalidate()
        self.locationService.stopUpdatingLocation()
        
        let alertController = UIAlertController(title: "End Commute?", message: "Have you reached your destination?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            background {
                self.saveCommute()
                main {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        })
        alertController.addAction(UIAlertAction(title: "Discard", style: .destructive) { _ in
            
            self.dismiss(animated: true, completion: nil)
        })
        
        present(alertController, animated: true)
    }
    
    func updateSecondsCount() {
        self.seconds += 1
        self.updateLabels()
    }
    
}

// MARK: Saving

extension NewActivityViewController {
    
    func saveCommute() {
        let date = Date()
        let dateString = "\(date)"
        let params: [String: Any] = [
            "name": "Daily Commute",
            "type": ActivityType.ride.rawValue,
            "start_date_local": "\(NewActivityViewController.iso8601.date(from: dateString) ?? date)",
            "elapsed_time": Int16(seconds),
            "distance": "\(self.distance.value)",
            "commute": 1
        ]                    

        try? StravaService.shared.request(Router.createActivity(params: params), result: { [weak self] (activity: Activity?) in
            guard let strongSelf = self else { return }
            strongSelf.state = .none
            }, failure: { (error: NSError) in
                AlertView.errorNoRetry(error.localizedDescription)
        })
    }
}

// MARK: UI Updating

extension NewActivityViewController {
    
    func updateLabels() {
        let formattedDistance = NewActivityViewController.distance(distance)
        let formattedTime = NewActivityViewController.time(seconds)
        
        self.distanceLabel?.text = "\(formattedDistance)"
        self.timeLabel?.text = "\(formattedTime)"
        
    }
    
    func updateButtonsForState() {
        
        switch state {
        case .none:
            self.startButton?.isHidden = false
            self.stopButton?.isHidden = true
        case .started:
            self.startButton?.isHidden = true
            self.stopButton?.isHidden = false
        case .stopped:
            self.startButton?.isHidden = false
            self.stopButton?.isHidden = true
        }
        
    }
}

// MARK: Location Manager Delegate

extension NewActivityViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            let lastLocation = location.timestamp.timeIntervalSinceNow
            guard location.horizontalAccuracy < 20 && abs(lastLocation) < 10 else { continue }
            
            if let lastLocation = self.locationList.last {
                let delta = location.distance(from: lastLocation)
                self.distance = self.distance + Measurement(value: delta, unit: UnitLength.meters)
            }
            self.locationList.append(location)
        }
    }
}

// MARK: Helpers

extension NewActivityViewController {
    
    static func distance(_ distance: Double) -> String {
        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
        return NewActivityViewController.distance(distanceMeasurement)
    }
    
    static func distance(_ distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        return formatter.string(from: distance)
    }
    
    static func time(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }
    
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
}
