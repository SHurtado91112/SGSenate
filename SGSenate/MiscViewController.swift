//
//  MiscViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SideMenuController

class MiscViewController: UIViewController, SideMenuControllerDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        
        tableView?.delegate = self
        tableView.rowHeight = 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "miscCell", for: indexPath) as! MiscCell
        
        cell.miscLabel.text = "Misc. Item \(indexPath.row + 1)"
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 4
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
            
            vc.targetURLString = "https://pdfs.semanticscholar.org/9c1b/8896fb06aad9990959aca4cf3989e0d91d8b.pdf"
        }
     }
    
}
