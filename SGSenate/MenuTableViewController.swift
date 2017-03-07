//
//  MenuTableViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    
    let segues = ["embedInitialCenterController", "billsCenter", "debateCenter", "miscCenter", "logCenter", "adminCenter"]
    
    private var previousIndex: NSIndexPath?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return segues.count
    }

    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath)
    {
        print("Yes : \(segues[indexPath.row])")
        
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.selectionStyle = .none
        
        if let index = previousIndex
        {
            print("Deselect : \(segues[indexPath.row])")
            tableView.deselectRow(at: index as IndexPath, animated: true)
        }
        
        print("Perform : \(segues[indexPath.row])")
        sideMenuController?.performSegue(withIdentifier: segues[indexPath.row], sender: nil)
        previousIndex = indexPath as NSIndexPath?
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = menuViewCell()
        
        if(indexPath.row % 2 == 0)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! menuViewCell
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "menuCell2") as! menuViewCell
        }
        
        switch(indexPath.row)
        {
            case 0:
                cell.viewText = "Agenda"
                cell.viewName.text = cell.viewText
                cell.viewImg = (UIImage(named: "Checklist Filled-50")?.withRenderingMode(.alwaysTemplate))!
                cell.cellImgView.image = cell.viewImg
                break;
            case 1:
                cell.viewText = "Bills"
                cell.viewName.text = cell.viewText
                cell.viewImg = (UIImage(named: "Magical Scroll Filled-50")?.withRenderingMode(.alwaysTemplate))!
                cell.cellImgView.image = cell.viewImg
                break;
            case 2:
                cell.viewText = "Public Debate"
                cell.viewName.text = cell.viewText
                cell.viewImg = (UIImage(named: "Podium Without Speaker Filled-50")?.withRenderingMode(.alwaysTemplate))!
                cell.cellImgView.image = cell.viewImg
                break;
            case 3:
                cell.viewText = "Misc."
                cell.viewName.text = cell.viewText
                cell.viewImg = (UIImage(named: "Box Filled Filled-50")?.withRenderingMode(.alwaysTemplate))!
                cell.cellImgView.image = cell.viewImg
                break;
            case 4:
                cell.viewText = "Voting Log In"
                cell.viewName.text = cell.viewText
                cell.viewImg = (UIImage(named: "Login Rounded Right Filled-50")?.withRenderingMode(.alwaysTemplate))!
                cell.cellImgView.image = cell.viewImg
                break;
            
            case 5:
                cell.viewText = "Admin Log In"
                cell.viewName.text = cell.viewText
                cell.viewImg = (UIImage(named: "Lock Filled-50")?.withRenderingMode(.alwaysTemplate))!
                cell.cellImgView.image = cell.viewImg
                break;
            
            
            default:
                break;
            
        }
        
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
