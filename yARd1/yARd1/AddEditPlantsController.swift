//
//  AddEditPlantsController.swift
//  yARd
//
//  Created by Hannah Palma on 10/13/18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

class AddEditPlantsController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  // TODO: when a row is selected, show a modal with the plant options and reset the data to the list
  
  struct RowItem {
    var imageNumber: Int
    var assignedPlantName: String
  }
  
  var rows = [RowItem]()
  var plantSelections: [ARCameraController.Plant] = [ARCameraController.Plant.unselected, ARCameraController.Plant.unselected, ARCameraController.Plant.unselected]
  var possiblePlants = [ARCameraController.Plant]()
  var onPlantsSelected:(([ARCameraController.Plant]) -> Void)!

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return rows.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let rowData = rows[indexPath.row]
    let cell = UITableViewCell(style: UITableViewCell.CellStyle.value2, reuseIdentifier: "Cell");
    cell.textLabel?.text = "Stick " + String(rowData.imageNumber)
    cell.detailTextLabel?.text = rowData.assignedPlantName
    
    return cell
  }
  
  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("selected row \(rows[indexPath.row])")
    print("selected section \(rows[indexPath.section])")
    let rowIndexSelected = indexPath.row;

    let alert = UIAlertController(title: "Select a plant", message: "", preferredStyle: .actionSheet)
    
    for actionIndex in 0...(possiblePlants.count - 1) {
      let action = UIAlertAction(title: ARCameraController.getPlantDisplayName(plant: possiblePlants[actionIndex]), style: .destructive) { (action) in
        // Respond to user selection of the action
        let newSelection = self.possiblePlants[actionIndex]
        self.rows[rowIndexSelected] = RowItem(imageNumber: (rowIndexSelected + 1), assignedPlantName: ARCameraController.getPlantDisplayName(plant: newSelection))
        tableView.reloadData()
        
        self.plantSelections[rowIndexSelected] = newSelection
        self.onPlantsSelected(self.plantSelections)
      }
      alert.addAction(action)
    }
    
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
      // Respond to user selection of the action
    }
    alert.addAction(cancelAction)

    // On iPad, action sheets must be presented from a popover.
    alert.popoverPresentationController?.sourceView = tableView // TODO: fix

    self.present(alert, animated: true) {
      // The alert was presented
    }

  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    navigationItem.title = "Add or Edit Plants"
    
    // Pull and set data
    for index in 0...(plantSelections.count - 1) {
      var assignedPlant = ARCameraController.getPlantDisplayName(plant: plantSelections[index]);
      if (plantSelections[index] == ARCameraController.Plant.unselected) {
        assignedPlant += " (Please tap to assign a plant)"
      }
      let row = RowItem(imageNumber: (index + 1), assignedPlantName: assignedPlant)
      rows.append(row)
    }
  }

}
