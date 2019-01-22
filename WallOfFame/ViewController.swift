//
//  ViewController.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 21/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import UIKit
import FacebookLogin

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
    }


}

