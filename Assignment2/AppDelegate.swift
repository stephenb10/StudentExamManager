//
//  AppDelegate.swift
//  Assignment2
//
//  Created by Stephen Byatt on 26/9/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Assignment2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // all functions for core data are here
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Core data exam functions
    
    func storeExam(examName: String, dateTime : Date, location : String)
    {
        let context = getContext()
        
        let entity = NSEntityDescription.entity(forEntityName: "Exam", in: context)
        
        let obj = NSManagedObject(entity: entity!, insertInto: context)
        let students = [Int]()
        obj.setValue(examName, forKey: "examName")
        obj.setValue(dateTime, forKey: "dateTime")
        obj.setValue(location, forKey: "location")
        obj.setValue(students, forKey: "students")
        
        saveContext()
        
    }
    
    func getExams() -> [Exam] {
        let exams = [Exam]()
        
        let fetchRequest = NSFetchRequest<Exam>(entityName: "Exam")
        
        do {
            let fetchedResults = try getContext().fetch(fetchRequest)
            return fetchedResults
        } catch {
            print("Error with request: \(error)")
        }
        
        return exams
    }
    
    
    func updateExam(exam : Exam)  {
        let obj = getContext().object(with: exam.objectID)
        obj.setValue(exam.examName, forKey: "examName")
        obj.setValue(exam.location, forKey: "location")
        obj.setValue(exam.dateTime, forKey: "dateTime")
        saveContext()
    }
    
    func updateExamStudents(id : NSManagedObjectID, students : [Int]) {
        let obj = getContext().object(with: id)
        obj.setValue(students, forKey: "students")
        saveContext()
    }
    
    func deleteExam(id : NSManagedObjectID)
    {
        let obj = getContext().object(with: id)
        getContext().delete(obj)
        saveContext()
        
    }
    
    // MARK: - Core Data student functions
    
    func storeStudent (id: Int, firstName: String, lastName: String, dateOfBirth: Date, gender: String, address: String, course: String, imageData:NSData) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Student", in: context)
        
        let obj = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        obj.setValue(id, forKey: "studentID")
        obj.setValue(lastName, forKey: "lastName")
        obj.setValue(firstName, forKey: "firstName")
        obj.setValue(dateOfBirth, forKey: "dateOfBirth")
        obj.setValue(address, forKey: "address")
        obj.setValue(gender, forKey: "gender")
        obj.setValue(course, forKey: "course")
        obj.setValue(imageData, forKey: "image")
        
        saveContext()
    }
    
    
    func getStudentsExams(id: Int) -> [Exam] {
        var studentExams = [Exam]()
        let exams = getExams()
        for exam in exams {
            for i in exam.students! {
                if i == id
                {
                    studentExams.append(exam)
                }
            }
        }
        
        return studentExams
    }
    
    /// Checks if ID is unique to store student in core data
    /// - Parameter id: the ID to check if unique
    /// - Returns: false if at least 1 student is returned from the query, else true if 0 students returned
    func isIDUnique(id : Int) -> Bool {
        let fetchRequest = NSFetchRequest<Student>(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "studentID == \(id)")
        do {
            let count = try getContext().count(for: fetchRequest)
            return (count >= 1) ? false : true
        } catch{
            print("Error with request: \(error)")
        }
        return false
    }
    
    func deleteStudent (id : NSManagedObjectID) {
        let obj = getContext().object(with: id)
        let sid = obj.value(forKey: "studentID")
        
        // Unenroll student from all exams
        let studentExams = getStudentsExams(id: sid as! Int)
        for exam in studentExams {
            for i in 0...exam.students!.count {
                if exam.students![i] == sid as! Int {
                    exam.students?.remove(at: i)
                    updateExamStudents(id: exam.objectID, students: exam.students!)
                    break
                }
            }
        }
        
        getContext().delete(obj)
        saveContext()
    }
    
    // Return all students in an array
    func getStudents () -> [Student] {
        let students = [Student]()
        
        let fetchRequest = NSFetchRequest<Student>(entityName: "Student")
        
        do {
            let fetchedResults = try getContext().fetch(fetchRequest)
            return fetchedResults
        } catch {
            print("Error with request: \(error)")
        }
        
        return students
    }
    
    func updateStudent(student: Student) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "studentID == \(student.studentID)")
        do {
            let obj = try getContext().fetch(fetchRequest) as? [NSManagedObject]
            if obj!.count > 0 {
                obj![0].setValue(student.studentID, forKey: "studentID")
                obj![0].setValue(student.lastName, forKey: "lastName")
                obj![0].setValue(student.firstName, forKey: "firstName")
                obj![0].setValue(student.dateOfBirth, forKey: "dateOfBirth")
                obj![0].setValue(student.address, forKey: "address")
                obj![0].setValue(student.gender, forKey: "gender")
                obj![0].setValue(student.course, forKey: "course")
                obj![0].setValue(student.image, forKey: "image")
                saveContext()
            }
        } catch {
            print("Error with request: \(error)")
        }
    }
}

