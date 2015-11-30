//
//  DeatailBeaconViewController.swift
//  BeaconSwift
//
//  Created by Adriana Carelli on 29/09/15.
//  Copyright © 2015 Adriana Carelli. All rights reserved.
//

import UIKit

class DeatailBeaconViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBarHidden = false
    }


}
