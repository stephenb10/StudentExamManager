//
//  ExamTableViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 16/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

struct ExamSection {
    let header : String
    let exams : [Exam]
}

class ExamTableViewController: UITableViewController {
    
    var selectedExam : Exam?
    var sections = [ExamSection]()
    var exams = [Exam]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        
        if exams.count < 1
        {
            updateExams()
        }
        
        generateSections()
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        if exams.count < 1
        {
            updateExams()
        }
        selectedExam = nil
    }
    
    func generateSections()
    {
        let groupedDictionary =  Dictionary(grouping: exams) { (exam) -> String in
            let now = Date()
            if now >= exam.dateTime!
            {
                return "Previous"
            }
            else
            {
                return "Upcomming"
            }
        }
        
        // get the keys and sort them so upcomming is first
        let keys = groupedDictionary.keys.sorted { (a, b) -> Bool in
            a > b
        }
        // map the sorted keys to a struct
        sections.removeAll()
        sections = keys.map{ ExamSection(header: $0, exams: groupedDictionary[$0]!.sorted(by: {$0.dateTime! > $1.dateTime!})) }
    }
    
    
    func updateExams() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        exams = appDelegate.getExams()
        
        generateSections()
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        if exams.count > 0
        {
            tableView.backgroundView = nil
            tableView.alwaysBounceVertical = true
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No exams added yet"
            noDataLabel.textColor     = UIColor.label
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            tableView.alwaysBounceVertical = false
        }
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sections[section].exams.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    // Custom view for the header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel()
        label.frame = CGRect.init(x: 25, y: 5, width: vw.frame.width-10, height: vw.frame.height-10)
        label.text = sections[section].header
        label.font = UIFont.systemFont(ofSize: 28)
        label.textColor = UIColor.label
        vw.addSubview(label)
        return vw
    }
    
    // Header size
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // The cell data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! ExamTableViewCell
        
        let row = indexPath.row
        let section = indexPath.section
        
        let exam = sections[section].exams[row]
        
        cell.examName.text = exam.examName
        cell.studentNumber.text = String(exam.students!.count)
        
        return cell
    }
    
    
    // Segue to the viewStudentViewController passing the selected student
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedExam = sections[indexPath.section].exams[indexPath.row]
        performSegue(withIdentifier: "showExam", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func viewDidLayoutSubviews() {
        tableView.separatorStyle = .none
    }
           
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let id = sections[indexPath.section].exams[indexPath.row].objectID
            let examCount = sections[indexPath.section].exams.count
            
            // Remove the exam from coreData and re generate the sections
            appDelegate.deleteExam(id: id)
            exams = appDelegate.getExams()
            generateSections()
            
            // If last exam in section delete the whole section
            if examCount <= 1
            {
                let Tablesection = IndexSet(integer: indexPath.section)
                tableView.deleteSections(Tablesection, with: .fade)
            }
            else
            {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let vc = segue.destination as? AddExamViewController {
            vc.examTableInstance = self
        }
        if let vc = segue.destination as? ViewExamViewController {
            vc.exam = selectedExam
            vc.examTableViewInstance = self
        }
        
        
    }
    
    
}
