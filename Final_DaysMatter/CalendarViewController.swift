//
//  ViewController.swift
//  Final_DaysMatter
//
//  Created by Alexa Wang on 2019/1/14.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, DairyDetailViewControllerDelegate{
    
    // MARK: - <IBOutlet>
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    // MARK: - <设置日期格式>
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd/EEEE"
        return formatter
    }()
    
    // MARK: - <今日数据和带事件日期Array>
    var today:NSDate = Date() as NSDate
    var datesWithEvent = ["2019/01/04/Friday", "2019/01/12/Saturday", "2018/12/28/Friday", "2018/12/30/Sunday"]
    
    // MARK: - <临时dairylisttableviewitem数据>
    var items: [DiaryListTableViewItem]
    required init?(coder aDecoder: NSCoder) {
        items = [DiaryListTableViewItem]()
        
        let row0item = DiaryListTableViewItem()
        row0item.Day = "04"
        row0item.Month = "01"
        row0item.Year = "2019"
        row0item.Week = "Friday"
        row0item.dateData = "2019/01/04/Friday"
        row0item.DairyTitle = "倒数日日记的诞生"
        row0item.DairyContent = "Hi！欢迎使用倒数日日记，选择特定日期即可点击右上角+就可以记录你的当日生活啦！"
        items.append(row0item)

        let row1item = DiaryListTableViewItem()
        row1item.Day = "06"
        row1item.Month = "01"
        row1item.Year = "2019"
        row1item.Week = "Sunday"
        row1item.dateData = "2019/01/06/Sunday"
        row1item.DairyTitle = "快乐周末"
        row1item.DairyContent = "聪明的你有没有发现周末标签卡的不同之处呢！！！"
        items.append(row1item)
        
        super.init(coder: aDecoder)
        loadDiaryListTableViewItems()
    }
    
    // MARK: - <ViewDidLoad>
    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        print(self.dateFormatter.string(from: Date() as Date))//打印今日
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]//设置年月及Weekday标签样式
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0;//调整header前后月份标签静止时刻透明
        self.calendar.appearance.headerDateFormat = "yyyy年MM月"; //调整日历header的年月格式
        self.calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20)

        //清除分割线颜色和group顶部留白
        tableView.separatorColor = UIColor.clear
        tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 1))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "AddDairy"{
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! DairyDetailViewController
            controller.delegate = self
            
        } else if segue.identifier == "EditDairy"{
            
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! DairyDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = items[indexPath.row]
                
            }
        }
    }
    
    // MARK: - <上下月按钮>
    @IBAction func prevMonth(_ sender: UIButton) {
        calendar.setCurrentPage(getPreviousMonth(date: calendar.currentPage), animated: true)
        print(calendar.currentPage)
        print("\(Calendar.current)")
    }
    @IBAction func nextMonth(_ sender: UIButton) {
        calendar.setCurrentPage(getNextMonth(date: calendar.currentPage), animated: true)
        print(calendar.currentPage)
        print("\(Calendar.current)")
    }
    func getPreviousMonth(date:Date)->Date{
        return  Calendar.current.date(byAdding: .month, value: -1, to:date)!
    }
    func getNextMonth(date:Date)->Date{
        return  Calendar.current.date(byAdding: .month, value: 1, to:date)!
    }
    
    // MARK: - <最大日期>
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date() as Date
    }
    
    // MARK: - <设置工作日和周末颜色区别>
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        let key = self.dateFormatter.string(from: date)
        if self.datesWithEvent.contains(key){
            let array = key.components(separatedBy: "/")
            print(array)
            if array[3] == "Saturday" || array[3] == "Sunday"{
                return #colorLiteral(red: 0.3658596277, green: 0.4213520288, blue: 0.7972604036, alpha: 1)
            }
            return #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1)
        }
        return nil
    }
    
    // MARK: - <设置日期选择事件 当前日期有Event时add不可用 没有时点击才可用>
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let selectDay = self.dateFormatter.string(from: date)
        print(selectDay.components(separatedBy: "/"))
//        if self.datesWithEvent.contains(selectDay){
//            self.addButton.isEnabled = false
//            print("false")
//        }else{
//            self.addButton.isEnabled = true
//            print("true")
//        }
        if selectDay == self.dateFormatter.string(from: today as Date){
            self.addButton.isEnabled = true
            print("true")
        }else{
            self.addButton.isEnabled = false
            print("true")
        }
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    //获取编辑页面delegate
    func dairyDetailViewController(_ controller: DairyDetailViewController, didFinishingAdding item: DiaryListTableViewItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPathArray = [indexPath]
        tableView.insertRows(at: indexPathArray, with: .automatic)
        
        dismiss(animated: true, completion: nil)
        saveDiaryListTableViewItems()
        
    }
    
    func dairyDetailViewController(_ controller: DairyDetailViewController, didFinishingEditing item: DiaryListTableViewItem) {
        if let index = items.index(of: item){
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath){
                configureLebal(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        saveDiaryListTableViewItems()
    
    }
    
    // MARK: - <设置日历列表的展示>
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func configureLebal(for cell: UITableViewCell, with item: DiaryListTableViewItem) {
        let dayLabel = cell.viewWithTag(1) as! UILabel
        let monthLabel = cell.viewWithTag(2) as! UILabel
        let yearLabel = cell.viewWithTag(3) as! UILabel
        let dairyTitleLabel = cell.viewWithTag(4) as! UILabel
        let dairyContentLabel = cell.viewWithTag(5) as! UILabel
        let weekImageView = cell.viewWithTag(6) as! UIImageView
        
        dayLabel.text = item.Day
        monthLabel.text = item.Month
        yearLabel.text = item.Year
        dairyTitleLabel.text = item.DairyTitle
        dairyContentLabel.text = item.DairyContent
        if item.Week == "Saturday" || item.Week == "Sunday"{
            weekImageView.image = UIImage(named: "cellLabelWeekend")
        }else{
            weekImageView.image = UIImage(named: "cellLabelWeekday")
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "DiaryListItem", for: indexPath)
        let item = items[indexPath.row]
        configureLebal(for: cell, with: item)
        return cell
        
    }
    
    // MARK: - <设置数据加载+保存>
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL{
        return documentDirectory().appendingPathComponent("DiaryList1.plist")
    }
    
    func loadDiaryListTableViewItems(){
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path){
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            items = unarchiver.decodeObject(forKey: "DiaryListTableViewItems")
                as! [DiaryListTableViewItem]
            unarchiver.finishDecoding()
        }
    }
    
    func saveDiaryListTableViewItems(){
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(items, forKey: "DiaryListTableViewItems")
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    
}

