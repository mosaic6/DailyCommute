//
//  ActivityDetailTableViewCell.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import UIKit

class ActivityDetailTableViewCell: UITableViewCell {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var athleteNameLabel: UILabel?
    @IBOutlet private weak var imageViewContainerView: UIView?
    @IBOutlet private weak var profileImageView: UIImageView?
    @IBOutlet private weak var activityDateLabel: UILabel?
    @IBOutlet private weak var totalTimeLabel: UILabel?
    @IBOutlet private weak var totalDistanceLabel: UILabel?
    @IBOutlet private weak var activityNameLabel: UILabel?
    
    // MARK: Varibles
    
    var athlete: Athlete?
    var activityType: ActivityType?
    var activity: Activity? {
        didSet {
            if let date = activity?.startDate {
                self.activityDateLabel?.text = self.shortDateFormat(date: date)
            }
            
            if let totalTime = activity?.movingTime {
                let (h,m,s) = self.secondsToHoursMinutesSeconds(seconds: Int(totalTime))
                self.totalTimeLabel?.text = "\(h)h \(m)m \(s)s"
            }
            
            if let totalDistance = activity?.distance {
                self.totalDistanceLabel?.text = "\(self.metersToFeet(meters: totalDistance))"
            }
            
            if let activityName = activity?.name {
                self.activityNameLabel?.text = activityName
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.configureProfileImageView()
    }
    
    // MARK: Configuration
    
    func configureProfileImageView() {
        self.imageViewContainerView?.layer.cornerRadius = 25
    }
}

// MARK: UI Updating

extension ActivityDetailTableViewCell {
    
    func update(athlete: Athlete, activity: Activity, activityType: ActivityType) {
        self.athlete = athlete
        self.activityType = activityType
        self.activity = activity
                
        background {
            self.profileImageView?.from(url: athlete.profileMedium)
            main {
                self.athleteNameLabel?.text = "\(athlete.firstname ?? "") \(athlete.lastname ?? "")"
            }
        }
    }
}

// MARK: Formatters

extension ActivityDetailTableViewCell {
    
    func shortDateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy, h:mm a"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.string(from: date)
    }
    
    func metersToFeet(meters: Double) -> Double {
        return (meters * 3.28084).rounded()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
}
