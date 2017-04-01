//
//  AdminSettingsViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 3/6/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class AdminSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{

    @IBOutlet weak var agendaLinkTextField: UITextField!
    
    var bills: [(FIRDataSnapshot, String)]! = []
    @IBOutlet weak var billTableView: UITableView!
    @IBOutlet weak var billStepper: UIStepper!
    @IBOutlet weak var billNumLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var miscBottomConstraint: NSLayoutConstraint!
    var containerPos:CGPoint!
    
    var textTag : Int = 0
    var keyboardHeight: CGFloat = 0.0
    
    @IBOutlet weak var miscTableView: UITableView!
    @IBOutlet weak var miscStepper: UIStepper!
    @IBOutlet weak var miscNumLabel: UILabel!
    var misc: [(FIRDataSnapshot, String)]! = []
    
    var user: FIRUser?
    var displayName: String?
    
    var ref : FIRDatabaseReference!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        containerPos = containerView.frame.origin

        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        self.billStepper.layer.cornerRadius = 5.16
        self.miscStepper.layer.cornerRadius = 5.16
        
        self.billTableView.delegate = self
        self.miscTableView.delegate = self
        
        
        self.configureAuth()
        
        self.billStepper.value = Double(self.bills.count)
        self.miscStepper.value = Double(self.misc.count)
        
        self.billNumLabel.text = "\(Int(self.billStepper.value))"
        self.miscNumLabel.text = "\(Int(self.miscStepper.value))"
    }

    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func configureAuth()
    {
        FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            //initialize master link text field
            self.ref = FIRDatabase.database().reference()
            self.ref.child("agenda").observe(.value, with: { (snap: FIRDataSnapshot) in
                let val = snap.value as! [String : String]
                self.agendaLinkTextField.text = val["link"] ?? "[link]"
            })
            
            // refresh table data
            self.bills.removeAll(keepingCapacity: false)
            self.billTableView.reloadData()

            self.misc.removeAll(keepingCapacity: false)
            self.miscTableView.reloadData()
                
            self.configureDB()
        }
    }
    
    func configureDB()
    {
        ref = FIRDatabase.database().reference()
        
        ref.child("bills").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            let key = snapshot.key
            self.bills.append(snapshot, key)
            self.billTableView.insertRows(at: [IndexPath(row: self.bills.count-1, section: 0)], with: .automatic)
            
        }
        ref.child("bills").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            let key = snapshot.key
            
            for i in (0...(self.bills.count-1))
            {
                if(self.bills[i].1 == key)
                {
                    self.bills[i].0 = snapshot
                    break
                }
            }
        }

        ref.child("misc").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            let key = snapshot.key
            self.misc.append(snapshot, key)
            self.miscTableView.insertRows(at: [IndexPath(row: self.misc.count-1, section: 0)], with: .automatic)
        }
        
        ref.child("misc").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            let key = snapshot.key
            
            for i in (0...(self.misc.count-1))
            {
                if(self.misc[i].1 == key)
                {
                    self.misc[i].0 = snapshot
                    break
                }
            }
        }

        self.scrollToBottomMessage()
    }
    
    func updateMasterLink(arg: String)
    {
        ref = FIRDatabase.database().reference()
        
        let childUpdates = ["/agenda/link": arg]
        ref.updateChildValues(childUpdates)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == self.miscTableView)
        {
            self.miscNumLabel.text = "\(self.misc.count)"
            self.miscStepper.value = Double(self.misc.count)
            return self.misc.count
        }
        else if(tableView == self.billTableView)
        {
            self.billNumLabel.text = "\(self.bills.count)"
            self.billStepper.value = Double(self.bills.count)
            return self.bills.count
        }
        else
        {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
    }
    
    @IBAction func billStepped(_ sender: Any)
    {
        let oldVal = Int(self.billNumLabel.text!)
        let newVal = Int(self.billStepper.value)
        self.billNumLabel.text = "\(newVal)"
        
        
        if(oldVal! < newVal)
        {
//            ref.child("bills").childByAutoId().setValue(["billLink":""])
            let keyRef = ref.child("bills").childByAutoId()
            let key = keyRef.key
            
            let childUpdates = ["/bills/\(key)": ["billLink":"", "billName":""]]
            ref.updateChildValues(childUpdates)
        }
        else if(oldVal! > newVal)
        {
            //key to remove
            let key = self.bills[self.bills.count-1].1
            
            //remove child
            ref.child("bills").child(key).removeValue()
            
            //remove row form table
            self.bills.removeLast()
        }
        
        self.billTableView.reloadData()
    }
    
    @IBAction func miscStepped(_ sender: Any)
    {
        let oldVal = Int(self.miscNumLabel.text!)
        let newVal = Int(self.miscStepper.value)
        self.miscNumLabel.text = "\(newVal)"
        
        
        if(oldVal! < newVal)
        {
//            ref.child("misc").childByAutoId().setValue(["miscLink":""])
            let keyRef = ref.child("misc").childByAutoId()
            let key = keyRef.key
            
            let childUpdates = ["/misc/\(key)": ["miscLink":"", "miscDetail":""]]
            ref.updateChildValues(childUpdates)
        }
        else if(oldVal! > newVal)
        {
            //key to remove
            let key = self.misc[self.misc.count-1].1
            
            //remove child
            ref.child("misc").child(key).removeValue()
            
            //remove row form table
            self.misc.removeLast()
        }
        
        self.miscTableView.reloadData()
    }
    
    @IBAction func signOut(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if(tableView == self.miscTableView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "miscLinkCell", for: indexPath) as! MiscLinkCell
            
            let snap = misc[indexPath.row].0
            let key = misc[indexPath.row].1
            
            let value = snap.value as! NSDictionary
            
            cell.miscTextField.text = (value["miscLink"]) as? String ?? "[miscLink]"
            cell.miscDetailTextField.text = (value["miscDetail"]) as? String ?? "[miscDetail]"
            cell.key = key
            cell.miscLabel.text = "Misc. #\(indexPath.row + 1)"

            return cell
        }
        else if(tableView == self.billTableView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "billLinkCell", for: indexPath) as! BillLinkCell
            
            let snap = bills[indexPath.row].0
            let key = bills[indexPath.row].1
            
            let value = snap.value as! NSDictionary
            
            cell.billTextField.text = (value["billLink"]) as? String ?? "[billLink]"
            cell.billNameTextField.text = (value["billName"]) as? String ?? "[billName]"
            cell.key = key
            cell.billLabel.text = "Bill #\(indexPath.row + 1)"

            return cell
        }
        else
        {
            let cell = UITableViewCell()
            return cell
        }
        
        
    }

    // MARK: Scroll Messages
    
    func scrollToBottomMessage()
    {
        if(self.bills.count) == 0 { return }
        
        let bottomBillsIndex = IndexPath(row: self.billTableView.numberOfRows(inSection: 0) - 1, section: 0)
        self.billTableView.scrollToRow(at: bottomBillsIndex, at: .bottom, animated: true)
        
        if(self.misc.count) == 0 { return }
        
        let bottomMiscIndex = IndexPath(row: self.miscTableView.numberOfRows(inSection: 0) - 1, section: 0)
        self.miscTableView.scrollToRow(at: bottomMiscIndex, at: .bottom, animated: true)
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.miscBottomConstraint?.constant = 20.0
            } else {
                
                self.keyboardHeight = (endFrame?.size.height ?? 20)
                
                switch(self.textTag)
                {
                    case 3,4:
                        print("animating")
                        UIView.animate(withDuration: 0.3, animations:
                            {
                                
                                let yPos = self.containerPos.y - (endFrame?.size.height ?? 20)
                                self.containerView.frame.origin = CGPoint(x: 0, y: yPos)
                                
                                
                        })
                        break
                    default:
                        print("not animating")
                        break
                }
                
                
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        UIView.animate(withDuration: 0.3)
        {
            self.containerView.frame.origin = self.containerPos
        }
        
        if(textField == self.agendaLinkTextField)
        {
            self.updateMasterLink(arg: textField.text!)
        }
        
        self.view.endEditing(true)
        resignFirstResponder()
            
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print("Did begin editing.")
        
        UIView.animate(withDuration: 0.3)
        {
            self.containerView.frame.origin = self.containerPos
        }
        
        self.textTag = textField.tag
        
        if(self.textTag == 0)
        {
            self.updateMasterLink(arg: textField.text!)
        }
        
        print("Current Tag: \(self.textTag)")
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
