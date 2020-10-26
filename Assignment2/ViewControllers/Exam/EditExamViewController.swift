//
//  EditExamViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 16/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

class EditExamViewController: UIViewController {

    
    var exam : Exam?
    var viewInstance : ViewExamViewController?
    
    @IBOutlet weak var editName: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var dateField: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveExam)), animated: true)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        if (exam != nil)
        {
            prepareFileds()
        }
    }
    
    func prepareFileds()
    {
        editName.text = exam?.examName
        dateField.date = exam?.dateTime as! Date
        location.text = exam?.location
    }
    
    @objc func saveExam()
    {
        updateExam()
        viewInstance?.exam = exam
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func updateExam(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        if editName.text!.isEmpty || location.text!.isEmpty
        {
            self.alert(title: "Can't update exam", message: "Some fields are still empty!")
            return
        }
        
        exam?.examName = editName.text
        exam?.location = location.text
        exam?.dateTime = dateField.date
        
        appDelegate.updateExam(exam: exam!)
        
        viewInstance?.exam = exam
        viewInstance?.prepareExamFields()
        viewInstance?.examTableViewInstance?.updateExams()
    }
    
    @IBAction func deleteExam(_ sender: Any) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (UIAlertAction) in
            // Delete record and dismiss view
           
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            appDelegate.deleteExam(id: self.exam!.objectID)
            
            let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3] as? ExamTableViewController
            controller?.updateExams()
            
            self.navigationController?.popToViewController(controller!, animated: true)
            
        }))
        

        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(alertController, animated: true)
    }

}
