//
//  StudentTableViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 26/9/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

struct StudentSection {
    let letter : String
    let students : [Student]
}

class StudentTableViewController: UITableViewController {
    
    var students = [Student]()
    var sections = [StudentSection]()
    var selectedStudent : Student?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.separatorStyle = .none
        self.tableView.tableFooterView = UIView()
        
        updateStudents()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        selectedStudent = nil
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    func updateStudents()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        students.removeAll()
        students = appDelegate.getStudents()
        
        let groupedDictionary =  Dictionary(grouping: students) { (student) -> String in
            return String(student.firstName!.first!).uppercased()
        }
        
        // get the keys and sort them
        let keys = groupedDictionary.keys.sorted()
        // map the sorted keys to a struct
        sections = keys.map{ StudentSection(letter: $0, students: groupedDictionary[$0]!.sorted(by: {$0.firstName! > $1.firstName!})) }
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    // Returns the number of sections, if no data display an appropriate message
    override func numberOfSections(in tableView: UITableView) -> Int {
        if students.count > 0
        {
            tableView.backgroundView = nil
            tableView.alwaysBounceVertical = true
        }
        else
        {
            let noDataLabel: UILabel  = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.text          = "No students added yet"
            noDataLabel.textColor     = UIColor.label
            noDataLabel.textAlignment = .center
            tableView.backgroundView  = noDataLabel
            tableView.separatorStyle  = .none
            tableView.alwaysBounceVertical = false
        }
        return sections.count
    }
    
    
    // Return the ammount of students in a section - By letter
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].students.count
    }
    
    // Section title returns the letter for the appropriate section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].letter
    }
    
    // Custom view for the header
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vw = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
        let label = UILabel()
        label.frame = CGRect.init(x: 25, y: 5, width: vw.frame.width-10, height: vw.frame.height-10)
        label.text = sections[section].letter
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell", for: indexPath) as! StudentTableViewCell
        
        let row = indexPath.row
        let section = indexPath.section
        
        let student = sections[section].students[row]
        
        cell.name.text = student.firstName! + " " + student.lastName!
        cell.studentimage.image = UIImage(data: student.image!)
        
        cell.studentimage.layer.cornerRadius = cell.studentimage.frame.height/2
        
        return cell
    }
    
    // Segue to the viewStudentViewController passing the selected student
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        selectedStudent = sections[section].students[row]
        performSegue(withIdentifier: "showStudent", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func viewDidLayoutSubviews() {
        tableView.separatorStyle = .none
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? AddStudentViewController
        {
            vc.tableViewInstance = self
        }
        else if let vc = segue.destination as? ViewStudentViewController
        {
            vc.student = selectedStudent
            vc.tableViewInstace = self
        }
    }
    
    
    
}
