//
//  ViewStudentViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 30/9/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

class ViewStudentViewController: UIViewController {
    
    var student : Student?
    var tableViewInstace:StudentTableViewController?
    
    
    @IBOutlet weak var idField: UILabel!
    @IBOutlet weak var firstNameField: UILabel!
    @IBOutlet weak var lastNameField: UILabel!
    @IBOutlet weak var genderField: UILabel!
    @IBOutlet weak var dobField: UILabel!
    @IBOutlet weak var courseField: UILabel!
    @IBOutlet weak var addressField: UILabel!
    @IBOutlet weak var studentImage: RoundImage!
    @IBOutlet weak var dateField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "\(student?.firstName ?? "") \(student?.lastName ?? "")"
        prepareFields()
    }
    
    @IBAction func editStudent(_ sender: Any) {
        
        let editStudentVC = self.storyboard?.instantiateViewController(withIdentifier:"editStudent") as? EditStudentViewController
        editStudentVC?.student = student
        editStudentVC?.viewStudentInstance = self
        
        self.navigationController?.fadeTo(editStudentVC!)
    }
    
    
    func prepareFields() {
        let id = Int(student!.studentID)
        idField.text = "\(id)"
        firstNameField.text = student?.firstName
        lastNameField.text = student?.lastName
        genderField.text = student?.gender
        addressField.text = student?.address
        courseField.text = student?.course
        studentImage.image = UIImage(data: (student?.image)!)
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let d = df.string(from: (student?.dateOfBirth)!)
        dateField.text = d
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? MapViewController {
            vc.StringLocation = addressField.text
        }
        
        if let vc = segue.destination as? ExamTableViewController {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let studentExams = appDelegate.getStudentsExams(id: Int(student!.studentID))
            
            vc.exams = studentExams
        }
    }
    
    
}

