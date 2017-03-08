//
//  LogInViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SideMenuController
import Firebase
import FirebaseAuthUI

class LogInViewController: UIViewController, SideMenuControllerDelegate, UITextFieldDelegate
{
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    
    @IBOutlet weak var dontBtn: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var effectView: UIVisualEffectView!
    
    var SignUp = false
    
    var ref : FIRDatabaseReference!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.effectView.isHidden = false
        self.effectView.alpha = 0
        
        sideMenuController?.delegate = self
        
        self.signInBtn.layer.cornerRadius = 4
        self.dontBtn.layer.cornerRadius = 4
    }
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    @IBAction func signInPressed(_ sender: Any)
    {
        if(self.usernameTextField.text == "" || self.usernameTextField.text == "")
        {
            let message = "Please, no blanks for email or password."
            Util.invokeAlertMethod("Error", strBody: message as NSString, delegate: nil)
            return
        }
        
        if(SignUp)
        {
            registerConfig()
        }
        else
        {
            loginConfig()
        }
    }
    
    func registerConfig()
    {
        
        guard let email = self.usernameTextField.text, let password = self.passwordTextField.text
        else
        {
            let message = "Invalid email/password."
            Util.invokeAlertMethod("Error", strBody: message as NSString, delegate: nil)
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            if(error != nil)
            {
                print("Error: \(error?.localizedDescription)")
                
                let message = error?.localizedDescription
                
                Util.invokeAlertMethod("Error", strBody: message! as NSString, delegate: nil)
                
                return
            }
            
            guard let uid = user?.uid
            else
            {
                return
            }
            
            //else
            self.ref = FIRDatabase.database().reference()
            
            let userRef = self.ref.child("users").child(uid)
            
            let values = ["email" : email]
            
            userRef.updateChildValues(values, withCompletionBlock: { (error: Error?, tempRef: FIRDatabaseReference) in
                
                if(error != nil)
                {
                    print("Error: \(error?.localizedDescription)")
                    return
                }

                print("Saved User")
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
                
                self.performSegue(withIdentifier: "validVoterSegue", sender: self)
            })
            
        })
    }
    
    func loginConfig()
    {
        guard let email = self.usernameTextField.text, let password = self.passwordTextField.text
            else
        {
            let message = "Invalid email/password."
            Util.invokeAlertMethod("Error", strBody: message as NSString, delegate: nil)
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            
            if(error != nil)
            {
                print("Error: \(error?.localizedDescription)")
                return
            }

            print("Logged In User")
            
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            
            self.performSegue(withIdentifier: "validVoterSegue", sender: self)
        })
    }
    
    @IBAction func dontPressed(_ sender: Any)
    {
        SignUp = !SignUp
        
        if(self.SignUp)
        {
            self.signInBtn.setTitle("Sign Up!",for: .normal)
            self.dontBtn.setTitle("Already have an account?",for: .normal)
        }
        else
        {
            self.signInBtn.setTitle("Sign In!",for: .normal)
            self.dontBtn.setTitle("Don't have an account?",for: .normal)
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            self.effectView.alpha = 1
        }) { (Bool) in
            UIView.animate(withDuration: 0.3, animations: {
                self.effectView.alpha = 0
            })
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
