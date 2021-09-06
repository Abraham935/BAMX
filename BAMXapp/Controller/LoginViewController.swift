//
//  LoginViewController.swift
//  BAMXapp
//
//  Created by user195828 on 9/4/21.
//

import UIKit
import Firebase

class LoginViewController: UIViewController
{
    let loginToMainMenu = "loginToMainMenu"
    
    @IBOutlet weak var enterEmail: UITextField!
    @IBOutlet weak var enterPassword: UITextField!
    
    var handle: AuthStateDidChangeListenerHandle?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enterEmail.delegate = self
        enterPassword.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        handle = Auth.auth().addStateDidChangeListener{ _, user in
            if user == nil{
                self.navigationController?.popToRootViewController(animated: true)
            }
            else
            {
                self.performSegue(withIdentifier: self.loginToMainMenu, sender: nil)
                self.enterEmail.text = nil
                self.enterPassword.text = nil
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let handle = handle else{return }
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    //Login
    @IBAction func loginDidTouch(_ sender:
    AnyObject) {
        //Require email & password
        guard
            let email = enterEmail.text,
            let password = enterPassword.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            return
        }
        
        //Start login code
        Auth.auth().signIn(withEmail: email, password: password){ user, error in
            if let error = error, user == nil {
                let alert = UIAlertController(
                    title: "Sign infailed :(",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //Sign up
    @IBAction func signUpDidTouch(_ sender:
    AnyObject) {
        // Register user
        guard
            let email = enterEmail.text,
            let password = enterPassword.text,
            !email.isEmpty,
            !password.isEmpty
        else {
            return
        }
        
        // Sign up code
        Auth.auth().createUser(withEmail: email, password: password) { _, error in
            if error == nil {
                Auth.auth().signIn(withEmail: email, password: password)
            }
            else
            {
                print("Error creating user: \(String(describing: error?.localizedDescription))")
            }
        }
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if textField == enterEmail
        {
            enterPassword.becomeFirstResponder()
        }
        
        if textField == enterPassword
        {
            textField.resignFirstResponder()
        }
        
        return true
    }
}