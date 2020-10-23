//
//  ExamTableViewCell.swift
//  Assignment2
//
//  Created by Stephen Byatt on 16/10/20.
//  Copyright © 2020 Stephen Byatt. All rights reserved.
//

import UIKit

class ExamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var view: Rounded!
    @IBOutlet weak var examName: UILabel!
    @IBOutlet weak var studentNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
