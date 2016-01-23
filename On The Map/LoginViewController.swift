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
    
    var backgroundGradient: CAGradientLayer? = nil
    
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
            
            //get user info and save it in client
            let userID = UdacityClient.sharedInstance().userID
            UdacityClient.sharedInstance().getUserInfo(userID) { (success, lastName, nickName, errorString) in
                if success {
                    UdacityClient.sharedInstance().lastName = lastName
                    UdacityClient.sharedInstance().firstName = nickName
                } else {
                    // Default to this name if no user info
                    UdacityClient.sharedInstance().lastName = "Anonymous"
                    UdacityClient.sharedInstance().firstName = "John"
                    print(errorString)
                }
            }
            
            let controller = self.storyboard!.instantiateViewControllerWithIdentifier("ManagerNavigationController") as! UINavigationController
            self.presentViewController(controller, animated: true, completion: nil)
        })

    }
    
    func displayErrorMessage(errorString: String?) {
        
        print(errorString)
        self.errorMessageLabel.text = "Failed to log in"
    }
    
    func configureUI() {
        
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 242/255, green: 123/255, blue: 28/255, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 242/255, green: 152/255, blue: 28/255, alpha: 1.0).CGColor
        self.backgroundGradient = CAGradientLayer()
        self.backgroundGradient!.colors = [colorTop, colorBottom]
        self.backgroundGradient!.locations = [0.0, 1.0]
        self.backgroundGradient!.frame = view.frame
        self.view.layer.insertSublayer(self.backgroundGradient!, atIndex: 0)
        
        //emailTextField
        let emailTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let emailTextFieldPaddingView = UIView(frame: emailTextFieldPaddingViewFrame)
        emailTextField.leftView = emailTextFieldPaddingView
        emailTextField.leftViewMode = .Always
        emailTextField.textColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        emailTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
        //passwordTextField
        let passwordTextFieldPaddingViewFrame = CGRectMake(0.0, 0.0, 13.0, 0.0);
        let passwordTextFieldPaddingView = UIView(frame: passwordTextFieldPaddingViewFrame)
        passwordTextField.leftView = passwordTextFieldPaddingView
        passwordTextField.leftViewMode = .Always
        passwordTextField.textColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.tintColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        
    }

}

