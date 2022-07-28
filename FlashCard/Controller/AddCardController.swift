//
//  AddCardController.swift
//  FlashCard
//
//  Created by Levina Niolana on 27/07/22.
//

import UIKit

class AddCardController: UIViewController {

  @IBOutlet weak var leftBarBtn: UIBarButtonItem!
  @IBOutlet weak var rightBarBtn: UIBarButtonItem!
  @IBOutlet weak var navTitle: UINavigationItem!
  
  @IBOutlet weak var cardName: UILabel!
  @IBOutlet weak var cardNameTextField: UITextField!
  
  @IBOutlet weak var cardDesc: UILabel!
  @IBOutlet weak var cardDescTxtField: UITextField!
  
  //passing data
  var flashcardName : String?
  var flashcardDescription : String?
  var flashcard : Flashcard?
  var flashcardGroup : FlashcardGroup?
  
  //reference to manage object context
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // set up
    self.view.backgroundColor = UIColor(named: "BackgroundColor")
    
    cardName.text = "Card Name"
    cardName.textColor = UIColor.white
    
    cardDesc.text = "Description"
    cardDesc.textColor = UIColor.white
    
    cardNameTextField.backgroundColor = UIColor(named: "Secondary")
    cardDescTxtField.backgroundColor = UIColor(named: "Secondary")
    
    // set data
    leftBarBtn.title = "Cancel"
    
    if flashcardName?.isEmpty != nil {
      navTitle.title = flashcardName
      cardNameTextField.text = flashcardName
      cardDescTxtField.text = flashcardDescription
      rightBarBtn.title = "Done"
    }else{
      //set text bar button
        rightBarBtn.title = "Add"
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    presentingViewController?.viewWillDisappear(true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    presentingViewController?.viewWillAppear(true)
  }
  
  @IBAction func leftBarBtnTapped(_ sender: Any) {
    //dismiss
    self.presentingViewController?.dismiss(animated: true, completion:nil)
  }
  
  @IBAction func rightBarBtnTapped(_ sender: Any) {
    //edit
  
    if rightBarBtn.title == "Add"{
      //create Object
      let newCard = Flashcard(context: self.context)
      newCard.flashcardName = cardNameTextField.text
      newCard.flashcardDescription = cardDescTxtField.text
    
      //add card to group
      if let temp = flashcardGroup{
        temp.addToConsistOf(newCard)
      }
    }else{
      //save edited data
      if let temp = flashcard{
        temp.flashcardName = cardNameTextField.text
        temp.flashcardDescription = cardDescTxtField.text
      }
    }

    //save data
    do{
      try self.context.save()
    }
      catch{
      //error
    }
    self.presentingViewController?.dismiss(animated: true, completion:nil)
  }
  
}
