//
//  DaysMatterItem.swift
//  Final_DaysMatter
//
//  Created by Alexa Wang on 2019/1/21.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

// item model
import Foundation

class DaysMatterItem: NSObject, NSCoding{
    
    var title: String = ""
    var discription: String?
    var date: String = ""
    var status: Int = 0
    var isTopped = false
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(discription, forKey: "discription")
        aCoder.encode(date, forKey: "date")
        //aCoder.encode(status, forKey: "status")
        aCoder.encode(isTopped, forKey: "isTopped")
    }
    
    required init?(coder aDecoder: NSCoder) {
        title = aDecoder.decodeObject(forKey: "title") as! String
        discription = aDecoder.decodeObject(forKey: "discription") as? String
        date = aDecoder.decodeObject(forKey: "date") as! String
        //status = aDecoder.decodeObject(forKey: "status") as! Int
        isTopped = aDecoder.decodeBool(forKey: "isTopped")
    
        super.init()
    }
    
    override init() {
        super.init()
    }
    
   
    
}
