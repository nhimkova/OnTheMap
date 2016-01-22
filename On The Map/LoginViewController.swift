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
        if emailTextField.text!.isEmpty {
            errorMessageLabel.text = "Username Empty."
        } else if passwordTextField.text!.isEmpty {
            errorMessageLabel.text = "Password Empty."
        } else {
            UdacityClient.sharedInstance().authenticateWithViewController(emailTextField.text!, password: passwordTextField.text!) { (success, errorString) in
                if success {
                    self.completeLogin()
                } else {
                    self.displayErrorMessage(errorString)
                }
            }
        }
    }
    
    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            self.errorMessageLabel.text = ""
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })

    }
    
    func displayErrorMessage(errorString: String?) {
       self.errorMessageLabel.text = "Failed to log in"
    }
    
    func configureUI() {
        //TODO: configure UI
        
        emailTextField.layer.borderWidth = 0
        passwordTextField.layer.borderWidth = 0
        
    }

}

