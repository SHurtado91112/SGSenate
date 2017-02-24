//
//  BillsViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SideMenuController

class BillsViewController: UIViewController, SideMenuControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        
        tableView?.delegate = self
        tableView.rowHeight = 80
        // Do any additional setup after loading the view.
    }
    
    func sideMenuControllerDidHide(_ sideMenuController: SideMenuController)
    {
        print(#function)
    }
    
    func sideMenuControllerDidReveal(_ sideMenuController: SideMenuController)
    {
        print(#function)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "billCell", for: indexPath) as! BillCell
        
        cell.billLabel.text = "Bill \(indexPath.row + 1)"
        
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
            
            vc.targetURLString = "https://pdfs.semanticscholar.org/9c1b/8896fb06aad9990959aca4cf3989e0d91d8b.pdf"
        }
     }
}
