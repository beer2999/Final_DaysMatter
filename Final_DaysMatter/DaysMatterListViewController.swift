//
//  DaysMatterListViewController.swift
//  Final_DaysMatter
//
//  Created by Alexa Wang on 2019/1/21.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

import UIKit

class DaysMatterListViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, AddItemViewControllerDelegate  {
   
    
 
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
        loadDaysMatterListTableViewItems()
    }

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topCountLabel: UILabel!
    @IBOutlet weak var topDateLabel: UILabel!
    @IBOutlet weak var tableview: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDaysMatterListTableViewItems()

        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailTableViewController
            controller.delegate = self
        }
    }
    
    
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL{
        return documentDirectory().appendingPathComponent("DaysMatterListItems.plist")
    }
    
    // MARK: - <对items模型进行归档和解档>
    func saveDaysMatterListTableViewItems(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "DaysMatterTableViewItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveDaysMatterListTableViewItems()
    }
    
    func addItemViewControllerDidCancel(_ controller: ItemDetailTableViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func addItemViewController(_ controller: ItemDetailTableViewController, didFinishAdding item: DaysMatterItem) {
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
    
    func addItemViewController(_ controller: ItemDetailTableViewController, didFinishEditing item: DaysMatterItem) {
        
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
