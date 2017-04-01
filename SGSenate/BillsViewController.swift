//
//  BillsViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SideMenuController
import Firebase
import FirebaseAuthUI

class BillsViewController: UIViewController, SideMenuControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    var bills: [FIRDataSnapshot]! = []
    var ref : FIRDatabaseReference!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        
        self.configureAuth()
        
        tableView?.delegate = self
        tableView.rowHeight = 80
        // Do any additional setup after loading the view.
    }
    
    func configureAuth()
    {
        FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            //initialize master link text field
            self.ref = FIRDatabase.database().reference()
            
            // refresh table data
            self.bills.removeAll(keepingCapacity: false)
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
        
        self.scrollToBottomMessage()
    }
    
    func scrollToBottomMessage()
    {
        if(self.bills.count) == 0 { return }
        
        let bottomBillsIndex = IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0)
        self.tableView.scrollToRow(at: bottomBillsIndex, at: .bottom, animated: true)
        
    }
    
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController)
    {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController)
    {
        print(#function)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.bills != nil)
        {
            print(self.bills.count)
            return self.bills.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath) as! BillCell
        
        let snap = self.bills[indexPath.row]
        let val = snap.value as! [String: String]
        
        cell.link = val["billLink"] ?? "[billLink]"
        cell.name = val["billName"] ?? "[billName]"
        
        cell.billLabel.text = cell.name!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
        
        self.performSegue(withIdentifier: "billsSegue", sender: indexPath)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        
        print(segue.identifier!)
        
        if(segue.identifier! == "billsSegue")
        {
            print("conditional met")
            let vc = segue.destination as! ItemsViewController
            
            let cell = tableView.cellForRow(at: sender as! IndexPath) as! BillCell
            
            print(cell.link)
            
            vc.targetURLString = cell.link
            vc.targetName = cell.name
        }
     }
}
