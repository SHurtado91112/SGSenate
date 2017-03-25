//
//  AdminLogInViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 3/6/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class AdminLogInViewController: UIViewController, UITextFieldDelegate
{

    @IBOutlet weak var adminUserTextField: UITextField!
    
    @IBOutlet weak var adminPassTextField: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    var ref : FIRDatabaseReference!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.signInBtn.layer.cornerRadius = 4
    
    }
    
    @IBAction func signInPressed(_ sender: Any)
    {
        loginConfig()
    }
    
    func loginConfig()
    {
        if(self.adminUserTextField.text == "" || self.adminPassTextField.text == "")
        {
            let message = "Please, no blanks for email or password."
            self.displayAlert("Error", message: message)
            return
        }
        
        guard let email = self.adminUserTextField.text, let password = self.adminPassTextField.text
            else
        {
            let message = "Invalid email and/or password."
            self.displayAlert("Error", message: message)
            return
        }
        
        self.ref = FIRDatabase.database().reference()
        
        let adminRef = self.ref.child("admin")
        
//        = adminRef.value(forKey: "email") as? String
        adminRef.observe(.value)
        { (snap: FIRDataSnapshot) in
            
            let snapDictionary = snap.value as! [String: String]
            
            let emailRef = snapDictionary["email"]
            let passRef = snapDictionary["passcode"]
            
            if(email == emailRef && password == passRef)
            {
                print("Successful Login")
                
                self.adminUserTextField.text = ""
                self.adminPassTextField.text = ""
                
                self.performSegue(withIdentifier: "validSegue", sender: self)
            }
            else
            {
                let message = "Invalid email and/or password."
                self.displayAlert("Error", message: message)
                return
            }

        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        resignFirstResponder()
        return true
    }

    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(_ title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction((UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        })))
        self.present(alert, animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
