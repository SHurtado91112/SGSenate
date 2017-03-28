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

class VoteViewController: UIViewController, SideMenuControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        //let radioBtn = LT
        
        // Do any additional setup after loading the view.
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
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = VoteCell()
        
        switch(indexPath.section)
        {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteCell
                break;
            case 1:
                cell = tableView.dequeueReusableCell(withIdentifier: "voteCell", for: indexPath) as! VoteCell
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
