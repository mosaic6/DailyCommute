//
//  Color.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

public struct Color {
    
    // MARK: Clear
    public static var clear: UIColor { return UIColor.clear }
    
    // MARK: Orange
    public static var orange: UIColor { return DailyCommute.orange.createColor() }
    
    // MARK: White
    public static var white: UIColor { return UIColor.white }
    public static var whiteOff: UIColor { return DailyCommute.whiteOff.createColor() }
    public static var whiteOffDark: UIColor { return DailyCommute.whiteOffDark.createColor() }
}

// MARK: - Private members -

private extension Color {
    
    enum DailyCommute: UInt64 {
        case orange = 0xE9811C        
        case whiteOff = 0xF5F4EC
        case whiteOffDark = 0xE2E2DC
        
        func createColor() -> UIColor {
            return UIColor(hex: self.rawValue)
        }
    }
}

// MARK: - Other class extensions -

// MARK: UIColor

extension UIColor {
    
    convenience init(hex: UInt64, alpha: CGFloat = 1) {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0x00ff00) >> 8) / 255.0
        let blue = CGFloat(hex & 0x0000ff) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    convenience init?(hexString: String, alpha: CGFloat = 1) {
        let hex = hexString.replacingOccurrences(of: "#", with: "")
        if let hexValue = UInt64(hex, radix: 16) {
            self.init(hex: hexValue, alpha: alpha)
        } else {
            return nil
        }
    }
}
