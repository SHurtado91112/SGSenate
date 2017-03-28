//
//  BillCell.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/9/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class BillCell: UITableViewCell
{
    @IBOutlet weak var billLabel: UILabel!

    @IBOutlet weak var billView: UIView!
    
    var link = ""
    var name = ""
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        billView.layer.shadowColor = UIColor.black.cgColor
        billView.layer.shadowOpacity = 0.9
        billView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        billView.layer.shadowRadius = 10
        billView.layer.shouldRasterize = true
        
        self.billLabel.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
