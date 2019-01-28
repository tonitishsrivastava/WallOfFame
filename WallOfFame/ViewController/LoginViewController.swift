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

class LoginViewController: UIViewController,  LoginButtonDelegate{
    
    var myLoginButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self

        view.addSubview(loginButton)

        if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            print(" User is Logged in ")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "fame") as! FameViewController
            self.navigationController?.pushViewController(destinationViewController, animated: true)
        }

    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("User cancelled login.")
        case .success:
            
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "fame") as! FameViewController
            self.navigationController?.pushViewController(destinationViewController, animated: true)
            
        }
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        let manager = LoginManager()
        manager.logOut()
    }
    

}

