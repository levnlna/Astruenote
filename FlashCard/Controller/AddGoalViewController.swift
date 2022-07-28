//
//  AddGoalViewController.swift
//  FlashCard
//
//  Created by Levina Niolana on 26/07/22.
//

import UIKit

class AddGoalViewController: UIViewController {
  
  @IBOutlet weak var leftBarBtn: UIBarButtonItem!
  @IBOutlet weak var rightBarBtn: UIBarButtonItem!
  
  @IBOutlet weak var goalLbl: UILabel!
  @IBOutlet weak var goalTxtField: UITextField!
  
  @IBOutlet weak var targetLbl: UILabel!
  @IBOutlet weak var datePicker: UIDatePicker!
  
  @IBOutlet weak var groupLbl: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var goalIsActive : Bool?
  var goals : Goals?
  
  //reference to manage object context
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  //data for my cards table
  var flashcardGroupData: [FlashcardGroup]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //color
    self.view.backgroundColor = UIColor(named: "BackgroundColor")
    goalLbl.textColor = UIColor.white
    goalTxtField.backgroundColor = UIColor(named: "Secondary")
    //placeholder color belum
    targetLbl.textColor = UIColor.white
    groupLbl.textColor = UIColor.white
    tableView.backgroundColor = UIColor(named: "BackgroundColor")
//    datePicker.setValue(UIColor(named: "BackgroundColor"), forKey: "backgroundColor")
    
    //set text
    goalLbl.text = "What do you want?"
    targetLbl.text = "Target"
    groupLbl.text = "Card Included"
    
    //table
    tableView.register(UINib(nibName: "AddGoalTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    tableView.dataSource = self
    tableView.delegate = self
    
    leftBarBtn.title = "Cancel"
    
    //set data
    if goalIsActive! {
      goalTxtField.text = goals?.goalName
      datePicker.setDate(goals!.goalTarget!, animated: true)
      rightBarBtn.title = "Done"
    }else{
      //set text bar button
        leftBarBtn.title = "Cancel"
        rightBarBtn.title = "Add"
    }
    
    //get item from core data
    getFlashcardGroup()
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
    if rightBarBtn.title == "Add"{
      //create Object    
      let newGoal = Goals(context: self.context)
      newGoal.goalName = goalTxtField.text
      newGoal.goalTarget = datePicker.date
      newGoal.created = Date()
    }else{
      //save edited data
      if let temp = goals{
        temp.goalName = goalTxtField.text
        temp.goalTarget = datePicker.date
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
  
  func getFlashcardGroup(){
    //fetch data from core data
    do{
      self.flashcardGroupData = try context.fetch(FlashcardGroup.fetchRequest())

      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }catch{
      //error
      print("No Data")
    }
  }
}
extension Date {
  func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
    return calendar.dateComponents(Set(components), from: self)
  }
  
  func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
    return calendar.component(component, from: self)
  }
}

extension AddGoalViewController : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //total row
    return flashcardGroupData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AddGoalTableViewCell
    
    let stateStatus = flashcardGroupData?[indexPath.row].goal
    //set data
    cell?.groupName.text = flashcardGroupData?[indexPath.row].groupName
    cell?.switchBtn.isOn = stateStatus!
    return cell ?? UITableViewCell()
  }
}

extension AddGoalViewController : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    var stateStatus = flashcardGroupData?[indexPath.row].goal
    if stateStatus!{
      stateStatus?.toggle()
    }else{
      stateStatus?.toggle()
    }
    
    if let temp = flashcardGroupData?[indexPath.row]{
      temp.goal = stateStatus!
    }
    
    //save data
    do{
      try self.context.save()
    }
      catch{
      //error
    }
    tableView.reloadData()
  }
}


