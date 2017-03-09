//
//  AgendaViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SideMenuController
import Firebase
import FirebaseAuthUI

class AgendaViewController: UIViewController, SideMenuControllerDelegate, UIWebViewDelegate
{
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var loader: DotsLoader!
    
    var ref : FIRDatabaseReference!
    var link = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        webView?.delegate = self
        webView.alpha = 0
        
        self.initializeAgenda()
        
        // Do any additional setup after loading the view.
    }
    
    func initializeAgenda()
    {
        self.ref = FIRDatabase.database().reference()
        self.ref.child("agenda").observe(.value, with: { (snap: FIRDataSnapshot) in
            let val = snap.value as! [String : String]
            self.link = val["link"] ?? "[link]"
            
            let targetURL = NSURL(string: self.link)!
            
            let request = NSURLRequest(url: targetURL as URL)
            self.webView.loadRequest(request as URLRequest)
        })
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        print("reached")
        loader.alpha = 1
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.loader.alpha = 0
            self.webView.alpha = 1
        }, completion: { _ in
            self.loader.removeFromSuperview()
        })
    }
    
    func configureAuth()
    {
        FIRAuth.auth()?.addStateDidChangeListener { (auth: FIRAuth, user: FIRUser?) in
            
            self.configureDB()
        }
    }
    
    func configureDB()
    {
        //initialize master link text field
        self.ref = FIRDatabase.database().reference()
        self.ref.child("agenda").observe(.value, with: { (snap: FIRDataSnapshot) in
            let val = snap.value as! [String : String]
            self.link = val["link"] ?? "[link]"
            
            let targetURL = NSURL(string: self.link)!
            
            let request = NSURLRequest(url: targetURL as URL)
            self.webView.loadRequest(request as URLRequest)
        })
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
