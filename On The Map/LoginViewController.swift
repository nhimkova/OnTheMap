//
//  ViewController.swift
//  On The Map
//
//  Created by Quynh Tran on 20/01/2016.
//  Copyright © 2016 Quynh. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var session: NSURLSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the shared URL session */
        session = NSURLSession.sharedSession()
        
        /* Configure the UI */
        self.configureUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.errorMessageLabel.text = ""
    }


    @IBAction func loginButtonTouch(sender: AnyObject) {
        
    }
    
    func completeLogin() {
        
    }
    
    func displayErrorMessage() {
        
    }
    
    func configureUI() {
        //TODO: configure UI
    }

}

