//
//  CongratsPageController.swift
//  FlashCard
//
//  Created by Levina Niolana on 25/07/22.
//

import UIKit

class CongratsPageController: UIViewController {

  @IBOutlet weak var message: UILabel!
  @IBOutlet weak var image: UIImageView!
  
  @IBOutlet weak var summaryView: UIView!
  @IBOutlet weak var correct: UILabel!
  @IBOutlet weak var incorrect: UILabel!
  
  @IBOutlet weak var doneBtn: UIButton!
  
  var correctAnswer : Int?
  var totalCard : Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    self.navigationItem.setHidesBackButton(true, animated: true)
    summaryView.layer.cornerRadius = 15
    
    image.image = UIImage(named: "Astronaut")
    message.text = "Review Complete"
    
    correct.text = "\(correctAnswer!)"
    incorrect.text = "\(totalCard! - correctAnswer!)"

  }
  
  @IBAction func doneBtnTapped(_ sender: Any) {
    performSegue(withIdentifier: "unwindToCardDetail", sender: self)
  }
}
