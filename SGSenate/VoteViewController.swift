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

class VoteViewController: UIViewController, SideMenuControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var writeOptionTextField: UITextField!
    
    var origPos: CGPoint!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.origPos = self.view.frame.origin
        self.writeOptionTextField.delegate = self
        
        sideMenuController?.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
    
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
        switch(section)
        {
            case 0:
                //bills
            return 1
            case 1:
                //misc
            return 1
        default:
                //write in
            return 0
        }
        
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
    
    func keyboardNotification(notification: NSNotification)
    {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                
            } else {
                
                print("animating")
                UIView.animate(withDuration: 0.3, animations:
                    {
                        
                        let yPos = self.origPos.y - (endFrame?.size.height ?? 20)
                        self.view.frame.origin = CGPoint(x: 0, y: yPos)
                        
                        
                })
                
                
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        UIView.animate(withDuration: 0.1)
        {
            self.view.frame.origin = self.origPos
        }
        
        self.view.endEditing(true)
        resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        print("Did begin editing.")
        
        UIView.animate(withDuration: 0.1)
        {
            self.view.frame.origin = self.origPos
        }

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
