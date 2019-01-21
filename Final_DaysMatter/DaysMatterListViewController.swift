//
//  DaysMatterListViewController.swift
//  Final_DaysMatter
//
//  Created by Alexa Wang on 2019/1/21.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

import UIKit

class DaysMatterListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource  {
 
    var items:[DaysMatterItem]
    var nowTop: Int?
    
    required init?(coder aDecoder: NSCoder) {
        items = [DaysMatterItem]()
        
        let row0item = DaysMatterItem()
        row0item.title = "我的生日！"
        row0item.discription = "值得纪念"
        row0item.date = "May 12, 2018"
        row0item.isTopped = false
        items.append(row0item)
        
        let row1item = DaysMatterItem()
        row1item.title = "过年！"
        row1item.discription = "难忘！"
        row1item.date = "Feb 05, 2019"
        row1item.isTopped = true
        items.append(row1item)
        
        super.init(coder: aDecoder)
        //loadDaysMatterListTableViewItems()
    }

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topCountLabel: UILabel!
    @IBOutlet weak var topDateLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DaysMatterItemTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell") as! DaysMatterItemTableViewCell
        
        let item = items[indexPath.row] //每个行
        //print(item.date)
        
        cell.itemDateLabel.text = item.date
        
        
        // change the date type(String to Date)
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "MMM d, yyyy"
        let myDate = myFormatter.date(from: item.date)
        // find today
        let currentDate: NSDate = NSDate()
        // compare the date is passing or coming
        if myDate?.compare(currentDate as Date) == .orderedAscending
        {
            // it pass
            cell.itemNameStatusLabel.text = item.title + " 已经"
            cell.itemCountLabel.textColor = #colorLiteral(red: 0.3771707118, green: 0.418082118, blue: 0.7708801627, alpha: 1)
            item.status = 2
            
            if myDate != nil{
                // 计算 倒数天数
                let goDate: NSDate = myDate! as NSDate
                let interval: TimeInterval = goDate.timeIntervalSince(currentDate as Date)
                let second = Int(round(interval))
                let days = -second / 24 / 3600
                cell.itemCountLabel.text = "\(days)"
            }
        }
        if myDate?.compare(currentDate as Date) == .orderedDescending
        {
            //it come
            cell.itemNameStatusLabel.text = item.title + " 还有"
            cell.itemCountLabel.textColor = #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1)
            item.status = 1
            if myDate != nil{
                // 计算 倒数天数
                let goDate: NSDate = myDate! as NSDate
                //let currentDate: NSDate = NSDate()
                let interval: TimeInterval = goDate.timeIntervalSince(currentDate as Date)
                let second = Int(round(interval))
                let days = second / 24 / 3600
                
                cell.itemCountLabel.text = "\(days)"
            }
        }
        if item.isTopped == true{
            topCountLabel.text = cell.itemCountLabel.text
            topTitleLabel.text = cell.itemNameStatusLabel.text
            topDateLabel.text = cell.itemDateLabel.text
        }
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
