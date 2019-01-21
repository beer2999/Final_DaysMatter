//
//  ItemManagerViewController.swift
//  Final_DaysMatter
//
//  Created by Alexa Wang on 2019/1/21.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

import UIKit

protocol ItemManagerViewControllerDelegate: class {

    func ItemManagerViewControllerDidCancel(_ controller: ItemManagerViewController)
    
    func ItemManagerViewController(_ controller: ItemManagerViewController,
                               didFinishTopping item: DaysMatterItem)
    func ItemManagerViewController(_ controller: ItemManagerViewController, didFinishEditing item: DaysMatterItem)

}

class ItemManagerViewController: UIViewController, ItemDetailViewControllerDelegate {
    
    
    
    var itemToEdit: DaysMatterItem?
    var countNum : String?
    var discription: String?
    weak var delegate: ItemManagerViewControllerDelegate?

    @IBOutlet weak var managerStatus: UILabel!
    @IBOutlet weak var managerTitle: UILabel!
   
    @IBOutlet weak var managerRealStatus: UILabel!
    @IBOutlet weak var managerCount: UILabel!
    @IBOutlet weak var managerDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let itemToEdit = itemToEdit{
            managerDate.text = itemToEdit.date
            managerTitle.text = itemToEdit.title
            managerCount.text = countNum
            if itemToEdit.status == 2 {
                managerStatus.text = "已经"
            }else if itemToEdit.status == 1{
                managerStatus.text = "还有"
            }
            
        }

        // Do any additional setup after loading the view.
    }
    
    @IBAction func topped(){
        if managerRealStatus.text == "0" {
            if let item = itemToEdit{
                item.title = managerTitle.text!
                item.date = managerDate.text!
                item.discription = discription
                
                delegate?.ItemManagerViewController(self, didFinishTopping: item)
            }
        }else{
            if let item = itemToEdit{
                item.status = Int(managerRealStatus.text!)!
                item.title = managerTitle.text!
                item.date = managerDate.text!
                item.discription = discription
                delegate?.ItemManagerViewController(self, didFinishTopping: item)
                //delegate?.ItemManagerViewController(self, didFinishEditing: item)
            }
            
        }
    
    }
    @IBAction func back(){
        if managerRealStatus.text == "0" {
            delegate?.ItemManagerViewControllerDidCancel(self)
        }else{
            if let item = itemToEdit{
                item.title = managerTitle.text!
                item.date = managerDate.text!
                item.discription = discription
                
                delegate?.ItemManagerViewController(self, didFinishEditing: item)
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditDaysMatter" {
            
            let controller = segue.destination as! ItemDetailTableViewController
            controller.delegate = self 
            controller.itemEditing = itemToEdit
            //print(itemToEdit!.title)
        }
    }
    
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailTableViewController) {
        navigationController?.popViewController(animated:true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailTableViewController, didFinishAdding item: DaysMatterItem) {
        navigationController?.popViewController(animated:true)
    }
    
    func ItemDetailViewController(_ controller: ItemDetailTableViewController, didFinishEditing item: DaysMatterItem) {
        managerTitle.text = item.title
        managerDate.text = item.date
        discription = item.discription
        managerRealStatus.text = "3"
        let myFormatter = DateFormatter()
        myFormatter.dateFormat = "MMM d, yyyy"
        let myDate = myFormatter.date(from: item.date)
        // find today
        let currentDate: NSDate = NSDate()
        // compare the date is passing or coming
        if myDate?.compare(currentDate as Date) == .orderedAscending
        {
            // it pass
            managerStatus.text = "已经"
            item.status = 2
            //managerRealStatus.text = "2"
            if myDate != nil{
                // 计算 倒数天数
                let goDate: NSDate = myDate! as NSDate
                let interval: TimeInterval = goDate.timeIntervalSince(currentDate as Date)
                let second = Int(round(interval))
                let days = -second / 24 / 3600
                managerCount.text = "\(days)"
            }
        }
        if myDate?.compare(currentDate as Date) == .orderedDescending
        {
            //it come
            managerStatus.text = "还有"
        
            item.status = 1
            //managerRealStatus.text = "1"
            if myDate != nil{
                // 计算 倒数天数
                let goDate: NSDate = myDate! as NSDate
                //let currentDate: NSDate = NSDate()
                let interval: TimeInterval = goDate.timeIntervalSince(currentDate as Date)
                let second = Int(round(interval))
                let days = second / 24 / 3600
                
                managerCount.text = "\(days)"
            }
        }
        
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
