//
//  HomeController.swift
//  yARd
//
//  Created by Hannah Palma on 7/1/18.
//  Copyright © 2018 Brian Advent. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

  @IBAction func onContinueSelected(_ sender: UIButton) {
    self.performSegue(withIdentifier: "ARCameraSegue", sender: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated
}

}
