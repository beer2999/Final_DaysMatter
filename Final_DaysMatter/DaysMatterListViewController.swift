//
//  DaysMatterListViewController.swift
//  Final_DaysMatter
//
//  Created by Alexa Wang on 2019/1/21.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

import UIKit

class DaysMatterListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, ItemDetailViewControllerDelegate, ItemManagerViewControllerDelegate  {
   
   
    
    //MARK: - <Outlet & origin defination>
    
    var nowTop: Int?
    
    // build some data in Days Matter list
    var items:[DaysMatterItem]
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
        loadDaysMatterListTableViewItems()
    }

    //Outlet
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topCountLabel: UILabel!
    @IBOutlet weak var topDateLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    //MARK: - <load view and segue>
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDaysMatterListTableViewItems()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //set segue and some data tranfer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddDaysMatter" {
            let controller = segue.destination as! ItemDetailTableViewController
            controller.delegate = self
        }else if segue.identifier == "ManageDaysMatter" {
            let controller = segue.destination as! ItemManagerViewController
            let sender = sender as! UITableViewCell
            let label = sender.viewWithTag(10001) as! UILabel
            controller.countNum = label.text
            controller.delegate = self
            if let indexPath = self.tableview.indexPath(for: sender ) {
                controller.itemToEdit = items[indexPath.row]
                //print(controller.itemToEdit?.title)
            }
        }
    }
    
    // MARK: - <encode and decode the item model>
    // save in .plist
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL{
        return documentDirectory().appendingPathComponent("DaysMatterListItems.plist")
    }
    
    // encode
    func saveDaysMatterListTableViewItems(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "DaysMatterTableViewItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
    //decode
    func loadDaysMatterListTableViewItems(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "DaysMatterTableViewItems")
                as! [DaysMatterItem]
            //print(items)
            unarchiver.finishDecoding()
        }
    }
    
    // MARK: - <tableview delegate>
    // set row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // set row number
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    //set every row's content
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DaysMatterItemTableViewCell = self.tableview.dequeueReusableCell(withIdentifier: "cell") as! DaysMatterItemTableViewCell
        
        let item = items[indexPath.row] //每个行
        
        
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
            
             // 计算 倒数天数
            if myDate != nil{
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
            
             // 计算 倒数天数
            if myDate != nil{
                let goDate: NSDate = myDate! as NSDate
                //let currentDate: NSDate = NSDate()
                let interval: TimeInterval = goDate.timeIntervalSince(currentDate as Date)
                let second = Int(round(interval))
                let days = second / 24 / 3600
                
                cell.itemCountLabel.text = "\(days)"
            }
        }
        // 判断是否置顶
        if item.isTopped == true{
            topCountLabel.text = cell.itemCountLabel.text
            topTitleLabel.text = cell.itemNameStatusLabel.text
            topDateLabel.text = cell.itemDateLabel.text
        }
        
        return cell
    }
    
    
    // delete row
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveDaysMatterListTableViewItems()
    }
    
    
    // MARK:- <delegate (from itemDetail and itemManager)>
    
    //添加页面返回执行
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailTableViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    //添加页面新添内容保存执行
    func ItemDetailViewController(_ controller: ItemDetailTableViewController, didFinishAdding item: DaysMatterItem) {
        print("finish Adding")
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        self.tableview.insertRows(at: indexPaths, with: .automatic)
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated:true)

        saveDaysMatterListTableViewItems()
    }
    // 添加页面编辑 未在本view用到
    func ItemDetailViewController(_ controller: ItemDetailTableViewController, didFinishEditing item: DaysMatterItem) {
        
    }
    
    
    // 管理页面 返回执行
    func ItemManagerViewControllerDidCancel(_ controller: ItemManagerViewController) {
        navigationController?.popViewController(animated:true)
    
    }
    
    // 管理页面 点击置顶执行
    func ItemManagerViewController(_ controller: ItemManagerViewController, didFinishTopping item: DaysMatterItem) {
        
        for each in items{
            if each.isTopped == true{
                each.isTopped = false
            }
        }
        item.isTopped = true
        
        if let index = items.index(of: item){
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.tableview.cellForRow(at: indexPath) {
                
                let labelDate = cell.viewWithTag(100) as! UILabel
                let labelTitle = cell.viewWithTag(10) as! UILabel
                let labelCount = cell.viewWithTag(10001) as! UILabel
                if item.status == 3{
                    labelDate.text = item.date
                    
                    let myFormatter = DateFormatter()
                    myFormatter.dateFormat = "MMM d, yyyy"
                    let myDate = myFormatter.date(from: item.date)
                    // find today
                    let currentDate: NSDate = NSDate()
                    // compare the date is passing or coming
                    if myDate?.compare(currentDate as Date) == .orderedAscending
                    {
                        // it pass
                        labelTitle.text = item.title + " 已经"
                        labelCount.textColor = #colorLiteral(red: 0.3771707118, green: 0.418082118, blue: 0.7708801627, alpha: 1)
                        item.status = 2
                        
                        if myDate != nil{
                            // 计算 倒数天数
                            let goDate: NSDate = myDate! as NSDate
                            let interval: TimeInterval = goDate.timeIntervalSince(currentDate as Date)
                            let second = Int(round(interval))
                            let days = -second / 24 / 3600
                            labelCount.text = "\(days)"
                        }
                    }
                    if myDate?.compare(currentDate as Date) == .orderedDescending
                    {
                        //it come
                        labelTitle.text = item.title + " 还有"
                        labelCount.textColor = #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1)
                        item.status = 1
                        if myDate != nil{
                            // 计算 倒数天数
                            let goDate: NSDate = myDate! as NSDate
                            //let currentDate: NSDate = NSDate()
                            let interval: TimeInterval = goDate.timeIntervalSince(currentDate as Date)
                            let second = Int(round(interval))
                            let days = second / 24 / 3600
                            
                            labelCount.text = "\(days)"
                        }
                    }
                }
                
                topCountLabel.text = labelCount.text
                topTitleLabel.text = labelTitle.text
                topDateLabel.text = labelDate.text
                
            }
        }
        saveDaysMatterListTableViewItems()
        navigationController?.popViewController(animated:true)

    }
    
    // 管理页面 如数据被编辑 点返回执行
    func ItemManagerViewController(_ controller: ItemManagerViewController, didFinishEditing item: DaysMatterItem) {
       
        if let index = items.index(of: item){
            
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = self.tableview.cellForRow(at: indexPath) {
                
                let labelDate = cell.viewWithTag(100) as! UILabel
                let labelTitle = cell.viewWithTag(10) as! UILabel
                let labelCount = cell.viewWithTag(10001) as! UILabel

                labelDate.text = item.date
                
                let myFormatter = DateFormatter()
                myFormatter.dateFormat = "MMM d, yyyy"
                let myDate = myFormatter.date(from: item.date)
                // find today
                let currentDate: NSDate = NSDate()
                // compare the date is passing or coming
                if myDate?.compare(currentDate as Date) == .orderedAscending
                {
                    // it pass
                    labelTitle.text = item.title + " 已经"
                    labelCount.textColor = #colorLiteral(red: 0.3771707118, green: 0.418082118, blue: 0.7708801627, alpha: 1)
                    item.status = 2
                    
                    if myDate != nil{
                        // 计算 倒数天数
                        let goDate: NSDate = myDate! as NSDate
                        let interval: TimeInterval = goDate.timeIntervalSince(currentDate as Date)
                        let second = Int(round(interval))
                        let days = -second / 24 / 3600
                        labelCount.text = "\(days)"
                    }
                }
                if myDate?.compare(currentDate as Date) == .orderedDescending
                {
                    //it come
                    labelTitle.text = item.title + " 还有"
                    labelCount.textColor = #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1)
                    item.status = 1
                    if myDate != nil{
                        // 计算 倒数天数
                        let goDate: NSDate = myDate! as NSDate
                        //let currentDate: NSDate = NSDate()
                        let interval: TimeInterval = goDate.timeIntervalSince(currentDate as Date)
                        let second = Int(round(interval))
                        let days = second / 24 / 3600
                        
                        labelCount.text = "\(days)"
                    }
                }
            }
        }
        saveDaysMatterListTableViewItems()
        navigationController?.popViewController(animated:true)
        

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
