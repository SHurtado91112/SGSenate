//
//  DebateViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SideMenuController
import Firebase
import FirebaseAuthUI

class DebateViewController: UIViewController, SideMenuControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var liveSessionHeader: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var ref : FIRDatabaseReference!
    
    var debate : [FIRDataSnapshot]! = []
    
    var firstTime = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.configureAuth()
        // Do any additional setup after loading the view.
    }
    
    func configureAuth()
    {
        FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            
            // refresh table data
            self.debate.removeAll(keepingCapacity: false)
            self.tableView.reloadData()

            self.configureDB()
        }
    }
    
    func configureDB()
    {
        ref = FIRDatabase.database().reference()
        
        ref.child("debate").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            
            print("Before Append: \(self.debate.count)")
            self.debate.append(snapshot)
            print("After Append: \(self.debate.count)")
            
            self.tableView.insertRows(at: [IndexPath(row: self.debate.count-1, section: 0)], with: .automatic)
        }
        
        ref.child("debate").observe(.childRemoved) { (snapshot: FIRDataSnapshot) in
            self.debate.removeFirst()
            self.tableView.reloadData()
        }
        
        self.scrollToTopMessage()
    }

    func scrollToTopMessage()
    {
        if(self.debate.count) == 0 { return }
        
        let topIndex = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: topIndex, at: .top, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.debate != nil)
        {
            print(self.debate.count)
            return self.debate.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if(indexPath.row == 0)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "floorCell", for: indexPath) as! FloorCell
            
            let snap = debate[indexPath.row]
            let val = snap.value as! [String : String]
            
            cell.floorLabel.text = val["user"] ?? "[user]"
            
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath) as! QueueCell
            
            let snap = debate[indexPath.row]
            let val = snap.value as! [String : String]
            
            cell.queueLabel.text = "Queue \(indexPath.row):"
            cell.queueUserLabel.text = val["user"] ?? "[user]"
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
    }
    
    func populateDB(text: String)
    {
        ref = FIRDatabase.database().reference()
        
        ref.child("debate").childByAutoId().setValue(["user":text])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let textVal = textField.text!
        
        if(firstTime)
        {
            self.populateDB(text: textVal)
            firstTime = false
        }
        else
        {
            let message = "You have already joined the session once."
            Util.invokeAlertMethod("Sorry", strBody: message as NSString, delegate: self)
        }
        
        
        self.view.endEditing(true)
        resignFirstResponder()
        return true
    }
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController) {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController) {
        print(#function)
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
