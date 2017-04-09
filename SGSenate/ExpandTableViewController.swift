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
    var billsResultSnap = [FIRDataSnapshot]()
    var billsVote = NSMutableDictionary()
    
    var miscs : [FIRDataSnapshot]! = []
    var miscResultSnap = [FIRDataSnapshot]()
    var miscVote = NSMutableDictionary()
    
    var results : [FIRDataSnapshot]! = []
    
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
            
            self.configureDB()
            self.tableView.reloadData()
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
        
        //results
        ref.child("result").child("bills").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            self.billsResultSnap.append(snapshot)
            self.populateResults(val: 1)
        }
        
        ref.child("result").child("bills").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            for i in (0...(self.billsResultSnap.count-1))
            {
                self.billsResultSnap[i] = snapshot
            }
            self.populateResults(val: 1)
        }
        
        ref.child("result").child("misc").observe(.childAdded) { (snapshot: FIRDataSnapshot)in
            self.miscResultSnap.append(snapshot)
            self.populateResults(val: 0)
        }
        
        ref.child("result").child("misc").observe(.childChanged) { (snapshot: FIRDataSnapshot) in
            
            for i in (0...(self.miscResultSnap.count-1))
            {
                self.miscResultSnap[i] = snapshot
            }
            
            self.populateResults(val: 0)
        }
    }

    func populateResults(val: Int)
    {
        switch(val)
        {
            case 0:
                
                for i in (0...(self.miscResultSnap.count-1))
                {
                    let snap = miscResultSnap[i]
                    let snapRef = snap.ref
                    var votes : [NSDictionary] = []
                    
                    snapRef.child("votes").queryOrderedByValue().observe(.value, with: { (voteSnap : FIRDataSnapshot) in
                        for rest in voteSnap.children.allObjects as! [FIRDataSnapshot]
                        {
                            votes.append(rest.value as! NSDictionary)
                        }
                        
                        self.reloadMiscVote(votes: votes, id: snap.key)
                    })
                }
                
                break;
            default:
                
                for i in (0...(self.billsResultSnap.count-1))
                {
                    let snap = billsResultSnap[i]
                    let snapRef = snap.ref
                    print(snap.key)
                    var votes : [NSDictionary] = []
                    
                    snapRef.child("votes").queryOrderedByValue().observeSingleEvent(of: .value, with: { (voteSnap : FIRDataSnapshot) in
                        
                        for rest in voteSnap.children.allObjects as! [FIRDataSnapshot]
                        {
                            votes.append(rest.value as! NSDictionary)
                        }
                        
                        self.reloadBillsVote(votes: votes, id: snap.key)
                    })
                }
                
                break;
        }
    }
    
    func reloadBillsVote(votes: [NSDictionary], id: String)
    {
        var yesVotes = 0
        var noVotes = 0
        
        for j in (0...(votes.count-1))
        {
            let voter = votes[j]
            let vote = voter["vote"] as! String
            
            if(vote == "yes")
            {
                yesVotes += 1
            }
            else
            {
                noVotes += 1
            }
        }
        
        self.billsVote[id] = ["votes" : votes, "yes" : yesVotes, "no" : noVotes]
        self.tableView.reloadData()
    }
    
    func reloadMiscVote(votes: [NSDictionary], id: String)
    {
        var yesVotes = 0
        var noVotes = 0
        
        for j in (0...(votes.count-1))
        {
            let voter = votes[j]
            let vote = voter["vote"] as! String
            
            if(vote == "yes")
            {
                yesVotes += 1
            }
            else
            {
                noVotes += 1
            }
        }
        
        self.miscVote[id] = ["votes" : votes, "yes" : yesVotes, "no" : noVotes]
        self.tableView.reloadData()
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
            
            let snap = self.bills[indexPath.row]
            let val = snap.value as! [String:String]
            let topic = val["billName"]
            
            cell.leftHandLabel.text = topic
            
            if(self.billsVote.count-1 < indexPath.row)
            {
                return cell
            }
            
            let billDict = self.billsVote[snap.key] as! NSDictionary
            
            guard let yesResult = billDict["yes"]
            else
            {
                return cell
            }
            
            guard let noResult = billDict["no"]
            else
            {
                return cell
            }
            
            cell.rightHandLabel.text = "Yes: \(String(describing: yesResult)), No: \(String(describing: noResult))"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "voteResultsCell", for: indexPath) as! ExpandResultsCell
            
            let snap = self.miscs[indexPath.row]
            let val = snap.value as! [String:String]
            let topic = val["miscDetail"]
            
            cell.leftHandLabel.text = topic
            
            if(self.miscVote.count-1 < indexPath.row)
            {
                return cell
            }
            
            let miscDict = self.miscVote[indexPath.row] as! NSDictionary
            
            guard let yesResult = miscDict["yes"]
            else
            {
                return cell
            }
            
            guard let noResult = miscDict["no"]
            else
            {
                return cell
            }
            
            cell.rightHandLabel.text = "Yes: \(String(describing: yesResult)), No: \(String(describing: noResult))"
            
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
