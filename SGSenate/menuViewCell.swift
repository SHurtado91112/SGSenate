//
//  menuViewCell.swift
//  SGSenate
//
//  Created by Steven Hurtado on 2/8/17.
//  Copyright © 2017 Steven Hurtado. All rights reserved.
//

import UIKit

class menuViewCell: UITableViewCell
{
    @IBOutlet weak var cellImgView: UIImageView!

    @IBOutlet weak var viewName: UILabel!
    
    var viewText = ""
    var viewImg = UIImage()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        viewName.text = viewText
        cellImgView.image = viewImg
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
