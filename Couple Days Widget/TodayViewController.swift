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
    @IBOutlet weak var kakaImageView: UIImageView!
    
    private let kAKA_IMAGE_COUNT = 14
    
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
        
        // check if need to update kakaImageView
        if(checkUpdateKakaImageView()) {
            // update kakaImageView
            updateKakaImageView()
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
    
    private func checkUpdateKakaImageView() -> Bool {
        // get the time last changed the image
        let lastMinutes = UserDefaultDataHelper.loadKeyToGroupApp("lastTimeChangedKakaImage") as? Int
        if(lastMinutes == nil) {
            // set first kakaImage
            kakaImageView.image = UIImage(named: "kaka_1")
            
            // save the current kakaImage index to userDefaults
            UserDefaultDataHelper.saveKeyToGroupApp(1 as AnyObject?, withKey: "kakaImageIndex")
            
            // get current time minutes
            let date = Date()
            let calendar = Calendar.current
            let minutes = calendar.component(.minute, from: date)
            
            // save the time last changed the image
            UserDefaultDataHelper.saveKeyToGroupApp(minutes as AnyObject?, withKey: "lastTimeChangedKakaImage")
            
            return false
        }
        
        // get current time minutes
        let date = Date()
        let calendar = Calendar.current
        let curMinutes = calendar.component(.minute, from: date)
        
        if(lastMinutes! < curMinutes && curMinutes-lastMinutes! >= 30) {
            return true
        } else if(lastMinutes! > curMinutes && 60+curMinutes-lastMinutes! >= 30) {
            return true
        }

        return false
    }
    
    private func updateKakaImageView() {
        // get the current kakaImage index to userDefaults
        var kakaImageIndex = UserDefaultDataHelper.loadKeyToGroupApp("kakaImageIndex") as? Int
        if(kakaImageIndex == nil) {
            kakaImageIndex = 0
        }
        
        // update kakaImageIndex
        kakaImageIndex = kakaImageIndex! + 1
        if(kakaImageIndex! > kAKA_IMAGE_COUNT) {
            kakaImageIndex = 1;
        }
        
        // update kakaImageView
        kakaImageView.image = UIImage(named: "kaka_\(kakaImageIndex!)")
        
        // save the current kakaImage index to userDefaults
        UserDefaultDataHelper.saveKeyToGroupApp(kakaImageIndex as AnyObject?, withKey: "kakaImageIndex")

        // get current time minutes
        let date = Date()
        let calendar = Calendar.current
        let minutes = calendar.component(.minute, from: date)
        
        // save the time last changed the image
        UserDefaultDataHelper.saveKeyToGroupApp(minutes as AnyObject?, withKey: "lastTimeChangedKakaImage")
    }
}
