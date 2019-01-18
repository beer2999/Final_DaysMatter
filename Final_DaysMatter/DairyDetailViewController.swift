//
//  DairyDetailViewController.swift
//  Final_DaysMatter
//
//  Created by Taeya on 2019/1/17.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

import UIKit

protocol DairyDetailViewControllerDelegate: class {
    func dairyDetailViewController(_ controller: DairyDetailViewController, didFinishingAdding item: DiaryListTableViewItem)
    func dairyDetailViewController(_ controller: DairyDetailViewController, didFinishingEditing item: DiaryListTableViewItem)
}

class DairyDetailViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    
    @IBOutlet weak var dairyTitleField: UITextField!
    @IBOutlet weak var dairyContentField: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    weak var delegate: DairyDetailViewControllerDelegate?
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd/EEEE"
        return formatter
    }()
    
    var itemToEdit: DiaryListTableViewItem?
    var date:NSDate = Date() as NSDate
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dairyTitleField.becomeFirstResponder()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBarButton.isEnabled = false
        
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 1))
        let dateData = self.dateFormatter.string(from: date as Date).components(separatedBy: "/")
        let day = dateData[2]
        let month = dateData[1]
        let year = dateData[0]
        let week = dateData[3]
        
        dayLabel.text = day
        monthLabel.text = month
        yearLabel.text = year
        
        if week == "Monday"{
            weekLabel.text = "星期一"
        }else if week == "Tuesday"{
            weekLabel.text = "星期二"
        }else if week == "Wednesday"{
            weekLabel.text = "星期三"
        }else if week == "Thurday"{
            weekLabel.text = "星期四"
        }else if week == "Friday"{
            weekLabel.text = "星期五"
        }else if week == "Saturday"{
            weekLabel.text = "星期六"
        }else{
            weekLabel.text = "星期日"
        }
        
        if let item = itemToEdit{
            title = "编辑日记"
            dayLabel.text = item.Day
            monthLabel.text = item.Month
            yearLabel.text = item.Year
            if item.Week == "Monday"{
                weekLabel.text = "星期一"
            }else if item.Week == "Tuesday"{
                weekLabel.text = "星期二"
            }else if item.Week == "Wednesday"{
                weekLabel.text = "星期三"
            }else if item.Week == "Thurday"{
                weekLabel.text = "星期四"
            }else if item.Week == "Friday"{
                weekLabel.text = "星期五"
            }else if item.Week == "Saturday"{
                weekLabel.text = "星期六"
            }else{
                weekLabel.text = "星期日"
            }
            dairyTitleField.text = item.DairyTitle
            dairyContentField.text = item.DairyContent
            saveBarButton.isEnabled = true
        }
        
    }
    
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save() {
        if let item = itemToEdit {
            item.Day = dayLabel.text!
            item.Year = yearLabel.text!
            item.Month = monthLabel.text!
            item.Week = weekLabel.text!
            if weekLabel.text == "星期一"{
                item.Week = "Monday"
            }else if weekLabel.text == "星期二"{
                item.Week = "Tuesday"
            }else if weekLabel.text == "星期三"{
                item.Week = "Wednesday"
            }else if weekLabel.text == "星期四"{
                item.Week = "Thurday"
            }else if weekLabel.text == "星期五"{
                item.Week = "Friday"
            }else if weekLabel.text == "星期六"{
                item.Week = "Saturday"
            }else{
                item.Week = "Sunday"
            }
            item.DairyTitle = dairyTitleField.text!
            item.DairyContent = dairyContentField.text
            delegate?.dairyDetailViewController(self, didFinishingEditing: item)
            
        } else {
            let item = DiaryListTableViewItem()
            item.Day = dayLabel.text!
            item.Year = yearLabel.text!
            item.Month = monthLabel.text!
            item.Week = weekLabel.text!
            if weekLabel.text == "星期一"{
                item.Week = "Monday"
            }else if weekLabel.text == "星期二"{
                item.Week = "Tuesday"
            }else if weekLabel.text == "星期三"{
                item.Week = "Wednesday"
            }else if weekLabel.text == "星期四"{
                item.Week = "Thurday"
            }else if weekLabel.text == "星期五"{
                item.Week = "Friday"
            }else if weekLabel.text == "星期六"{
                item.Week = "Saturday"
            }else{
                item.Week = "Sunday"
            }
            item.DairyTitle = dairyTitleField.text!
            item.DairyContent = dairyContentField.text
            delegate?.dairyDetailViewController(self, didFinishingAdding: item)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        if newText.length > 0{
            saveBarButton.isEnabled = true
        }else{
            saveBarButton.isEnabled = false
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
