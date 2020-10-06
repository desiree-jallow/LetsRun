//
//  StartViewController.swift
//  LetsRun
//
//  Created by Desiree on 9/24/20.
//

import UIKit
import MapKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //hides navigation bar for start controller
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    // shows navigation bar for map view controller
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        
    }
    
}
    


