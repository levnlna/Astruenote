//
//  CardDetailController.swift
//  FlashCard
//
//  Created by Levina Niolana on 26/07/22.
//

import UIKit
import CoreData

class CardDetailController: UIViewController {

  @IBOutlet weak var startView: UIView!
  @IBOutlet weak var startTitle: UILabel!
  @IBOutlet weak var startDesc: UILabel!
  @IBOutlet weak var startBtn: UIButton!
  
  @IBOutlet weak var tableView: UITableView!
  
  var groupName : String?
  var isCardSelected : Bool = false
  var rowSelected : Int?
  var flashcard : Flashcard?
  var flashcardGroup : FlashcardGroup?
  
  //reference to manage object context
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  //data for card detail table
  var flashcardData: [Flashcard]?
  
  override func viewDidLoad() {
        super.viewDidLoad()

    //background and navigation
    self.view.backgroundColor = UIColor(named: "BackgroundColor")
    self.navigationController?.navigationBar.backgroundColor = UIColor(named: "BackgroundColor")
    self.navigationItem.title = groupName
    
    //start button
    startView.layer.cornerRadius = 15
    startTitle.text = "Start Review"
    startDesc.text = "Let’s review your card"
    
    //table
    tableView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    tableView.register(UINib(nibName: "CardDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    tableView.dataSource = self
    tableView.delegate = self
    
    //get item from core data
    getFlashcard()
    }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getFlashcard()
    isCardSelected = false
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let nextVC = segue.destination as? AddCardController
    
    //check if selected
    if isCardSelected{
      nextVC?.flashcardName = flashcardData![rowSelected!].flashcardName
      nextVC?.flashcardDescription = flashcardData![rowSelected!].flashcardDescription
      //category belum
      isCardSelected.toggle()
    }

    //passing flashcard
    nextVC?.flashcard = self.flashcard
    
    //passing flashcard group
    nextVC?.flashcardGroup = self.flashcardGroup
    
    let nextVC2 = segue.destination as? ViewController
    nextVC2?.groupName = self.groupName
    ViewController.flashcardData = self.flashcardData
  }
  
  @IBAction func unwind( _ seg: UIStoryboardSegue) {
  }
  
  @IBAction func addTapped(_ sender: Any) {
    performSegue(withIdentifier: "openAddCard", sender: UIButton())
  }
  
  @IBAction func startTapped(_ sender: Any) {
    performSegue(withIdentifier: "openFlashcard", sender: UIButton())
  }
  
  func getFlashcard(){
    //fetch data from core data
    do{
      let request = Flashcard.fetchRequest() as NSFetchRequest<Flashcard>
      //set filter
      let pred = NSPredicate(format: "has.groupName CONTAINS %@", groupName!)
      request.predicate = pred

      flashcardData = try context.fetch(request)

      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }catch{
      //error
      print("No Data")
    }
  }
}

extension CardDetailController : UITableViewDataSource{
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //total row
    return flashcardData?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CardDetailTableViewCell
    
    //set data
    cell?.cardName.text = flashcardData?[indexPath.row].flashcardName
    cell?.cardDescription.text = flashcardData?[indexPath.row].flashcardDescription
    
    return cell ?? UITableViewCell()
  }
}

extension CardDetailController : UITableViewDelegate{
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    isCardSelected = true
    self.flashcard = self.flashcardData![indexPath.row]
    
    //get index row
    rowSelected = indexPath.row
    
    //deselect row
    tableView.deselectRow(at: indexPath, animated: true)
    
    //open card form
    performSegue(withIdentifier: "openAddCard", sender: UIButton())
  }
  
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    isCardSelected = true
    
    //get index row
    rowSelected = indexPath.row
    
    //delete
    let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completionHandler)  in

      //delete card detail core data
      self.context.delete(self.flashcardData![indexPath.row])

      //save
      do{
        try self.context.save()
      }
        catch{
        //error
      }

      //reload table
      self.getFlashcard()
    }
    delete.image = UIImage(systemName: "trash")
    delete.backgroundColor = UIColor.systemRed
    
    //edit
    let edit = UIContextualAction(style: .normal, title: "Edit") {(action, view, completionHandler) in
      self.flashcard = self.flashcardData![indexPath.row]

      //open card form
      self.performSegue(withIdentifier: "openAddCard", sender: nil)
    }
    edit.image = UIImage(systemName: "pencil")
    edit.backgroundColor = UIColor(named: "Accent")

    let action = UISwipeActionsConfiguration(actions: [delete, edit])
    return action
  }
  
}
