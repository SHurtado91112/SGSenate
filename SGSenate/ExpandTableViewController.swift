//
//  ExpandTableViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 4/1/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class ExpandTableViewController: UITableViewController
{
    
    var bills : [FIRDataSnapshot]! = []
    var billsVote = [NSDictionary]()
    
    var miscs : [FIRDataSnapshot]! = []
    var miscsVote = [NSDictionary]()
    
    var ref : FIRDatabaseReference!
    var user : FIRUser?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        configureAuth()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch(section)
        {
            case 0:
                print("Bills: \(self.bills.count)")
                return self.bills.count
            case 1:
                print("Misc: \(self.miscs.count)")
                return self.miscs.count
            default:
                return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch(indexPath.section)
        {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "voteResultsCell", for: indexPath) as! ExpandResultsCell
            
            
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "voteResultsCell", for: indexPath) as! ExpandResultsCell
            
            
            
            return cell
        default:
            return ExpandResultsCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let header = tableView.dequeueReusableCell(withIdentifier: "sectionResultsCell") as! ExpandResultsCell
        
        switch(section)
        {
            case 0:
                header.leftHandLabel.text = "Bills"
                break;
            default:
                header.leftHandLabel.text = "Misc."
                break;
        }
        return header.contentView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = self.tableView.cellForRow(at: indexPath)
        
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
