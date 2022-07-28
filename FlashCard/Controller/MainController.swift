//
//  MainController.swift
//  FlashCard
//
//  Created by Levina Niolana on 26/07/22.
//

import UIKit
import CoreData

class MainController: UIViewController {
  
  @IBOutlet weak var goalLbl: UILabel!
  @IBOutlet weak var daysLbl: UILabel!
  @IBOutlet weak var daysLeftLbl: UILabel!
  @IBOutlet weak var message: UILabel!
  @IBOutlet weak var goalView: UIView!
  
  @IBOutlet weak var myCardsLbl: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var goal : Goals?
  var goalIsActive : Bool = false
  var isGroupSelected : Bool = false
  var rowSelected : Int?
  var flashcardGroup : FlashcardGroup?
  var flashcard : [Flashcard]?
  
  var daysLeft = 0
  var target = 0
  var passingDays : Int?
  
  //reference to manage object context
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  //data for my cards table
  var flashcardGroupData: [FlashcardGroup]?
  
  //data for circular bar
  var goals: [Goals]?
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "halfBackground")!)
    
    goalView.layer.cornerRadius = 25
    
    //hide nav bar
//    self.navigationItem.setHidesBackButton(true, animated: true)
    
    goalLbl.textColor = UIColor.white
    daysLbl.textColor = UIColor.white
    daysLeftLbl.textColor = UIColor.white
    message.textColor = UIColor.white
    
    do{
      self.goals = try context.fetch(Goals.fetchRequest())
      if goals?.isEmpty != true{
        goalIsActive.toggle()
        
        goal = goals![goals!.count-1]
        
        let date = goal?.goalTarget
        let interval =  Date() - date!
        daysLeft = -(interval.day ?? 0) + 1
        let created = goal?.created
        target = (date?.get(.day))! - (created?.get(.day))!
        
        goalLbl.text = goal?.goalName
      }
    }catch{
      //error
      print("No Data")
    }
    
    daysLbl.text = "\(daysLeft)"
    message.text = "Hurry, review your card!"
    
    //table
    tableView?.backgroundColor = UIColor.clear.withAlphaComponent(0)
    tableView.register(UINib(nibName: "MyCardsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    tableView.delegate = self
    tableView.dataSource = self
    
    //progress bar
    circularBar()
    
    //get item from core data
    getFlashcardGroup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
//    print("day: \(daysLeft)")
    getFlashcardGroup()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let nextVC = segue.destination as? CardDetailController

    //check if selected
    if isGroupSelected{
      nextVC?.groupName = flashcardGroupData![rowSelected!].groupName
    }

    //passing flashcard
    nextVC?.flashcardGroup = self.flashcardGroup
    
    let nextVC2 = segue.destination as? AddGoalViewController
    nextVC2?.goalIsActive = self.goalIsActive
    nextVC2?.goals = self.goal
    
    let nextVC3 = segue.destination as? MyCardsController
    passingDays = daysLeft
    nextVC3?.passingDays = self.passingDays
    
    let nextVC4 = segue.destination as? AddGroupController
    
    //check if selected
    if isGroupSelected{
      nextVC4?.groupName = flashcardGroupData![rowSelected!].groupName
      nextVC4?.flashcardGroup = self.flashcardGroup
    }
    isGroupSelected.toggle()
  }
  
  @IBAction func seeAllTappped(_ sender: Any) {
    performSegue(withIdentifier: "openMyCards", sender: UIButton())
  }
  
  @IBAction func goalTapped(_ sender: Any) {
    performSegue(withIdentifier: "openGoal", sender: UIButton())
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
  
  func circularBar(){
    //draw circle
    let x = UIScreen.main.bounds.size.width/2
    let y = UIScreen.main.bounds.size.width*3/4
    let position = CGPoint(x: x, y: y)
    
    //create track layer
    let trackLayer = CAShapeLayer()
    let circularPath = UIBezierPath(arcCenter: position, radius: 85, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
    trackLayer.path = circularPath.cgPath
    
    trackLayer.strokeColor = UIColor(named: "circularBarColor")?.cgColor
    trackLayer.lineWidth = 15
    trackLayer.fillColor = UIColor.clear.cgColor
    trackLayer.lineCap = CAShapeLayerLineCap.round
    view.layer.addSublayer(trackLayer)
    
    //create progress layer
    let shapeLayer = CAShapeLayer()
    
    shapeLayer.path = circularPath.cgPath
    
    shapeLayer.strokeColor = UIColor(named: "Orange")?.cgColor
    shapeLayer.lineWidth = 15
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineCap = CAShapeLayerLineCap.round
    
    shapeLayer.strokeEnd = 0
  
    view.layer.addSublayer(shapeLayer)
    
    //create reading progress animation
    let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
    
    //get data
    let progress: Double = Double(1) / Double(target) * Double(daysLeft)

    basicAnimation.toValue = progress
    basicAnimation.duration = 1
    basicAnimation.fillMode = CAMediaTimingFillMode.forwards
    basicAnimation.isRemovedOnCompletion = false
    
    shapeLayer.add(basicAnimation, forKey: "animation")
  }
}

extension MainController : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //total row
    return flashcardGroupData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyCardsTableViewCell
    
//    rowSelected = flashcardGroupData!.count - 1
    
    do{
      let request = Flashcard.fetchRequest() as NSFetchRequest<Flashcard>
      //set filter
      let pred = NSPredicate(format: "has.groupName CONTAINS %@", flashcardGroupData![indexPath.row].groupName!)
      request.predicate = pred

      flashcard = try context.fetch(request)
    }catch{
      //error
      print("No Data")
    }
    
    let totalCard = flashcard?.count
    let stateStatus = flashcardGroupData?[indexPath.row].goal
    //set data
    cell.groupName.text = flashcardGroupData?[indexPath.row].groupName
    cell.cardTotal.text = "\(totalCard!) cards"
    cell.cardTag.text = ""
    
    if stateStatus!{
      cell.timeLeft.text = "\(daysLeft) days left"
    }else{
      cell.timeLeft.text = "- days left"
    }
    
    var cardTag = flashcardGroupData?[indexPath.row].category
    var color = ""
    
    if cardTag == "Tech"{
      color = "Accent"
    }else{
      color = "Orange"
    }
    
    cell.cardTag.text = cardTag
    cell.tagView.layer.borderColor = UIColor(named: "\(color)")?.cgColor
    return cell
  }
}

extension MainController : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    isGroupSelected.toggle()
    
    //get index row
    rowSelected = indexPath.row
    
    self.flashcardGroup = self.flashcardGroupData![indexPath.row]
    
    //deselect row
    tableView.deselectRow(at: indexPath, animated: true)
    
    //open card detail
    performSegue(withIdentifier: "openCardDetail", sender: UIButton())
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    isGroupSelected.toggle()
    
    //get index row
    rowSelected = indexPath.row

    //delete
    let delete = UIContextualAction(style: .normal, title: "Delete") { [self](action, view, completionHandler)  in
      //delete category core data
      context.delete(flashcardGroupData![indexPath.row])

      //save
      do{
        try context.save()
      }
        catch{
        //error
      }

      //reload table
      getFlashcardGroup()
    }
    delete.image = UIImage(systemName: "trash")
    delete.backgroundColor = UIColor.systemRed
    
    //edit
    let edit = UIContextualAction(style: .normal, title: "Edit") {(action, view, completionHandler) in
      self.flashcardGroup = self.flashcardGroupData![indexPath.row]
      
      //open group form
      self.performSegue(withIdentifier: "openAddGroup", sender: nil)
    }
    edit.image = UIImage(systemName: "pencil")
    edit.backgroundColor = UIColor(named: "Secondary")
    
    let action = UISwipeActionsConfiguration(actions: [delete, edit])
    return action
  }
}

extension Date {
  static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?) {
    let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
    let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
    
    return (month: month, day: day)
  }
}
