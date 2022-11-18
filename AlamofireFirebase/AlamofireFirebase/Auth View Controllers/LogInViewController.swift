//
//  LogInViewController.swift
//  AlamofireFirebase
//
//  Created by Артём on 14.11.2022.
//

import UIKit
import FirebaseCore
import FirebaseDatabase
import GoogleSignIn
import FirebaseAuth

class LogInViewController: UIViewController {
    
    var userProfile: UserProfile?
    private var provider: String?
    
    lazy var googleButton: GIDSignInButton = {
        let loginButton = GIDSignInButton()
        loginButton.frame = CGRect(x: 32, y: 360, width: view.frame.width - 64, height: 50)
        loginButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        return loginButton
    }()
    
    lazy var customGoogleLoginButton: UIButton = {

        let loginButton = UIButton()
        loginButton.frame = CGRect(x: 32, y: 360 + 80 , width: view.frame.width - 64, height: 50)
        loginButton.backgroundColor = .white
        loginButton.setTitle("Custom login button with Google", for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        loginButton.setTitleColor(.gray, for: .normal)
        loginButton.layer.cornerRadius = 4
        loginButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        return loginButton
    }()
    
    lazy var signInWithEmail: UIButton = {
        
        let loginButton = UIButton()
        loginButton.frame = CGRect(x: 32, y: 360 + 80 + 80 , width: view.frame.width - 64, height: 50)
        loginButton.setTitle("Sign In with Email", for: .normal)
        loginButton.addTarget(self, action: #selector(openSignInVC), for: .touchUpInside)
        return loginButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(googleButton)
        view.addSubview(customGoogleLoginButton)
        view.addSubview(signInWithEmail)
        
        view.addVerticalGradientLayer(topColor: topColor, bottomColor: bottomColor)
       
    }
    
    private func saveIntoFirebase() {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        userProfile = UserProfile(id: 12, name: "ffff", email: "artem@mail.ru")
        
        let userData = ["name": userProfile?.name, "email": userProfile?.email]
        
        
        let values = [uid: userData]
        
        Database.database().reference().child("users").updateChildValues(values) { (error, _) in
            
            if let error = error {
                print(error)
                return
            }
            
            print("Successfully saved user into firebase database")
            self.openMainViewController()
        }
    }
    
    @objc func signOut() {
        GIDSignIn.sharedInstance.signOut()
     
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
    
    @objc private func handleCustomGoogleLogin() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error {
                print("Failsed to log into Google: ", error)
                return
            }
            print("Successfully logged into Google")
            
            if let userName = user?.profile?.name, let userEmail = user?.profile?.email {
                userProfile = UserProfile(id: nil, name: userName, email: userEmail)
            }
            
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {return}
            
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { user , error in
                if let error = error {
                    print("Something went wrong with our Google user: ", error)
                    return
                }
                
                print("Successfully logged into Firebase with Google")
                self.saveIntoFirebase()
            }
            
        }
    }
    
    @objc  func openMainViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func openSignInVC() {
        //performSegue(withIdentifier: "SignIn", sender: nil)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let signinViewController = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInViewController
        present(signinViewController, animated: true)
    }
    
   
    
    
}

