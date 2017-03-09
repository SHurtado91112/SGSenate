//
//  AdminDebateTableViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 3/9/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class AdminDebateTableViewController: UITableViewController
{

    var ref : FIRDatabaseReference!
    var debate : [FIRDataSnapshot]! = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.configureAuth()
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
            self.debate.append(snapshot)
            self.tableView.insertRows(at: [IndexPath(row: self.debate.count-1, section: 0)], with: .automatic)
        }
        
        ref.child("debate").observe(.childRemoved) { (snapshot: FIRDataSnapshot) in
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
    
    @IBAction func updateQueue(_ sender: Any)
    {
        if(self.debate.count > 0)
        {
            ref = FIRDatabase.database().reference()
            
            let key = self.debate[0].key
            
            ref.child("debate").child(key).removeValue()
            
            self.debate.removeFirst()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(self.debate != nil)
        {
            return self.debate.count
        }
        else
        {
            return 0
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
