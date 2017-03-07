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

class AdminSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{

    @IBOutlet weak var agendaLinkTextField: UITextField!
    
    @IBOutlet weak var billTableView: UITableView!
    @IBOutlet weak var billStepper: UIStepper!
    @IBOutlet weak var billNumLabel: UILabel!
    var bills: [FIRDataSnapshot]! = []
    
    @IBOutlet weak var miscTableView: UITableView!
    @IBOutlet weak var miscStepper: UIStepper!
    @IBOutlet weak var miscNumLabel: UILabel!
    var misc: [FIRDataSnapshot]! = []
    
    var user: FIRUser?
    var displayName: String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.billStepper.layer.cornerRadius = 5
        self.miscStepper.layer.cornerRadius = 5

        self.billTableView.delegate = self
        self.miscTableView.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == self.miscTableView)
        {
            return Int(self.miscStepper.value)
        }
        else if(tableView == self.billTableView)
        {
            return Int(self.billStepper.value)
        }
        else
        {
            return 0
        }
    }
    
    @IBAction func billStepped(_ sender: Any)
    {
        self.billNumLabel.text = "\(Int(self.billStepper.value))"
        
        self.billTableView.reloadData()
    }
    
    @IBAction func miscStepped(_ sender: Any)
    {
        self.miscNumLabel.text = "\(Int(self.miscStepper.value))"
        
        self.miscTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if(tableView == self.miscTableView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "miscLinkCell", for: indexPath) as! MiscLinkCell
            
            cell.miscLabel.text = "Misc. #\(indexPath.row + 1)"
            
            return cell
        }
        else if(tableView == self.billTableView)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "billLinkCell", for: indexPath) as! BillLinkCell
            
            cell.billLabel.text = "Bill #\(indexPath.row + 1)"
            
            return cell
        }
        else
        {
            let cell = UITableViewCell()
            return cell
        }
        
        
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
