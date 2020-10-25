//
//  EditStudentViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 8/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

class EditStudentViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
      var viewStudentInstance:ViewStudentViewController?
      var student:Student?
        
    @IBOutlet weak var idField: UILabel!
    @IBOutlet weak var firstNameField: UITextField!
        @IBOutlet weak var lastNameField: UITextField!
        @IBOutlet weak var genderSelection: UISegmentedControl!
        @IBOutlet weak var addressField: UITextField!
        @IBOutlet weak var courseField: UITextField!
        @IBOutlet weak var date: UIDatePicker!
        @IBOutlet weak var imagePicked: RoundImage!
    // @IBOutlet weak var navBar: UINavigationBar!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            self.navigationItem.setRightBarButton(UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveStudent)), animated: true)
            
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
            view.addGestureRecognizer(tap)
            
            if (student != nil) {
                print("Student selected to edit")
                prepareFields()
            }

            // Do any additional setup after loading the view.
        }
     

    @objc func saveStudent() {
            updateStudent()
            viewStudentInstance?.student = student
            
            self.navigationController?.popViewController(animated: true)
        }
        
        @IBAction func deleteStudent(_ sender: Any) {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alertController.addAction(UIAlertAction(title: "Delete", style: UIAlertAction.Style.destructive, handler: { (UIAlertAction) in
                // Delete record and dismiss view
               
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                              
               
                appDelegate.deleteStudent(id: self.student!.objectID)
                print("student deleted")
                
                let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3] as? StudentTableViewController
                controller?.updateStudents()
                
                self.navigationController?.popToViewController(controller!, animated: true)

            }))
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alertController, animated: true)
        }
        
        
        func prepareFields()
        {
            idField.text = String(Int(student!.studentID))
            firstNameField.text = student?.firstName
            lastNameField.text = student?.lastName
            date.date = student?.dateOfBirth as! Date
            addressField.text = student?.address
            courseField.text = student?.course
            
            switch student?.gender {
            case "Male":
                genderSelection.selectedSegmentIndex = 0
            case "Female":
                genderSelection.selectedSegmentIndex = 1
            default:
                break
            }
            imagePicked.image = UIImage(data: (student?.image)!)
            
        }
    
    func updateStudent()
    {
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
               
        if firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || addressField.text!.isEmpty || courseField.text!.isEmpty
               {
                   let alertController = UIAlertController(title: "Can't add student", message: "Some fields are still empty!", preferredStyle: UIAlertController.Style.alert)
                   alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                   present(alertController, animated: true)
                   return
               }
        
        
        student?.firstName = firstNameField.text
        student?.lastName = lastNameField.text
        student?.dateOfBirth = date.date
        student?.address = addressField.text
        student?.course = courseField.text
        student?.gender = genderSelection.titleForSegment(at: genderSelection.selectedSegmentIndex) ?? "Male"

        guard let imageData = imagePicked.image!.jpegData(compressionQuality: 1) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        student?.image = imageData
        
        
        appDelegate.updateStudent(student: student!)
        
        viewStudentInstance?.student = student
        viewStudentInstance?.tableViewInstace?.updateStudents()
    }
    
    
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] {
            imagePicked.image = (image as! UIImage)
            print("picked image")
            dismiss(animated: true, completion: nil)
        }
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
