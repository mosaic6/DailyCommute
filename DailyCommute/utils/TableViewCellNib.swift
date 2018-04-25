//
//  TableViewCellNib.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/22/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import Foundation
import UIKit

enum TableViewCellNib: String {
    case ActivityDetailTableViewCell
}

// MARK: UITableView

extension UITableView {
    
    func dequeueReusableCell(withTableViewCellNib nib: TableViewCellNib) -> UITableViewCell? {
        return self.dequeueReusableCell(withIdentifier: nib.rawValue)
    }
    
    func registerNibs(_ tableViewCellNibs: Set<TableViewCellNib>) {
        tableViewCellNibs.forEach { registerNib($0) }
    }
    
    func registerNib(_ tableViewCellNib: TableViewCellNib) {
        let nib = UINib(tableViewCellNib: tableViewCellNib)
        register(nib, forCellReuseIdentifier: tableViewCellNib.rawValue)
    }
}

// MARK: UINib

fileprivate extension UINib {
    
    convenience init(tableViewCellNib: TableViewCellNib) {
        self.init(nibName: tableViewCellNib.rawValue, bundle: nil)
    }
}
