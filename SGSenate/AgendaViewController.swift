//
//  AgendaViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit
import SideMenuController

class AgendaViewController: UIViewController, SideMenuControllerDelegate, UIWebViewDelegate
{
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var loader: DotsLoader!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        sideMenuController?.delegate = self
        webView?.delegate = self
        webView.alpha = 0
        
        let targetURL = NSURL(string: "https://www.sg.ufl.edu/Portals/0/Resources/Senate/Agendas/2017/02-14-17.pdf?ver=2017-02-13-114601-560")!
        
        let request = NSURLRequest(url: targetURL as URL)
        webView.loadRequest(request as URLRequest)
        
        // Do any additional setup after loading the view.
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
