//
//  RecipeModifierViewController.swift
//  Recipes
//
//  Created by Nofel Mahmood on 31/08/2015.
//  Copyright © 2015 Hyper. All rights reserved.
//

import UIKit

let RecipePhotoTableViewCellIdentifier = "RecipePhotoTableViewCell"
let RecipeDescriptionTableViewCellIdentifier = "RecipeDescriptionTableViewCellI"
let RecipeInstructionTableViewCellIdentifier = "RecipeInstructionTableViewCell"

let RecipeModifierBarButtonItemActionName = "didPressBarButtonItem:"

// MARK: UITableViewDataSource
extension RecipeModifierViewController: UITableViewDataSource {
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 || section == 1 {
      return 1
    }
    guard let recipeInstructions = self.recipeInstructions else {
      return 0
    }
    
    return recipeInstructions.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier(RecipePhotoTableViewCellIdentifier, forIndexPath: indexPath) as! RecipePhotoTableViewCell
      if let photo = self.recipe?.photo {
        cell.photoImageView.image = UIImage(data: photo)
      }
      return cell
    } else if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCellWithIdentifier(RecipeDescriptionTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeDescriptionTableViewCell
      if let recipeDescription = self.recipe?.specification {
        cell.descriptionTextView.text = recipeDescription
      }
      return cell
    } else if indexPath.section == 2 {
      let cell = tableView.dequeueReusableCellWithIdentifier(RecipeInstructionTableViewCellIdentifier, forIndexPath: indexPath) as! RecipeInstructionTableViewCell
      let instruction = self.recipeInstructions![indexPath.row]
      cell.instructionTextView.text = "\(instruction). This is the instruction you have been waiting for. You can either die as a hero or you can live long enough to become a villian and I can do those things you fucking bastard"
      cell.instructionNumberLabel.text = "\(indexPath.row + 1)"
      return cell
    }
    return UITableViewCell()
  }
}

// MARK: UITableViewDelegate
extension RecipeModifierViewController: UITableViewDelegate {

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //Todo : Implement Cooking Mode
    guard let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as? RecipeInstructionTableViewCell else {
      return
    }
    selectedCell.contentView.alpha = 1.0
    selectedCell.instructionTextView.textColor = UIColor.blackColor()
    selectedCell.instructionTextView.font = UIFont(name: "Avenir Book", size: 23.0)
    
    UIView.animateWithDuration(0.5, animations: { () -> Void in
      for visibleCell in tableView.visibleCells {
        guard visibleCell != selectedCell else {
          continue
        }
        visibleCell.contentView.alpha = 0.1
      }}, completion: { (completed) -> Void in
        if completed {
          self.tableView.beginUpdates()
          self.tableView.endUpdates()
          self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    })
  }
  
  func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
    return UITableViewCellEditingStyle.None
  }
  
  func tableView(tableView: UITableView, shouldIndentWhileEditingRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
}

class RecipeModifierViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!
  @IBOutlet var recipeNameTextField: UITextField!
  
  var recipe: Recipe?
  var recipeInstructions: [String]?
  var cookingMode = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.setEditing(false, animated: true)
    tableView.estimatedRowHeight = 44.0
    tableView.rowHeight = UITableViewAutomaticDimension
    self.recipeNameTextField.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
    if let recipeName = self.recipe?.name {
      self.recipeNameTextField.text = recipeName
    }
    if let recipeInstructions = self.recipe?.instructionsList {
      self.recipeInstructions = recipeInstructions
      self.recipeInstructions!.append("Here's Another Step. Stay Healthy")
      self.recipeInstructions!.append("Stay fine. This is a very important step. This must be done in order to keep the food well cooked. This would allow you to stay fit")
    }
  }
  
  override func viewDidAppear(animated: Bool) {
    self.tableView.reloadData()
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: Editing
  override func setEditing(editing: Bool, animated: Bool) {
    super.setEditing(editing, animated: animated)
    self.recipeNameTextField.userInteractionEnabled = editing
    self.tableView.setEditing(editing, animated: animated)
    if editing {
      self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector(RecipeModifierBarButtonItemActionName)), animated: true)
      self.navigationItem.setRightBarButtonItem(nil, animated: true)
    } else {
      self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: Selector(RecipeModifierBarButtonItemActionName)), animated: true)
      self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: Selector(RecipeModifierBarButtonItemActionName)), animated: true)
    }
  }
  
  // MARK: IBAction
  @IBAction func didPressBarButtonItem(sender: AnyObject) {
    if self.editing && self.navigationItem.leftBarButtonItem! == sender as! NSObject {
      self.setEditing(false, animated: true)
    } else if !self.editing {
      if self.navigationItem.leftBarButtonItem! == sender as! NSObject {
        self.setEditing(true, animated: true)
      } else if self.navigationItem.rightBarButtonItem! == sender as! NSObject {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
      }
    }
  }

  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}