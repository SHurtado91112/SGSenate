//
//  MiscCell.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/9/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class MiscCell: UITableViewCell {

    @IBOutlet weak var miscView: UIView!
    
    @IBOutlet weak var miscLabel: UILabel!
    
    var link = ""
    var name : String?
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        miscView.layer.shadowColor = UIColor.black.cgColor
        miscView.layer.shadowOpacity = 0.9
        miscView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        miscView.layer.shadowRadius = 10
        miscView.layer.shouldRasterize = true
        
        self.miscLabel.text = name
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
