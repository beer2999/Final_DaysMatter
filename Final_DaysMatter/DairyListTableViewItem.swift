//
//  DairyListTableViewItem.swift
//  Final_DaysMatter
//
//  Created by Taeya on 2019/1/18.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//
import Foundation

class DairyListTableViewItem: NSObject, NSCoding {
    
    var Day = ""
    var Month = ""
    var Year = ""
    var Week = ""
    var dateData = ""
    var DairyTitle = ""
    var DairyContent = ""
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(Day, forKey: "Day")
        aCoder.encode(Month, forKey: "Month")
        aCoder.encode(Year, forKey: "Year")
        aCoder.encode(Week, forKey: "Week")
        aCoder.encode(dateData, forKey: "dateData")
        aCoder.encode(DairyTitle, forKey: "DairyTitle")
        aCoder.encode(DairyContent, forKey: "DairyContent")
    }
    required init?(coder aDecoder: NSCoder) {
        Day = aDecoder.decodeObject(forKey: "Day") as! String
        Month = aDecoder.decodeObject(forKey: "Month") as! String
        Year = aDecoder.decodeObject(forKey: "Year") as! String
        Week = aDecoder.decodeObject(forKey: "Week") as! String
        dateData = aDecoder.decodeObject(forKey: "dateData") as! String
        DairyTitle = aDecoder.decodeObject(forKey: "DairyTitle") as! String
        DairyContent = aDecoder.decodeObject(forKey: "DairyContent") as! String
        
        super.init()
    }
    override init(){
        super.init()
    }
}
