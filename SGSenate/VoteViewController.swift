//
//  VoteViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SideMenuController
import DLRadioButton
import Firebase
import FirebaseAuthUI

class VoteViewController: UIViewController, SideMenuControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var writeOptionTextField: UITextField!
    
    var bills : [FIRDataSnapshot]! = []
    var miscs : [FIRDataSnapshot]! = []
    
    var ref : FIRDatabaseReference!
    var user : FIRUser?
    
    var origPos: CGPoint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.origPos = self.view.frame.origin
        self.writeOptionTextField.delegate = self
        
        sideMenuController?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        configureAuth()
    }
    
    func configureAuth()
    {
        FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            //initialize master link text field
            self.ref = FIRDatabase.database().reference()
            
            // refresh table data
            self.bills.removeAll(keepingCapacity: false)
            self.miscs.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
            
            self.configureDB()
        }
    }
    
    func configureDB()
    {
        ref = FIRDatabase.database().reference()
        
        ref.child("bills").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            self.bills.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.bills.count-1, section: 0)], with: .automatic)
        }
        
        ref.child("bills").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            for i in (0...(self.bills.count-1))
            {
                self.bills[i] = snapshot
            }
        }
        
        ref.child("misc").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            self.miscs.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.miscs.count-1, section: 1)], with: .automatic)
            
        }
        
        ref.child("misc").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            for i in (0...(self.miscs.count-1))
            {
                self.miscs[i] = snapshot
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! VoteHeader
        
        switch(section)
        {
        case 0:
            header.detailLabel.text = "Bills"
            break;
        case 1:
            header.detailLabel.text = "Misc."
            break;
        default:
            break;
        }
        
        return header.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch(section)
        {
            case 0:
                //bills
            return self.bills.count
            case 1:
                //misc
            return self.miscs.count
        default:
                //write in
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = VoteCell()
        
        switch(indexPath.section)
        {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteCell
                let snap = bills[indexPath.row]
                let val = snap.value as! [String:String]
                
                cell.detailLabel.text = val["billName"] ?? "[billName]"
                
                cell.indexPath = indexPath
                cell.cellSnap = snap
                
//                let yesRadTap = CustomTap(target: self, action: #selector(yesBillTarget(_:)))
//                yesRadTap.indexPath = indexPath
//                
//                cell.yesRadio.addGestureRecognizer(yesRadTap)
//                
//                let noRadTap = CustomTap(target: self, action: #selector(noBillTarget(_:)))
//                noRadTap.indexPath = indexPath
//                
//                cell.noRadio.addGestureRecognizer(noRadTap)
                break;
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteCell
                let snap = miscs[indexPath.row]
                let val = snap.value as! [String:String]
                
                cell.detailLabel.text = val["miscDetail"] ?? "[miscDetail]"
                
                cell.indexPath = indexPath
                cell.cellSnap = snap
                break;
            default:
                break;
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.selectionStyle = .none
        
    }
    
    func keyboardNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                
            } else {
                
                print("animating")
                UIView.animate(withDuration: 0.3, animations:
                    {
                        
                        let yPos = self.origPos.y - (endFrame?.size.height ?? 20)
                        self.view.frame.origin = CGPoint(x: 0, y: yPos)
                        
                        
                })
                
                
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
        UIView.animate(withDuration: 0.15)
        {
            self.view.frame.origin = self.origPos
        }
        
        self.view.endEditing(true)
        resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print("Did begin editing.")
        
        UIView.animate(withDuration: 0.15)
        {
            self.view.frame.origin = self.origPos
        }

    }
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController)
    {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController)
    {
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
