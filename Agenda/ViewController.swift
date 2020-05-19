//
//  ViewController.swift
//  Agenda
//
//  Created by Stefan Hermanus on 5/2/20.
//  Copyright © 2020 Stefan Corporation. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var backView: UIView!
    
    @IBOutlet var emailField: UITextField!
    @IBOutlet var passField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var errorText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("balik lagi bro")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Utilities.bottomBorderOnly(self.emailField)
        Utilities.bottomBorderOnly(self.passField)
        Utilities.bottomBorderOnly(self.nameField)

        self.backView.backgroundColor = UIColor(red: 75, green: 67, blue: 59).withAlphaComponent(0.8)
        self.backView.isOpaque = false

        let tap =  UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        loginBtn.layer.cornerRadius = loginBtn.frame.height/2
        loginBtn.setTitleColor(UIColor.white, for: .normal)
        signUpBtn.layer.cornerRadius = signUpBtn.frame.height/2
        signUpBtn.layer.borderColor = UIColor.white.cgColor
        signUpBtn.layer.borderWidth = 2
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func showError(_ message: String){
        if errorText.isHidden == true{
            UIView.animate(withDuration: 0.5) {
                self.errorText.isHidden = false
                self.errorText.text = message
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func validateFields() -> String?{
        print("validating")
        if self.emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || self.passField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill all the fields."
        }
        
        return nil
    }
    
    func moveToHome(){
        let homeViewController = (self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? HomeViewController)!
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    @IBAction func tapLogin(_ sender: Any) {
        if loginBtn.titleLabel?.text == "Back to Login"{
            UIView.animate(withDuration: 0.2) {
                self.passField.text = ""
                self.nameLabel.isHidden = true
                self.nameField.isHidden = true
                self.view.layoutIfNeeded()
            }
        }else{
            let email = self.emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let pass = self.passField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
                
                if error != nil{
                    self.showError("There was a problem.")
                }else{
                    self.moveToHome()
                }
            }
        }
    }
    
    @IBAction func tapSignup(_ sender: Any) {
        if nameField.isHidden == true{
            UIView.animate(withDuration: 0.5) {
                self.nameField.isHidden = false
                self.nameLabel.isHidden = false
                self.view.layoutIfNeeded()
            }
            loginBtn.setTitle("Back to Login", for: .normal)
        }else{
            let error = validateFields()
            if error != nil || self.nameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                showError(error!)
            }else{
                let name = nameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                print("\(name) passed in")
                let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                print("\(email) passed in")
                let pass = passField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                print("\(pass) passed in")
                Auth.auth().createUser(withEmail: email, password: pass) { (result, error) in
                    if error != nil{
                        self.showError(error!.localizedDescription)
                    }else{
                        print("creating user data")
                        let db = Firestore.firestore()
                        
                        db.collection("users").addDocument(data: ["Name": name, "uid": result!.user.uid]) { (error) in
                            
                            if error != nil{
                                self.showError("There was a problem, try again later.")
                            }
                        }
                        print("successfully created \(email)")
                        self.moveToHome()
                    }
                }
            }
        }
        
    }
}

extension UIColor{
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
}

