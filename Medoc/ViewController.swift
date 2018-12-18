//
//  ViewController.swift
//  Medoc
//
//  Created by Prem Sahni on 27/11/18.
//  Copyright © 2018 Kanishka. All rights reserved.
//

import UIKit
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth

class ViewController: UIViewController , GIDSignInUIDelegate, FBSDKLoginButtonDelegate {
    

    @IBOutlet var signINGoogle: UIButton!
    @IBOutlet var SignINFacebook: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        let FacebookLoginButton = FBSDKLoginButton()
        FacebookLoginButton.readPermissions = ["public_profile","email"]
        FacebookLoginButton.delegate = self
        signINGoogle.addTarget(self, action: #selector(signINGoogleAction), for: .touchUpInside)
        SignINFacebook.addTarget(self, action: #selector(SignINFacebookAction), for: .touchUpInside)
        // Do any additional setup after loading the view, typically from a nib.
    }
    @objc func signINGoogleAction(){
        print("google")
        GIDSignIn.sharedInstance().signIn()
    }
    @objc func SignINFacebookAction(){
        print("facebook")
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile","email"], from: self) { (result, error) in
            if error != nil {
                print("error facebook with custom button: \(error)")
            }
            else if (result?.isCancelled)! {
                print("result Cancelled")
            }
            else {
                if (result?.grantedPermissions.contains("email"))! {
                    print("granted")
                }
                self.FBauth() 
            }
        }
    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print("error facebook: \(error)")
        }
        self.FBauth()
    }
    func FBauth(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else { return }
        let credientials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
        Auth.auth().signInAndRetrieveData(with: credientials) { (authResult, error) in
            if let error = error {
                // ...
                print("failed to create a firebase user: \(error)")
                return
            }
            // User is signed in
            guard let uid = Auth.auth().currentUser?.uid else { return }
            print("sucessfully logged into firebase with facebook : \(uid)")
            print("sucessfully logged into firebase with facebook usermane: \(authResult!.user.displayName)")
            print("sucessfully logged into firebase with facebook email: \(authResult?.user.email)")

            // ...

            let request = FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "last_name, email, name, id, gender"], tokenString: accessTokenString, version: nil, httpMethod: "GET")
            request?.start(completionHandler: { (connection, result, err) in
                if err != nil {
                    print("Failed to start graph: \(err)")
                }
                
                print("result:\(result)")
            })
            print("sucessfully Logged in with facebook")
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("did Logout with Facebook")
    }
    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
//              withError error: Error!) {
//        if let error = error {
//            print("\(error.localizedDescription)")
//        } else {
//            // Perform any operations on signed in user here.
//            let userId = user.userID                  // For client-side use only!
//            let idToken = user.authentication.idToken // Safe to send to the server
//            let fullName = user.profile.name
//            let givenName = user.profile.givenName
//            let familyName = user.profile.familyName
//            let email = user.profile.email
//            print(userId)
//            // ...
//        }
//    }
}


