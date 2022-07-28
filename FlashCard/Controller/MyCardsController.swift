//
//  MyCardsController.swift
//  FlashCard
//
//  Created by Levina Niolana on 26/07/22.
//

import UIKit
import CoreData

class MyCardsController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var isGroupSelected : Bool = false
  var rowSelected : Int?
  var flashcardGroup : FlashcardGroup?
  var flashcard : [Flashcard]?
  var passingDays : Int?
  
  //reference to manage object context
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  //data for my cards table
  var flashcardGroupData: [FlashcardGroup]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.view.backgroundColor = UIColor(named: "BackgroundColor")
    self.navigationController?.navigationBar.tintColor = UIColor(named: "Accent")
    
    //table view
    tableView?.backgroundColor = UIColor.clear.withAlphaComponent(0)
    tableView?.register(UINib(nibName: "MyCardsTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    tableView?.delegate = self
    tableView?.dataSource = self
    
    //get item from core data
    getFlashcardGroup()
    
    //when there is no data
//    if flashcardGroup?.count == 0{
//      let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
//       label.center = CGPoint(x: 160, y: 285)
//       label.textAlignment = .center
//       label.text = "I'm a test label"
//
//       self.view.addSubview(label)
//    }
    
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFlashcardGroup()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let nextVC = segue.destination as? AddGroupController
    
    //check if selected
    if isGroupSelected{
      nextVC?.groupName = flashcardGroupData![rowSelected!].groupName
      //category belum
      isGroupSelected.toggle()
    }

    //passing flashcard
    nextVC?.flashcardGroup = self.flashcardGroup
    
    let nextVC2 = segue.destination as? CardDetailController
    nextVC2?.flashcardGroup = self.flashcardGroup
    nextVC2?.groupName = flashcardGroupData![rowSelected!].groupName
  }
  
  @IBAction func addBtnTapped(_ sender: Any) {
    performSegue(withIdentifier: "openAddGroup", sender: UIButton())
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

extension MyCardsController : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //total row
    return flashcardGroupData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCardsTableViewCell
    
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
    cell?.groupName.text = flashcardGroupData?[indexPath.row].groupName
    cell?.cardTotal.text = "\(totalCard!) cards"
    
    if stateStatus!{
      cell?.timeLeft.text = "\(passingDays!) days left"
    }else{
      cell?.timeLeft.text = "- days left"
    }
    
    var cardTag = flashcardGroupData?[indexPath.row].category
    var color = ""
    
    if cardTag == "Tech"{
      color = "Accent"
    }else{
      color = "Orange"
    }
    
    cell?.cardTag.text = cardTag
    cell?.tagView.layer.borderColor = UIColor(named: "\(color)")?.cgColor
    
    return cell ?? UITableViewCell()
  }
  
}

extension MyCardsController : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    isGroupSelected.toggle()
    
    self.flashcardGroup = self.flashcardGroupData![indexPath.row]
    
    //get index row
    rowSelected = indexPath.row
    
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
