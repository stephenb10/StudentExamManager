//
//  EnrolmentViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 18/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

enum enroleType {
       static let enrol = 1
       static let notEnrolled = 2
   }
   

class EnrolmentViewController: UIViewController {
    
    var enrolledStudents = [Student]()
    var unenrolledStudents = [Student]()
    var exam : Exam?
    var type = 1

    @IBOutlet weak var viewSegmentControl: UISegmentedControl!
    @IBOutlet weak var notEnrolledView: UIView!
    @IBOutlet weak var enrolledView: UIView!
    
    var enInstace : EnrollmentTableViewController?
    var nenInstance : EnrollmentTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        enrolledView.alpha = 1
        notEnrolledView.alpha = 0
        
        type = 1
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
            updateStudents()
    }
    
    
    func updateStudents(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        enrolledStudents.removeAll()
        unenrolledStudents = appDelegate.getStudents()
                
        // Collect the enrolled students for the current exam
        for studentID in exam!.students! {
            var i = 0
            for student in unenrolledStudents {
                if student.studentID == studentID {
                    enrolledStudents.append(student)
                    unenrolledStudents.remove(at: i)
                }
                i += 1
            }
        }
        
        
        enInstace!.students = enrolledStudents
        enInstace!.updateStudents()
        
        nenInstance!.students = unenrolledStudents
        nenInstance!.updateStudents()

    }
    
    @IBAction func viewChanged(_ sender: Any) {
        
        print("changing")
        switch viewSegmentControl.selectedSegmentIndex {
            // enrolled view
        case 0:
            type = enroleType.enrol
            enrolledView.alpha = 1
            notEnrolledView.alpha = 0
            enInstace!.students = enrolledStudents
            enInstace!.updateStudents()
            break
            // not enrolled view
        case 1:
            type = enroleType.notEnrolled
            enrolledView.alpha = 0
            notEnrolledView.alpha = 1
            nenInstance!.students = unenrolledStudents
            nenInstance!.updateStudents()
            
            break
        default:
            break
        }
    }
    
    
    func enrolStudent(id : Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        
        exam?.students?.append(id)
        appDelegate.updateExamStudents(exam: exam!)
        updateStudents()
        
    }
    
    func unenrolStudent(id : Int)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        var i = 0
        for idd in exam!.students! {
            if idd == id {
                exam?.students?.remove(at: i)
                break
            }
        }
        appDelegate.updateExamStudents(exam: exam!)
        
        updateStudents()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "enr"{
            if let vc = segue.destination as? EnrollmentTableViewController {
            vc.students = enrolledStudents
               vc.type = enroleType.enrol
                enInstace = vc
                vc.enrolInstance = self

            }
        }
        if segue.identifier == "nenr" {
            if let vc = segue.destination as? EnrollmentTableViewController {
                nenInstance = vc
                vc.students = unenrolledStudents
                vc.type = enroleType.notEnrolled
                vc.enrolInstance = self
            }

        }
        
    }
    

}
