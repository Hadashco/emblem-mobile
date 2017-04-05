//
//  LoginViewController.swift
//  Emblem
//
//  Created by Dane Jordan on 9/19/16.
//  Copyright © 2016 Hadashco. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import SwiftyJSON

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func noLoginPressed(sender: AnyObject) {
        self.performSegueWithIdentifier(SignUpViewController.getEntrySegueIdentifierFromLoginVC(), sender: nil)
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        let email = emailTextField.text!
        let hashedPassword = passwordTextField.text!.sha256()
        let url = NSURL(string:Store.serverLocation + "auth/local/login")!
        HTTPRequest.post(["username":email, "password":hashedPassword], dataType: .JSON, url: url) { (succeeded, msg) in
            if succeeded {
               Store.accessToken = msg["response"].stringValue
                dispatch_async(dispatch_get_main_queue(), {
                    self.performSegueWithIdentifier(MapViewController.getEntrySegueFromLogin(), sender: nil)
                })
            } else if msg["response"].stringValue == "Incorrect password." {
                let alert = UIAlertController(title: "Oops", message: "Incorrect Password", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            } else if msg["response"].stringValue == "No users with this username exist." {
                let alert = UIAlertController(title: "Oops", message: "No users with this username exit", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                dispatch_async(dispatch_get_main_queue(), {
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }

            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = loginButton.bounds.height / 2
        passwordTextField.secureTextEntry = true
        
        if let backImage:UIImage = UIImage(named: "left-arrow.png") {
            let backButton: UIButton = UIButton(type: UIButtonType.Custom)
            backButton.frame = CGRectMake(0, 0, 20, 20)
            backButton.contentMode = UIViewContentMode.ScaleAspectFit
            backButton.setImage(backImage, forState: UIControlState.Normal)
            backButton.addTarget(self, action: #selector(backPressed), forControlEvents: .TouchUpInside)
            let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: backButton)
            self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        }
    }
    
    func backPressed() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func getEntrySegueIdentifierFromFBLoginVC() -> String {
        return "fbLoginToLoginSegue"
    }


    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


}
