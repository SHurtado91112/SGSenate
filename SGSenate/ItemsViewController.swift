//
//  ItemsViewController.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/22/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class ItemsViewController: UIViewController, UIWebViewDelegate
{

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var loader: DotsLoader!
    
    var targetURLString : String!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        webView?.delegate = self
        webView.alpha = 0
        
        let targetURL = NSURL(string: targetURLString)!
        
        let request = NSURLRequest(url: targetURL as URL)
        webView.loadRequest(request as URLRequest)
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
    


    override func didReceiveMemoryWarning() {
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
