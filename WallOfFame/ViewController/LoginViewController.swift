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
    
    var getBackToWall: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        getBackToWall = UIButton(frame: CGRect(x: (self.view.bounds.width/2)-90, y: (2*self.view.bounds.height/3), width: 180, height: 40))
        getBackToWall!.setTitle("Wall of Fame", for: .normal)
        getBackToWall?.layer.cornerRadius = 8
        getBackToWall?.layer.masksToBounds = true
        getBackToWall!.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 14)

        getBackToWall!.setTitleColor(.white, for: .normal)
        getBackToWall!.backgroundColor = UIColor.blue.withAlphaComponent(0.8)
        getBackToWall?.addTarget(self, action: #selector(changeViewController), for: .touchUpInside)
        
        self.view.addSubview(getBackToWall!)

        if AccessToken.current != nil {
            // User is logged in, use 'accessToken' here.
            self.changeViewController()
        }

    }
    
    func loginButtonDidCompleteLogin(_ loginButton: LoginButton, result: LoginResult) {
        
        switch result {
        case .failed(let error):
            print(error)
        case .cancelled:
            print("User cancelled login.")
        case .success:
            self.view.addSubview(getBackToWall!)
            self.changeViewController()
            
        }
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: LoginButton) {
        self.getBackToWall?.removeFromSuperview()
        let manager = LoginManager()
        manager.logOut()
    }
    
    @objc func changeViewController(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyBoard.instantiateViewController(withIdentifier: "fame") as! FameViewController
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }

}

