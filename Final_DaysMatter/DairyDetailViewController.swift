//
//  DairyDetailViewController.swift
//  Final_DaysMatter
//
//  Created by Taeya on 2019/1/17.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

import UIKit

protocol DairyDetailViewControllerDelegate: class {
    func dairyDetailViewController(_ controller: DairyDetailViewController, didFinishingAdding item: DairyListTableViewItem)
    func dairyDetailViewController(_ controller: DairyDetailViewController, didFinishingEditing item: DairyListTableViewItem)
}

class DairyDetailViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate{
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var dateDataLabel: UILabel!
    
    @IBOutlet weak var dairyTitleField: UITextField!
    @IBOutlet weak var dairyContentField: UITextView!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    weak var delegate: DairyDetailViewControllerDelegate?
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd/EEEE"
        return formatter
    }()
    
    var itemToEdit: DairyListTableViewItem?
    var dateData = String()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dairyTitleField.becomeFirstResponder()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        saveBarButton.isEnabled = false
        
        self.tableView.tableHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 1))
        
        if let item = itemToEdit{
            title = "编辑日记"
            dayLabel.text = item.Day
            monthLabel.text = item.Month
            yearLabel.text = item.Year
            dateDataLabel.text = item.dateData
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
        }else{
            
            let dateDataArray = dateData.components(separatedBy: "/")
            let day = dateDataArray[2]
            let month = dateDataArray[1]
            let year = dateDataArray[0]
            let week = dateDataArray[3]
            
            dayLabel.text = day
            monthLabel.text = month
            yearLabel.text = year
            dateDataLabel.text = dateData
            
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
            item.dateData = dateDataLabel.text!
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
            let item = DairyListTableViewItem()
            item.Day = dayLabel.text!
            item.Year = yearLabel.text!
            item.Month = monthLabel.text!
            item.Week = weekLabel.text!
            item.dateData = dateDataLabel.text!
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
