//
//  MyCardsTableViewCell.swift
//  FlashCard
//
//  Created by Levina Niolana on 26/07/22.
//

import UIKit

class MyCardsTableViewCell: UITableViewCell {

  @IBOutlet weak var groupName: UILabel!
  @IBOutlet weak var cardTotal: UILabel!
  @IBOutlet weak var timeLeft: UILabel!
  @IBOutlet weak var cardTag: UILabel!
  @IBOutlet weak var tagView: UIView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    self.layer.cornerRadius = 15
    self.layer.borderWidth = 5
    self.layer.borderColor = UIColor(named: "BackgroundColor")?.cgColor
    
    tagView.layer.cornerRadius = 10
    tagView.layer.borderColor = UIColor(named: "Accent")?.cgColor
    tagView.layer.borderWidth = 1
    
//        self.contentView.tintColor = UIColor.clear.withAlphaComponent(0)
//    self.contentView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    
    //    self.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0))
    //    self.layer.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0))
    //    self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 25, right: 0))
    
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}
