//
//  LogInViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class LogInViewController: UIViewController, UITextFieldDelegate
{
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var signInBtn: UIButton!
    var signInPos : CGPoint!
    
    @IBOutlet weak var dontBtn: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var effectView: UIVisualEffectView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var SignUp = false
    
    var ref : FIRDatabaseReference!
    var user : FIRUser?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        self.nameLabel.isHidden = false
        self.nameTextField.isHidden = false
        
        self.nameLabel.alpha = 0
        self.nameTextField.alpha = 0
        
        self.signInPos = self.signInBtn.frame.origin
        
        self.effectView.isHidden = false
        self.effectView.alpha = 0
        
        self.signInBtn.layer.cornerRadius = 4
        self.dontBtn.layer.cornerRadius = 4
        
        self.authConfig()
    }
    
    func authConfig()
    {
        FIRAuth.auth()?.addStateDidChangeListener({ (auth: FIRAuth, user: FIRUser?) in
            if let activeUser = user
            {
                if(self.user != activeUser)
                {
                    self.user = activeUser
                   self.performSegue(withIdentifier: "verifiedSegue", sender: self)
                }
            }
        })
    }
    
    @IBAction func signInPressed(_ sender: Any)
    {
        if(self.usernameTextField.text == "" || self.passwordTextField.text == "" || (SignUp  && self.nameTextField.text == ""))
        {
            let message = "Please, no blanks for email, name, or password."
            self.displayAlert("Error", message: message)
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
            let message = "Invalid email and/or password."
            self.displayAlert("Error", message: message)
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            if(error != nil)
            {
                print("Error: \(error?.localizedDescription)")
                
                let message = (error?.localizedDescription)!
                self.displayAlert("Error", message: message)
                
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
                    let message = (error?.localizedDescription)!
                    self.displayAlert("Error", message: message)
                    return
                }

                print("Saved User")
                self.usernameTextField.text = ""
                self.passwordTextField.text = ""
                
                self.performSegue(withIdentifier: "verifiedSegue", sender: self)
            })
            
        })
    }
    
    func loginConfig()
    {
        guard let email = self.usernameTextField.text, let password = self.passwordTextField.text
            else
        {
            let message = "Invalid email and/or password."
            self.displayAlert("Error", message: message)
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            
            if(error != nil)
            {
                print("Error: \((error?.localizedDescription)!)")
                let message = (error?.localizedDescription)!
                self.displayAlert("Error", message: message)
                return
            }

            print("Logged In User")
            
            self.usernameTextField.text = ""
            self.passwordTextField.text = ""
            
            self.performSegue(withIdentifier: "verifiedSegue", sender: self)
        })
    }
    
    @IBAction func dontPressed(_ sender: Any)
    {
        SignUp = !SignUp
        
        if(self.SignUp)
        {
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.nameLabel.alpha = 1
                    self.nameTextField.alpha = 1
                    
                    self.signInBtn.frame.origin.y = self.signInBtn.frame.origin.y + 2*(self.nameTextField.frame.height)
            })
            
            self.signInBtn.setTitle("Sign Up!",for: .normal)
            self.dontBtn.setTitle("Already have an account?",for: .normal)
        }
        else
        {
            UIView.animate(withDuration: 0.3, animations:
                {
                    self.nameLabel.alpha = 0
                    self.nameTextField.alpha = 0
                    
                    self.signInBtn.frame.origin = self.signInPos
            })
            
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
