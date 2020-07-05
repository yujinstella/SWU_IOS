//
//  SaveViewController.swift
//  Projec2
//
//  Created by SWUCOMPUTER on 2020/07/04.
//  Copyright © 2020 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class SaveViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet var textName: UITextField!
    @IBOutlet var textWhat: UITextField!
    @IBOutlet var textLocation: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func savePress(_ sender: UIButton) {
        let context = self.getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Bucket", in: context)
        // friend record를 새로 생성함
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(textName.text, forKey: "name")
        object.setValue(textWhat.text, forKey: "what")
        object.setValue(textLocation.text, forKey: "location")
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)") }
        // 현재의 View를 없애고 이전 화면으로 복귀
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
