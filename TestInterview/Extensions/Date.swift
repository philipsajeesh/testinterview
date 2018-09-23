//
//  Date.swift
//  TestInterview
//
//  Created by Sajeesh Philip on 22/09/18.
//  Copyright © 2018 Sajeesh Philip. All rights reserved.
//
import UIKit
extension Date {

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        ///Declare Variables
        var isGreater = false
        
        ///Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        ///Return Result
        return isGreater
    }
}
