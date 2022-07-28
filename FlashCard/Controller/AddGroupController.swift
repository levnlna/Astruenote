//
//  AddGroupController.swift
//  FlashCard
//
//  Created by Levina Niolana on 27/07/22.
//

import UIKit

class AddGroupController: UIViewController {

  @IBOutlet weak var leftBarBtn: UIBarButtonItem!
  @IBOutlet weak var rightBarBtn: UIBarButtonItem!
  @IBOutlet weak var navTitle: UINavigationItem!
  
  @IBOutlet weak var groupNameLbl: UILabel!
  @IBOutlet weak var groupNameTxtField: UITextField!
  
  @IBOutlet weak var categoryLbl: UILabel!
  
  @IBOutlet weak var techBtn: UIButton!
  @IBOutlet weak var designBtn: UIButton!
  
  var category = ""
  
  //passing data
  var groupName : String?
  var groupCategory : String?
  var flashcardGroup : FlashcardGroup?
  
  //reference to manage object context
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //set color
    self.view.backgroundColor = UIColor(named: "BackgroundColor")
    groupNameLbl.textColor = UIColor.white
    groupNameTxtField.backgroundColor = UIColor(named: "Secondary")
    categoryLbl.textColor = UIColor.white
    
    //set text
    groupNameLbl.text = "Group Name"
    categoryLbl.text = "Category"
    leftBarBtn.title = "Cancel"
    
    //set data
    if groupName?.isEmpty != nil {
      navTitle.title = groupName
      groupNameTxtField.text = groupName
      if flashcardGroup?.category == "Tech"{
        techBtn.isHighlighted = false
      }else{
        designBtn.isHighlighted = false
      }
      rightBarBtn.title = "Done"
    }else{
      //set text bar button
        leftBarBtn.title = "Cancel"
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
  
  @IBAction func techChosen(_ sender: Any) {
    techBtn.isHighlighted = false
    category = "Tech"
  }
  
  @IBAction func designChosen(_ sender: Any) {
    designBtn.isHighlighted = false
    category = "Design"
  }
  
  @IBAction func rightBarBtnTapped(_ sender: Any) {

    if rightBarBtn.title == "Add"{
      //create Object
      let newGroup = FlashcardGroup(context: self.context)
      newGroup.groupName = groupNameTxtField.text
      newGroup.goal = true
      newGroup.category = category
 
    }else{
      //save edited data
      if let temp = flashcardGroup{
        temp.groupName = groupNameTxtField.text
        temp.category = category
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

