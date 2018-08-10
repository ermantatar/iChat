//
//  FinishRegistrationViewController.swift
//  iChat
//
//  Created by Erman Sahin Tatar on 8/7/18.
//  Copyright © 2018 Erman Sahin Tatar. All rights reserved.
//

// 347 583 18 83

import UIKit
import ProgressHUD

class FinishRegistrationViewController: UIViewController {

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var email: String!
    var password: String!
    var avatarImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(email, password)

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonPressed(_ sender: Any) {
        cleanTextFields()
        dismissKeyboard()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissKeyboard()
        ProgressHUD.show("Registering...")
        
        if nameTextField.text != "" && lastnameTextField.text != "" && countryTextField.text != "" && cityTextField.text != "" && phoneTextField.text != "" {
            
            FUser.registerUserWith(email: email!, password: password!, firstName: nameTextField.text!, lastName: lastnameTextField.text!) { (error) in
                
                if error != nil {
                    ProgressHUD.dismiss()
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                self.registerUser()
            }
        } else {
            ProgressHUD.showError("All fields are required!")
        }
        
        
    }
    
    //Mark: Helper Funtions
    
    fileprivate func registerUser(){
        
        let fullname = nameTextField.text! + " " + lastnameTextField.text!
        
        var tempDictionary: Dictionary = [kFIRSTNAME : nameTextField.text!, kLASTNAME : lastnameTextField.text!, kFULLNAME : fullname, kCOUNTRY: countryTextField.text!, kCITY : cityTextField.text!, kPHONE: phoneTextField.text!] as [String: Any]
        
        if avatarImage == nil {
            
            imageFromInitials(firstName: nameTextField.text!, lastName: lastnameTextField.text!) { (avatarInitials) in
                
                let avatarIMG = UIImageJPEGRepresentation(avatarInitials, 0.7)
                let avatar = avatarIMG!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                tempDictionary[kAVATAR] = avatar
                
                //finish registration
                self.finishRegistration(withValues: tempDictionary)
            }
            
        }else {
            // if we have an avatar
            
            let avatarData = UIImageJPEGRepresentation(avatarImage!, 0.7)
            let avatar = avatarData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            tempDictionary[kAVATAR] = avatar
            
            //finish registration
            self.finishRegistration(withValues: tempDictionary)
            
        }
        
    }
    
    fileprivate func finishRegistration(withValues: [String: Any]) {
        
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            
            if error != nil {
                
                DispatchQueue.main.async {
                    ProgressHUD.showError(error!.localizedDescription)
                }
                
                return
            }
            
            ProgressHUD.dismiss()
            // if there is no error,
            // go to application
            self.goToApp()
        }
    }
    
    fileprivate func goToApp(){
        cleanTextFields()
        dismissKeyboard()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID: FUser.currentId()])
        
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
    }
    
    fileprivate func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    fileprivate func cleanTextFields(){
        nameTextField.text = ""
        lastnameTextField.text = ""
        countryTextField.text = ""
        cityTextField.text = ""
        phoneTextField.text = ""
        
    }
    
    

}
