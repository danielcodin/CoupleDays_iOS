//
//  TodayViewController.swift
//  Coudple Days Widget
//
//  Created by Daniel Tseng on 4/29/18.
//  Copyright © 2018 Daniel Tseng. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var formatCountLabel: UILabel!
    
    private var setDate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        
        // get userDefaults setDate or current date
        setDate = UserDefaultDataHelper.loadKeyToGroupApp("setDate") as? Date
        if(setDate == nil) {
            countLabel.isHidden = true
            formatCountLabel.text = "Start Date Not Set"
        } else {
            countLabel.isHidden = false
            countDays()
        }
        
        completionHandler(NCUpdateResult.newData)
    }
    
    private func countDays() {
        // count days
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: setDate!)
        let endDate = calendar.startOfDay(for: Date())
        let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        // update countLabel text
        countLabel.text = "\(dateComponents.day!) days"
        
        // update formatCountLabel text
        formatCountLabel.text = endDate.offsetFrom(date: startDate)
        if(formatCountLabel.text!.contains("months")) { formatCountLabel.isHidden = false }
        else {
            formatCountLabel.text = ""
            formatCountLabel.isHidden = true
        }
    }
}
