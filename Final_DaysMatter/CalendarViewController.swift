//
//  ViewController.swift
//  Final_DaysMatter
//
//  Created by Alexa Wang on 2019/1/14.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    //新建日历数据库
    var dataSource = [[String:String]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1)

        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        
        self.calendar.appearance.caseOptions = [.headerUsesUpperCase,.weekdayUsesUpperCase]//设置年月及Weekday标签样式
        self.calendar.appearance.headerMinimumDissolvedAlpha = 0;//调整header前后月份标签静止时刻透明
        self.calendar.appearance.headerDateFormat = "yyyy年MM月"; //调整日历header的年月格式
        self.calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 20)
        //滑动手势相关（后续补充左右按钮事件可删除）
        let scopeGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        self.calendar.addGestureRecognizer(scopeGesture)
        
        //注册cell
        let cellNib = UINib(nibName: "MineTableViewCell", bundle: nil)
        //设置重用ID
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        //清楚分割线颜色
        tableView.separatorColor = UIColor.clear
        
        //设置日历数据内容
        dataSource = [
            ["Day":"04","YearAndMonth":"2019年01月","DairyTitle":"天才生日了","DairyContent":"预祝两个今日生日的小天才为iPhone程序设计秃头快乐"],
            ["Day":"29","YearAndMonth":"2018年12月","DairyTitle":"要放假了","DairyContent":"我没有放假，因为要补课and赶dddddddddddddl们"],
            ["Day":"25","YearAndMonth":"2018年12月","DairyTitle":"圣诞节啦啦啦啦","DairyContent":"MerryChristmas!"],
            ["Day":"13","YearAndMonth":"2018年11月","DairyTitle":"不知道嘻嘻嘻","DairyContent":"随便写写......hahhahahahhhhiwhid"],
            ["Day":"06","YearAndMonth":"2018年10月","DairyTitle":"演唱会快乐","DairyContent":"太开心辽"]]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //设置tableviewcell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
    //设置c输出条数
    func tableView(_ tableView: UITableView, numberOfRowsInSection Section: Int) -> Int{
        return dataSource.count
    }
    //设置点击事件
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("/\(indexPath.row)")
    }
    //设置cell具体内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MineTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! MineTableViewCell
        //利用日记数据创建字典
        let dict:Dictionary = dataSource[indexPath.row]
        cell.dayLabel.text = dict["Day"]
        cell.yearAndMonthLabel.text = dict["YearAndMonth"]
        cell.dairyTitleLabel.text = dict["DairyTitle"]
        cell.dairyContentLabel.text = dict["DairyContent"]
        return cell
    }
}

