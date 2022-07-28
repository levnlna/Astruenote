//
//  CardDetailTableViewCell.swift
//  FlashCard
//
//  Created by Levina Niolana on 26/07/22.
//

import UIKit

class CardDetailTableViewCell: UITableViewCell {

  @IBOutlet weak var cardName: UILabel!
  @IBOutlet weak var cardDescription: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
