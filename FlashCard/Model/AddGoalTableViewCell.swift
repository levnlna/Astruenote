//
//  AddGoalTableViewCell.swift
//  FlashCard
//
//  Created by Levina Niolana on 26/07/22.
//

import UIKit

class AddGoalTableViewCell: UITableViewCell {
  
  @IBOutlet weak var groupName: UILabel!
  @IBOutlet weak var switchBtn: UISwitch!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
