//
//  ViewExamViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 16/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

class ViewExamViewController: UIViewController {

    var examTableViewInstance : ExamTableViewController?
    
    var exam : Exam?
    
    @IBOutlet weak var examName: UILabel!
    @IBOutlet weak var examDate: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var enrolled: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "\(exam?.examName! ?? "")"

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        prepareExamFields()
    }
    
    
    func prepareExamFields(){
        examName.text = exam?.examName
        location.text = exam?.location
        let students = exam?.students!
        enrolled.text = String(students!.count) + " Enrolled Students"
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy"
        let d = df.string(from: (exam?.dateTime)!)
        examDate.text = d
    }
    

    @IBAction func editExam(_ sender: Any) {
        let editVC = self.storyboard?.instantiateViewController(withIdentifier:"editExam") as? EditExamViewController
        editVC?.exam = exam
        editVC?.viewInstance = self
               
               
        self.navigationController?.fadeTo(editVC!)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? EnrolmentViewController {
            vc.exam = exam
        }
    
        
    }
    

}
