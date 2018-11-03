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
  var plantSelections:ARCameraController.PlantSelections!
  var onPlantsSelected:((ARCameraController.PlantSelections) -> Void)!

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

  override func viewDidLoad() {
    super.viewDidLoad()
  
    navigationItem.title = "Add or Edit Plants"
    
    // Pull and set data
  
    let row1AssignedPlant = ARCameraController.getPlantDisplayName(plant: plantSelections.stick1);
    let row1 = RowItem(imageNumber: 1, assignedPlantName: row1AssignedPlant)
    
    let row2AssignedPlant = ARCameraController.getPlantDisplayName(plant: plantSelections.stick2);
    let row2 = RowItem(imageNumber: 2, assignedPlantName: row2AssignedPlant)
    
    let row3AssignedPlant = ARCameraController.getPlantDisplayName(plant: plantSelections.stick3);
    let row3 = RowItem(imageNumber: 3, assignedPlantName: row3AssignedPlant)
    
    rows = [row1, row2, row3]
    
    plantSelections.stick1 = ARCameraController.Plants.fir
    onPlantsSelected(plantSelections)
  }

}
