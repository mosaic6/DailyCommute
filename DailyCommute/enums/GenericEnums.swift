//
//  GenericEnums.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import SwiftyJSON

public enum ActivityType: String {
    case
    ride, run, swim, hike, walk, alpineSki, backcountrySki, canoeing, crossfit, eBikeRide, elliptical,
    iceSkate, inlineSkate, kayaking, yoga, kitesurf, nordicSki, rockClimbing, rollerSki, rowing,
    snowboard, snowshoe, stairStepper, standUpPaddling, surfing, virtualRide, weightTraining, windsurf, workout
}

/**
 Data type enum for uploaded activities
 **/
public enum DataType: String {
    case fit = "fit", fitGz = "fit.gz", tcx = "tcx", tcxGz = "tcx.gz", gpx = "gpx", gpxGz = "gpx.gz"
}
