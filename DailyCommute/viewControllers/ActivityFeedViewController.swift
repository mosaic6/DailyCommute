//
//  NewActivityViewController.swift
//  DailyCommute
//
//  Created by Joshua Walsh on 4/21/18.
//  Copyright © 2018 Lucky Penguin. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ActivityFeedViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView?
    
    // MARK: Variables
    
    private var athlete: Athlete?
    private var activity: [Activity]? {
        didSet {
            self.reloadDataModelAndRefresh()
        }
    }
    private var strava = StravaService.shared
    private var tableViewData: [CellIdentifier] = []
    private var activityIndicator = UIActivityIndicatorView()
    
    deinit {
        self.tableView?.dataSource = nil
    }
    
    // MARK: UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Daily Commute"
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.barTintColor = Color.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchAthleteData()
        self.fetchActivityData()
        
        self.configureTableView()
        self.configureActivityIndicator()        
    }
}

// MARK: IBActions

private extension ActivityFeedViewController {

    @IBAction func trackButtonTapped(_ sender: UIButton) {
        let locationService = LocationService.shared
        locationService.requestWhenInUseAuthorization()
        
        ViewRoutes.goToRoute(.newActivity)
    }
}

// MARK: Configuration

extension ActivityFeedViewController {
    
    func configureTableView() {
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        self.tableView?.registerNib(.ActivityDetailTableViewCell)
    }
    
    func reloadDataModelAndRefresh() {
        guard let activitys = self.activity else { return }
        var tableViewData: [CellIdentifier] = []
        
        if !activitys.isEmpty {
            activitys.forEach { activity in
                tableViewData.append(.activityDetail(activity))
            }
        }
        
        main {
            self.tableViewData = tableViewData
            self.tableView?.reloadData()
        }
    }
    
    func configureActivityIndicator() {
        self.activityIndicator.activityIndicatorViewStyle = .gray
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.view.addSubview(self.activityIndicator)
    }
}

// MARK: TableView Delegate and DataSource

extension ActivityFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let identifier = self.identifierForIndexPath(indexPath) else { return UITableViewCell() }
        
        switch identifier {
        case .activityDetail:
            let cell = tableView.dequeueReusableCell(withTableViewCellNib: .ActivityDetailTableViewCell) as! ActivityDetailTableViewCell
            self.configureActivityDetailCell(cell: cell, indexPath: indexPath)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let identifier = self.identifierForIndexPath(indexPath) else { return }
        
        switch identifier {
        case .activityDetail:
            self.configureActivityDetailCell(cell: cell, indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    fileprivate func identifierForIndexPath(_ indexPath: IndexPath) -> CellIdentifier? {
        return self.tableViewData[safe: indexPath.row]
    }

}

// MARK: Cell Data

extension ActivityFeedViewController {
    
    func configureActivityDetailCell(cell: UITableViewCell, indexPath: IndexPath) {
        guard let athlete = self.athlete, let activity = self.activity?[safe: indexPath.row] else { return }
        if let cell = cell as? ActivityDetailTableViewCell {
            cell.update(athlete: athlete, activity: activity, activityType: .ride)
        }
    }
}

// MARK: Requests

extension ActivityFeedViewController {
    
    func fetchAthleteData() {
        background {
            try? StravaService.shared.request(Router.athlete, result: { [weak self] (athlete: Athlete?) in
                guard let strongSelf = self, let athlete = athlete else { return }
                strongSelf.athlete = athlete
                }, failure: { (error: NSError) in
                    main {
                        AlertView.errorNoRetry(error.localizedDescription)
                    }
            })
        }
        
    }
    
    func fetchActivityData() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        background {
            try? StravaService.shared.requestMulti(Router.athleteActivites(params: nil), result: { [weak self] (activity: [Activity]?) in
                guard let strongSelf = self else { return }
                strongSelf.activity = activity
                main {
                    strongSelf.activityIndicator.stopAnimating()
                }
                
                }, failure: { (error: NSError) in
                    main {
                        AlertView.errorNoRetry(error.localizedDescription)
                    }
            })
        }
        
    }
}

// MARK: CellIdentifier

extension ActivityFeedViewController {
    
    enum CellIdentifier {
        case activityDetail(Activity)
        
        var tableViewCellNib: TableViewCellNib {
            switch self {
            case .activityDetail:
                return .ActivityDetailTableViewCell
            }
        }
                
        var reuseIdentifier: String {
            switch self {
            case .activityDetail:
                return "ActivityDetailTableViewCell"
            }
        }
    }
}
