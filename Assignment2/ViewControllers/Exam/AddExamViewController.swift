//
//  AddExamViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 16/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

class AddExamViewController: UIViewController {
    
    var examTableInstance : ExamTableViewController?

    
    @IBOutlet weak var examName: UITextField!
    @IBOutlet weak var examDate: UIDatePicker!
    @IBOutlet weak var location: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func saveExam(_ sender: Any) {
           let appDelegate = UIApplication.shared.delegate as! AppDelegate
           
           
           
        if examName.text!.isEmpty || location.text!.isEmpty
           {
               self.alert(title: "Can't add exam", message: "Some fields are still empty!")
               return
           }

        appDelegate.storeExam(examName: examName.text!, dateTime: examDate.date, location: location.text!)
        
        examTableInstance?.updateExams()
        print("added exam and updated tabele view")
        
        self.navigationController?.popViewController(animated: true)
           
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
