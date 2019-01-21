//
//  ItemDetailTableViewController.swift
//  Final_DaysMatter
//
//  Created by Alexa Wang on 2019/1/21.
//  Copyright © 2019 Alexa Wang. All rights reserved.
//

import UIKit
// MARK: - <protocol>
protocol ItemDetailViewControllerDelegate: class {
    
    func ItemDetailViewControllerDidCancel(_ controller: ItemDetailTableViewController)
    
    func ItemDetailViewController(_ controller: ItemDetailTableViewController,
                               didFinishAdding item: DaysMatterItem)
    func ItemDetailViewController(_ controller: ItemDetailTableViewController, didFinishEditing item: DaysMatterItem)
}



class ItemDetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    //MARK: - <Outlet & origin defination>
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var discriptionTextField: UITextField!
    
    var itemEditing: DaysMatterItem?
    weak var delegate: ItemDetailViewControllerDelegate?

    // create date picker (参考YouTube教程)
    lazy var datePicker: UIDatePicker = {
        
        let picker = UIDatePicker()
        
        picker.datePickerMode = .date
        
        picker.addTarget(self, action: #selector(datePickerChanged(_:)), for: .valueChanged)
        
        return picker
    }()
    
    
    // create date picker's toolbar(today&done) 参考youtube教程
    lazy var toolbar: UIToolbar = {
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 40))
        
        toolbar.barStyle = .blackTranslucent
        
        toolbar.tintColor = .white
        
        let todayButton = UIBarButtonItem(title: "Today", style: .plain, target: self, action: #selector(todayPressed(_:)))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed(_:)))
        
        let flexButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width/3, height: 40))
        
        label.text = "Select a date"
        
        label.textColor = #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1)
        
        label.textAlignment = .center
        
        label.font = .systemFont(ofSize: 17)
        
        let labelButton = UIBarButtonItem(customView: label)
        
        toolbar.setItems([todayButton, flexButton, labelButton, flexButton, doneButton], animated: true)
        
        return toolbar
    }()
    
    
    //create dateformatter. use to show the date 参考youtube 教程
    lazy var dateFormatter: DateFormatter = {
        
        let formatter = DateFormatter()
        
        //formatter.dateFormat = "YYYY-MM-dd"
        
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter
    }()
    
   
    
    
    
    // MARK: - <load view>
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = toolbar
        
        if let itemEditing = itemEditing {
            title = "修改"
            dateTextField.text = itemEditing.date
            titleTextField.text = itemEditing.title
            discriptionTextField.text = itemEditing.discription
        }else{
            dateTextField.text = dateFormatter.string(from: Date())
        }
        
        navigationItem.largeTitleDisplayMode = .never

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //textField.becomeFirstResponder()
    }
    
    // MARK: - <Private Method>
    
    @IBAction func save(){
        //到manageer 界面
        if let itemEditing = itemEditing {
            itemEditing.title = titleTextField.text!
            itemEditing.discription = discriptionTextField.text!
            itemEditing.date = dateTextField.text!
            delegate?.ItemDetailViewController(self, didFinishEditing: itemEditing)
            
        }else{ // 到list界面
            let item = DaysMatterItem()
            item.title = titleTextField.text!
            item.date = dateTextField.text!
            item.discription = discriptionTextField.text!
            print(item.title)
            delegate?.ItemDetailViewController(self, didFinishAdding: item)
        }
        
    }
    // cancel
    @IBAction func cancel(){
        delegate?.ItemDetailViewControllerDidCancel(self)
        //navigationController?.popViewController(animated:true)
        
    }
    
    // datepicker method （参考youtube教程）
    
    //every change use it
    @objc func datePickerChanged(_ sender: UIDatePicker) {
        
        dateTextField.text = dateFormatter.string(from: sender.date)
    }
    // when pressed today in toolbar
    @objc func todayPressed(_ sender: UIBarButtonItem) {
        
        dateTextField.text = dateFormatter.string(from: Date())
        
        dateTextField.resignFirstResponder()
    }
    //when press done
    @objc func donePressed(_ sender: UIBarButtonItem) {
        
        dateTextField.resignFirstResponder()
    }
    
    

    // MARK: - Table view delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var  num: Int = 1
        
        if section == 0{
            num = 3
        }else if section == 1 {
            num = 2
        }
        return num
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
