//
//  UIImage.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func from(url: URL?) {
        guard let u = url else { return }
        do {
            let data = try Data(contentsOf: u)
            main {
                self.image = UIImage(data: data)
            }
        }
        catch {
            return
        }
    }
}
