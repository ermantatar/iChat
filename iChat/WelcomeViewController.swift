//
//  WelcomeViewController.swift
//  iChat
//
//  Created by Erman Sahin Tatar on 8/7/18.
//  Copyright © 2018 Erman Sahin Tatar. All rights reserved.
//

import UIKit
import ProgressHUD


class WelcomeViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //Mark: IBActions

    @IBAction func loginButtonPressed(_ sender: Any) {
        dismissKeyboard()
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "" {
            self.loginUser()
        }else{
            ProgressHUD.showError("All fields are required!")
        }
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        dismissKeyboard()
        
        if emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != "" {
            
            if passwordTextField.text == repeatPasswordTextField.text {
                    registerUser()
            }else{
                ProgressHUD.showError("Passwords do not match!")
            }
            
            
        }else{
            ProgressHUD.showError("All fields are required!")
        }
    }
    
    @IBAction func backgroundTap(_ sender: Any) {
        dismissKeyboard()
    }
    
    
    //Mark: Helper Funtions
    fileprivate func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    fileprivate func cleanTextFields(){
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }
    
    fileprivate func loginUser(){
        ProgressHUD.show("Login...")
        
        
        FUser.loginUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
            
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
            }
            
            self.goToApp()
        }
    }
    
    fileprivate func registerUser(){
        
        performSegue(withIdentifier: "welcomeToFinishReg", sender: self)
        cleanTextFields()
        dismissKeyboard()
        
    }
    
    
    //MARK: GoToApp
    fileprivate func goToApp(){
        
        ProgressHUD.dismiss()
        cleanTextFields()
        dismissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID: FUser.currentId()])
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
            
        self.present(mainView, animated: true, completion: nil)
    
    }
    
    //MARK: Naviagtion
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let vc = segue.destination as! FinishRegistrationViewController
        vc.email = emailTextField.text! 
        vc.password = passwordTextField.text!
    }
}
