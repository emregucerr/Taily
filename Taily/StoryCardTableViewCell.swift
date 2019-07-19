//
//  StoryCardTableViewCell.swift
//  Taily
//
//  Created by Ahmet Emre Gucer on 25.06.2019.
//  Copyright © 2019 Ahmet Emre Gucer. All rights reserved.
//

import UIKit

class StoryCardTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var contentText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
