//
//  Utilities.swift
//  Coudple Days Widget
//
//  Created by Daniel Tseng on 4/29/18.
//  Copyright © 2018 Daniel Tseng. All rights reserved.
//

import UIKit

class Utilities {

}

extension Date {
    // get year month day difference between two dates
    func offsetFrom(date : Date) -> String {
        let yearMonthDay: Set<Calendar.Component> = [.year, .month, .day]
        let difference = Calendar.current.dateComponents(yearMonthDay, from: date, to: self);
        
        let days = "\(difference.day ?? 0) days"
        let months = "\(difference.month ?? 0) months," + " " + days
        let years = "\(difference.year ?? 0) years," + " " + months
        
        if let year = difference.year, year    > 0 { return years }
        if let month = difference.month, month > 0 { return months }
        if let day = difference.day, day       > 0 { return days }
        
        return ""
    }
    
}

class UserDefaultDataHelper: NSObject {
    static func saveKeyToGroupApp(_ value: AnyObject?, withKey key:String) -> Void {
        UserDefaults(suiteName: "group.danielcoding.com.Couple-Days")!.set(value, forKey: key)
        UserDefaults(suiteName: "group.danielcoding.com.Couple-Days")!.synchronize()
    }
    
    static func loadKeyToGroupApp(_ key:String)  -> AnyObject? {
        if let loadedValue = UserDefaults(suiteName: "group.danielcoding.com.Couple-Days")?.object(forKey: key){
            return loadedValue as AnyObject?
        }
        return nil
    }
}
