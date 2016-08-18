    //
//  LoginViewController.swift
//  Emblem
//
//  Created by Dane Jordan on 8/3/16.
//  Copyright © 2016 Hadashco. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FBSDKShareKit
import SwiftyJSON
    

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var user:User!
    let deployedServerString:String = "http://138.68.23.39:3000"

    let env = NSProcessInfo.processInfo().environment
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureFacebook()
        if FBSDKAccessToken.currentAccessToken() != nil {
            self.performSegueWithIdentifier(MapViewController.getEntrySegueFromLogin(), sender:nil )
            //self.performSegueWithIdentifier(SimpleViewController.getEntrySegueFromMapView(), sender:nil )
        }
        
    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        
        
        FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields":"first_name, email, last_name, picture.type(large)"]).startWithCompletionHandler { (connection, result, error) -> Void in
            
            
            if error != nil {
                print("FBLogin Error: \(error)")
            } else {
                var url = NSURL()
                if let server = self.env["DEV_SERVER"] as String? {
                    url = NSURL(string: "\(server)auth/facebook/token?access_token=\(FBSDKAccessToken.currentAccessToken().tokenString)")!
                } else {
                    url = NSURL(string: "\(self.deployedServerString)/auth/facebook/token?access_token=\(FBSDKAccessToken.currentAccessToken().tokenString)")!
                }
                
                HTTPRequest.get(url, getCompleted: { (response, data) in
                    if response.statusCode == 200 {
                        self.performSegueWithIdentifier(MapViewController.getEntrySegueFromLogin(), sender: nil)
                    } else {
                        print("FB Authentication Falure: \(response)")
                    }
                })
                
            }
            
            //Result Object Here
            
            //            let strFirstName: String = (result.objectForKey("first_name") as? String)!
            //            let strLastName: String = (result.objectForKey("last_name") as? String)!
            //            let strPictureURL: String = (result.objectForKey("picture")?.objectForKey("data")?.objectForKey("url") as? String)!
        }
        
    }
    
    func configureFacebook(){
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        fbLoginButton.delegate = self
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        let loginManager: FBSDKLoginManager = FBSDKLoginManager()
        loginManager.logOut()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == MapViewController.getEntrySegueFromLogin() {
            let dest = segue.destinationViewController as! MapViewController
            if let user = sender as? User {
                dest.user = user
            }
        }

    }
}
