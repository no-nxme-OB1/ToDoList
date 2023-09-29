//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Given Maphiri on 2023/07/18.
//

import UIKit

class ToDoDetailTableViewController: UITableViewController {

    var toDo: ToDo?
    
    //Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var isCompleteButton: UIButton!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var isDatePickerHidden = true
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 2)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentDueDate: Date
        
        if let toDo = toDo {
            navigationItem.title = "To-Do"
            titleTextField.text = toDo.title
            isCompleteButton.isSelected = toDo.isComplete
            currentDueDate = toDo.dueDate
            notesTextView.text = toDo.notes
        } else{
            currentDueDate = Date().addingTimeInterval(24 * 60 * 60)
        }

        
        dueDatePicker.date = currentDueDate
        updateDueDateLabel(date: dueDatePicker.date)
        updateSaveButtonState()
       
    }
    
    // only alows you to save a reminder when a title is set.
    func updateSaveButtonState() {
        let shouldEnableSaveButton = titleTextField.text?.isEmpty == false
        saveButton.isEnabled = shouldEnableSaveButton
    }
    
    // updates the due date label to the date pickers.
    func updateDueDateLabel(date: Date) {
        dueDateLabel.text = date.formatted(.dateTime.day().month(.defaultDigits).year(.twoDigits).hour().minute())
    }
    

    @IBAction func textEditingChanged(_ sender: UITextField) {
        
        updateSaveButtonState()
    }
    
    @IBAction func returnPressed(_ sender: UITextField) {
        //exits the keyboard when the return button is pressed.
        sender.resignFirstResponder()
    }
    
    // switches between the default state and selected state of the isComplete button.
    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
        
        isCompleteButton.isSelected.toggle()
    }
    
    
    // changes the label along with the changes in the date picker.
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        
        updateDueDateLabel(date: sender.date)
    }
    
    // MARK: - table view data source
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath where isDatePickerHidden == true:
            return 0
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return 216
        case notesIndexPath:
            return 200
        default:
            return UITableView.automaticDimension
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == dateLabelIndexPath {
            isDatePickerHidden.toggle()
            updateDueDateLabel(date: dueDatePicker.date)
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    
    // MARK: - Navigation

     
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         super.prepare(for: segue, sender: sender)
         
         guard segue.identifier == "saveUnwind" else {return}
         
         let title = titleTextField.text!
         let isComplete = isCompleteButton.isSelected
         let dueDate = dueDatePicker.date
         let notes = notesTextView.text
         
         // updates toDo if its not nil.
         if toDo != nil {
             toDo?.title = title
             toDo?.isComplete = isComplete
             toDo?.dueDate = dueDate
             toDo?.notes = notes
         } else {
             toDo = ToDo(title: title, isComplete: isComplete, dueDate: dueDate, notes: notes)
         }
     }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
