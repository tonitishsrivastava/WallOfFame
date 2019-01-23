//
//  ViewController.swift
//  WallOfFame
//
//  Created by Nitish Srivastava on 21/01/19.
//  Copyright © 2019 Nitish Srivastava. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        
        view.addSubview(loginButton)
        
        if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            print(" User is Logged in ")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "fame") as! FameViewController
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }
        
    }


}

