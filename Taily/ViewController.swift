//
//  ViewController.swift
//  Taily
//
//  Created by Ahmet Emre Gucer on 23.06.2019.
//  Copyright © 2019 Ahmet Emre Gucer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var createOutlet: UIButton!
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        loginOutlet.layer.cornerRadius = loginOutlet.frame.height/2
        createOutlet.layer.cornerRadius = createOutlet.frame.height/2
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            Auth.auth().signIn(withEmail: UserDefaults.standard.string(forKey: "email")!, password: UserDefaults.standard.string(forKey: "password")!) { [weak self] user, error in
                if error != nil {
                    self!.emailField.textColor = UIColor.red
                    self!.passwordField.textColor = UIColor.red
                    self!.emailField.attributedPlaceholder = NSAttributedString(string: "E-mail Adresi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                    self!.passwordField.attributedPlaceholder = NSAttributedString(string: "Sifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self!.emailField.textColor = UIColor.black
                        self!.passwordField.textColor = UIColor.black
                        self!.emailField.attributedPlaceholder = NSAttributedString(string: "E-mail Adresi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                        self!.passwordField.attributedPlaceholder = NSAttributedString(string: "Sifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                    })
                }else {
                    self!.performSegue(withIdentifier: "signInSegue", sender: self)
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        
        if emailField.text != "" && passwordField.text != "" {
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { [weak self] user, error in
                if error != nil {
                    self!.emailField.textColor = UIColor.red
                    self!.passwordField.textColor = UIColor.red
                    self!.emailField.attributedPlaceholder = NSAttributedString(string: "E-mail Adresi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                    self!.passwordField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                        self!.emailField.textColor = UIColor.black
                        self!.passwordField.textColor = UIColor.black
                        self!.emailField.attributedPlaceholder = NSAttributedString(string: "E-mail Adresi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                        self!.passwordField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                    })
                }else {
                    self!.performSegue(withIdentifier: "signInSegue", sender: self)
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(self!.emailField.text!, forKey: "email")
                    UserDefaults.standard.set(self!.passwordField.text!, forKey: "password")
                    UserDefaults.standard.synchronize()
                }
            }
            
        }else {
            emailField.textColor = UIColor.red
            passwordField.textColor = UIColor.red
            emailField.attributedPlaceholder = NSAttributedString(string: "E-mail Adresi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            passwordField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.emailField.textColor = UIColor.black
                self.passwordField.textColor = UIColor.black
                self.emailField.attributedPlaceholder = NSAttributedString(string: "E-mail Adresi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                self.passwordField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            })
        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


