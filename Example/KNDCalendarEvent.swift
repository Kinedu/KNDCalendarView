//
//  KNDCalendarEvent.swift
//  KNDCalendarView_Example
//
//  Created by Rogelio Contreras on 8/13/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit

@objc protocol CalendarDelegate {
    @objc optional func didReciveCalendarEvents()
    
}

class KNDCalendarEvent: NSObject {
    static let shared = KNDCalendarEvent()
    var delegate : CalendarDelegate?
    var id: Int = 0
    var detail:String = ""
    var startDate: String = ""
    var endDate: String = ""
    var startHour:String = ""
    var endHour:String = ""
    var startTypeDate: DateComponents = DateComponents()
    var endTypeDate: DateComponents = DateComponents()
    
    
    override init() {
        
    }
    
    init(with dict : [String:Any]) {
        
        if let id = dict["id"] as? Int {
            self.id = id
        }
        
        if let description = dict["description"] as? String {
            self.detail = description
        }
        
        if let startH = dict["start_hour"] as? String {
            self.startHour = startH
        }
        if let endH = dict["end_hour"] as? String {
            self.endHour = endH
        }
        
        if let endD = dict["end_date"] as? String {
            self.endDate = endD
        }
        
        if let startD = dict["start_date"] as? String {
            self.startDate = startD
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat =  "yyyy-MM-dd"
        let dateStart = dateFormatter.date (from: String(self.startDate.dropLast(9)))
        let dateEnd = dateFormatter.date (from: String(self.endDate.dropLast(9)))
        let calendar = Calendar.current
        self.startTypeDate = calendar.dateComponents([.year, .month, .day], from: dateStart!)
        self.endTypeDate = calendar.dateComponents([.year, .month, .day], from: dateEnd!)
        
    }
    
}
