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
        var exams = [Exam]()
        
        let fetchRequest = NSFetchRequest<Exam>(entityName: "Exam")
        
        do {
            let fetchedResults = try getContext().fetch(fetchRequest)
            print("\(fetchedResults.count) returned exams")
            
            exams = fetchedResults
        } catch {
            print("Error with request: \(error)")
        }
        
        return exams
    }
    
    
    
    func updateExam(exam : Exam)  {
        let obj = getContext().object(with: exam.objectID)
        if obj != nil {
            obj.setValue(exam.examName, forKey: "examName")
            obj.setValue(exam.location, forKey: "location")
            obj.setValue(exam.dateTime, forKey: "dateTime")
            saveContext()
            print("Updated Exam ")
        }
        
    }
    
    func updateExamStudents(exam : Exam) {
        let obj = getContext().object(with: exam.objectID)
        
            obj.setValue(exam.students, forKey: "students")
            saveContext()
            print("Updated Exam ")
        
    }
    
    func deleteExam(id : NSManagedObjectID)
    {
        let obj = getContext().object(with: id)
        getContext().delete(obj)
        saveContext()
        
    }
    
    
    
    func storeStudent (id: Int, firstName: String, lastName: String, dateOfBirth: Date, gender: String, address: String, course: String, imageData:NSData) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Student", in: context)
        
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(id, forKey: "studentID")
        transc.setValue(lastName, forKey: "lastName")
        transc.setValue(firstName, forKey: "firstName")
        transc.setValue(dateOfBirth, forKey: "dateOfBirth")
        transc.setValue(address, forKey: "address")
        transc.setValue(gender, forKey: "gender")
        transc.setValue(course, forKey: "course")
        transc.setValue(imageData, forKey: "image")
        
        saveContext()
    }
    
    func isIDUnique(id : Int) -> Bool {
        
        let fetchRequest = NSFetchRequest<Student>(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "studentID == \(id)")
        do {
            let count = try getContext().count(for: fetchRequest)
            print("Students with id \(id) : \(count)")
            return (count >= 1) ? false : true
        } catch{
            print("Error with request: \(error)")
        }
        fetchRequest.predicate = NSPredicate(format: "studentID == \(id)")
        return false
    }
    
    func getStudent (id : Int) -> Student {
        
        let fetchRequest = NSFetchRequest<Student>(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "studentID == \(id)")
        var student = Student()
        
        do {
            let fetchedResults = try getContext().fetch(fetchRequest)
            if let aStudent = fetchedResults.first {
                student = aStudent
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        return student;
    }
    
    func deleteStudent (id : NSManagedObjectID) {
        let obj = getContext().object(with: id)
        getContext().delete(obj)
        saveContext()
        
    }
    
    func getStudents () -> [Student] {
        var students = [Student]()
        
        let fetchRequest = NSFetchRequest<Student>(entityName: "Student")
        
        do {
            let fetchedResults = try getContext().fetch(fetchRequest)
            print("\(fetchedResults.count) returned students")
            
            for student in fetchedResults {
                students.append(student)
            }
        } catch {
            print("Error with request: \(error)")
        }
        
        return students
    }
    
    func updateStudent(student: Student) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        fetchRequest.predicate = NSPredicate(format: "studentID == \(student.studentID)")
        do {
            let fetchedResults = try getContext().fetch(fetchRequest) as? [NSManagedObject]
            print("count of fetched results \(fetchedResults?.count)")
            if fetchedResults!.count > 0 {
                fetchedResults![0].setValue(student.studentID, forKey: "studentID")
                fetchedResults![0].setValue(student.lastName, forKey: "lastName")
                fetchedResults![0].setValue(student.firstName, forKey: "firstName")
                fetchedResults![0].setValue(student.dateOfBirth, forKey: "dateOfBirth")
                fetchedResults![0].setValue(student.address, forKey: "address")
                fetchedResults![0].setValue(student.gender, forKey: "gender")
                fetchedResults![0].setValue(student.course, forKey: "course")
                fetchedResults![0].setValue(student.image, forKey: "image")
                saveContext()
                print("Updated student ")
            }
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func removeRecords () {
        let context = getContext()
        // delete everything in student table
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Student")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error")
        }
    }
    
}

