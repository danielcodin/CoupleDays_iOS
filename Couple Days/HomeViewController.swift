//
//  HomeViewController.swift
//  Couple Days
//
//  Created by Daniel Tseng on 4/29/18.
//  Copyright © 2018 Daniel Tseng. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var formatCountLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var datePickerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private var setDate: Date?
    private var SET_START_DATE_DEFAULT = "set start date"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // initialize
        countLabel.text = "0"
        startButton.setTitle(SET_START_DATE_DEFAULT, for: .normal)
        datePicker.maximumDate = Date()
        datePickerViewBottomConstraint.constant = datePickerView.frame.height
        view.layoutIfNeeded()
        
        // get userDefaults setDate or current date
        setDate = UserDefaultDataHelper.loadKeyToGroupApp("setDate") as? Date
        if(setDate == nil) { setDate = Date() }
        datePicker.setDate(setDate!, animated: false)
        
        // get userDefault setDateString or default set date string
        let setDateString = UserDefaultDataHelper.loadKeyToGroupApp("setDateString") as? String
        if(setDateString != nil) { startButton.setTitle("start: \(setDateString!)", for: .normal) }
        
        // count days
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: setDate!)
        let endDate = calendar.startOfDay(for: Date())
        let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        // update countLabel text
        countLabel.text = "\(dateComponents.day!)"
        
        // update formatCountLabel text
        formatCountLabel.text = endDate.offsetFrom(date: startDate)
        if(formatCountLabel.text!.contains("months")) { formatCountLabel.isHidden = false }
        else {
            formatCountLabel.text = ""
            formatCountLabel.isHidden = true
        }
    }
    
    // hide keyboard when touch outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // hide datePickerView
        hideDatePickerView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        // show datePickerView
        showDatePickerView()
    }
    
    @IBAction func datePickerCancelPressed(_ sender: Any) {
        // hide datePickerView
        hideDatePickerView()
    }
    
    @IBAction func datePickerDonePressed(_ sender: Any) {
        setDate = datePicker.date
        
        // count days
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: setDate!)
        let endDate = calendar.startOfDay(for: Date())
        let dateComponents = calendar.dateComponents([.day], from: startDate, to: endDate)
        

        // update countLabel text
        countLabel.text = "\(dateComponents.day!)"
        
        // update formatCountLabel text
        formatCountLabel.text = endDate.offsetFrom(date: startDate)
        if(formatCountLabel.text!.contains("months")) { formatCountLabel.isHidden = false }
        else {
            formatCountLabel.text = ""
            formatCountLabel.isHidden = true
        }
        
        // update startButton title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        startButton.setTitle("start: \(dateFormatter.string(from: setDate!))", for: .normal)
        
        // save the set date to userDefaults
        UserDefaultDataHelper.saveKeyToGroupApp(setDate as AnyObject?, withKey: "setDate")
        UserDefaultDataHelper.saveKeyToGroupApp(dateFormatter.string(from: setDate!) as AnyObject?, withKey: "setDateString")
        
        // hide datePickerView
        hideDatePickerView()
    }
    
    private func showDatePickerView() {
        datePickerViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func hideDatePickerView() {
        datePickerViewBottomConstraint.constant = datePickerView.frame.height
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        // reset datePicker's default value
        datePicker.setDate(setDate!, animated: false)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
