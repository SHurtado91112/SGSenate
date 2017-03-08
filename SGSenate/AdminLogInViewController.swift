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
            Util.invokeAlertMethod("Error", strBody: message as NSString, delegate: nil)
            return
        }
        
        guard let email = self.adminUserTextField.text, let password = self.adminPassTextField.text
            else
        {
            let message = "Invalid email and/or password."
            Util.invokeAlertMethod("Error", strBody: message as NSString, delegate: nil)
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
                Util.invokeAlertMethod("Failed Log In", strBody: message as NSString, delegate: nil)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
