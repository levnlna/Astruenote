//
//  FlashCardCell.swift
//  FlashCard
//
//  Created by Levina Niolana on 25/07/22.
//

import UIKit

class FlashCardCell: UICollectionViewCell {
  
  static let identifier = "FlashCardCell"
  
  @IBOutlet weak var positionLbl: UILabel!
  @IBOutlet weak var keywordLbl: UILabel!
  @IBOutlet weak var showBtn: UIButton!
  
  var cardIsOpened = false
  
    override func awakeFromNib() {
        super.awakeFromNib()
      
        self.layer.cornerRadius = 25
    }
  
  @IBAction func showTapped(_ sender: Any) {
    if cardIsOpened{
      positionLbl.isHidden = false
      showBtn.setTitle("Show Description", for: .normal)
     
      keywordLbl.text = ViewController.flashcardData![ViewController.row].flashcardName
      keywordLbl.font = keywordLbl.font.withSize(35)
      keywordLbl.textAlignment =  .center
      
      cardIsOpened.toggle()
      
      UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
      
    }else{
      positionLbl.isHidden = true
      showBtn.setTitle("Hide Description", for: .normal)
      
      keywordLbl.text = ViewController.flashcardData![ViewController.row].flashcardDescription
      keywordLbl.font = keywordLbl.font.withSize(17)
      keywordLbl.textAlignment =  .left
      
      cardIsOpened.toggle()
      
      UIView.transition(with: self, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
  }
  
  static func nib() -> UINib{
    return UINib(nibName: "FlashCardCell", bundle: nil)
  }
}
