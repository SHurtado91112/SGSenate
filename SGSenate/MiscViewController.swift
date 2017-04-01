//
//  MiscViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SideMenuController
import Firebase
import FirebaseAuthUI

class MiscViewController: UIViewController, SideMenuControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    var misc: [FIRDataSnapshot]! = []
    var ref : FIRDatabaseReference!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        
        self.configureAuth()
        
        tableView?.delegate = self
        tableView.rowHeight = 80
    }
    
    func configureAuth()
    {
        FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            //initialize master link text field
            self.ref = FIRDatabase.database().reference()
            
            // refresh table data
            self.misc.removeAll(keepingCapacity: false)
            self.tableView.reloadData()
            
            self.configureDB()
        }
    }
    
    func configureDB()
    {
        ref = FIRDatabase.database().reference()
        
        ref.child("misc").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            self.misc.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.misc.count-1, section: 0)], with: .automatic)
            
        }
        
        ref.child("misc").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            for i in (0...(self.misc.count-1))
            {
                self.misc[i] = snapshot
            }
        }
        
        self.scrollToBottomMessage()
    }

    func scrollToBottomMessage()
    {
        if(self.misc.count) == 0 { return }
        
        let bottomMiscIndex = IndexPath(row: self.tableView.numberOfRows(inSection: 0) - 1, section: 0)
        self.tableView.scrollToRow(at: bottomMiscIndex, at: .bottom, animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miscCell", for: indexPath) as! MiscCell
        
        let snap = self.misc[indexPath.row]
        let val = snap.value as! [String: String]
        
        cell.link = val["miscLink"] ?? "[miscLink]"
        cell.name = val["miscDetail"] ?? "[miscDetail]"

        cell.miscLabel.text = cell.name!
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.misc != nil)
        {
            print(self.misc.count)
            return self.misc.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
        
        self.performSegue(withIdentifier: "miscSegue", sender: indexPath)
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
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?)
     {
        print(segue.identifier!)
        
        if(segue.identifier! == "miscSegue")
        {
            print("conditional met")
            let vc = segue.destination as! ItemsViewController
            
            let cell = tableView.cellForRow(at: sender as! IndexPath) as! MiscCell
            
            print(cell.link)
            
            vc.targetURLString = cell.link
            vc.targetName = cell.name
        }
     }
    
}
