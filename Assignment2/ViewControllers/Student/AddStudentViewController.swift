//
//  AddStudentViewController.swift
//  Assignment2
//
//  Created by Stephen Byatt on 27/9/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

class AddStudentViewController: UIViewController, UIImagePickerControllerDelegate,
                                UINavigationControllerDelegate, UITextFieldDelegate {
    
    var tableViewInstance:StudentTableViewController!
    var viewStudentInstance:ViewStudentViewController?
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var idField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var genderSelection: UISegmentedControl!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var courseField: UITextField!
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var leftBarItem: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)
        
        idField.delegate = self
    }
    
    
    @IBAction func saveStudent(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        if idField.text!.isEmpty || firstNameField.text!.isEmpty || lastNameField.text!.isEmpty || addressField.text!.isEmpty || courseField.text!.isEmpty
        {
            self.alert(title: "Can't add student", message: "Some fields are still empty!")
            return
        }
        
        let id = Int(idField.text!) ?? -1
        
        if !appDelegate.isIDUnique(id: id)
        {
            self.alert(title: "Can't add student", message: "This ID is already in use!")
            return
        }
        
        guard let imageData = imagePicked.image!.jpegData(compressionQuality: 1) else {
            // handle failed conversion
            print("jpg error")
            return
        }
        
        let g = genderSelection.titleForSegment(at: genderSelection.selectedSegmentIndex) ?? "Male"
        
        appDelegate.storeStudent(id: id, firstName: firstNameField.text!, lastName: lastNameField.text!, dateOfBirth: date.date, gender: g, address: addressField.text!, course: courseField.text!, imageData: imageData as NSData)
        tableViewInstance.updateStudents()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    // Does not allow letters to be entered and no more than 10 characters
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var value = true
        let maxLength = 10
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length >= maxLength
        {
            value = false
        }
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil
        {
            value = false
        }
        
        return value 
        
    }
    
}
