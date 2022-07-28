//
//  ViewController.swift
//  FlashCard
//
//  Created by Levina Niolana on 25/07/22.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var groupNameUI: UILabel!
  @IBOutlet weak var collectionView: UICollectionView!
  
  var groupName : String?
  static var flashcardData : [Flashcard]?
  
  static var row : Int = 0
  var totalCard : Int = 0
  var currCard : Int = 0
  
  var correctAnswer = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
    //hide back button
    self.navigationItem.setHidesBackButton(true, animated: true)
    
    //set
    groupNameUI.text = groupName
    
    //collecction view
    collectionView.backgroundColor = UIColor.clear.withAlphaComponent(0)
    collectionView.register(FlashCardCell.nib(), forCellWithReuseIdentifier: FlashCardCell.identifier)
    collectionView.delegate = self
    collectionView.dataSource = self
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let nextVC = segue.destination as? CongratsPageController
    nextVC?.correctAnswer = self.correctAnswer
    nextVC?.totalCard = self.totalCard
  }
  
//  @IBAction func unwind( _ seg: UIStoryboardSegue) {
//  }
  
  @IBAction func exitTapped(_ sender: Any) {
    performSegue(withIdentifier: "unwindToCardDetail", sender: self)
  }
  
  @IBAction func wrongBtnTapped(_ sender: Any) {
    cardNavigation()
  }
  
  @IBAction func correctBtnTapped(_ sender: Any) {
    correctAnswer += 1
    cardNavigation()
  }
  
  func cardNavigation() {
    if currCard == totalCard{
      performSegue(withIdentifier: "goToCongratsPage", sender: UIButton())
    }else{
      let nextRow = ViewController.row + 1
      collectionView.scrollToItem(at: [0, nextRow], at: .centeredHorizontally, animated: true)
    }
  }
}

extension ViewController: UICollectionViewDataSource{
 
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return ViewController.flashcardData?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FlashCardCell.identifier, for: indexPath) as! FlashCardCell
    
    totalCard = collectionView.numberOfItems(inSection: 0)
    ViewController.row = indexPath.row
    currCard = ViewController.row + 1
    
    //set text
    cell.positionLbl.text = "\(currCard)/\(totalCard)"
    cell.keywordLbl.text = ViewController.flashcardData![ViewController.row].flashcardName
    cell.showBtn.setTitle("Show Description", for: .normal)
  
    return cell
  }
}

extension ViewController: UICollectionViewDelegateFlowLayout{
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 300, height: 450)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 100
  }
  
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
  }
}
