//
//  SignUpViewController.swift
//  ClubCatch
//
//  Created by Ahmet Emre Gucer on 31.05.2019.
//  Copyright © 2019 Ahmet Emre Gucer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController{
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordAgainField: UITextField!
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var createOutlet: UIButton!
    

    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        loginOutlet.layer.cornerRadius = loginOutlet.frame.height/2
        createOutlet.layer.cornerRadius = createOutlet.frame.height/2
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordAgainField.resignFirstResponder()
        nameField.resignFirstResponder()
        usernameField.resignFirstResponder()
    }
    
    @IBAction func submitTapped(_ sender: Any) {
        if nameField.text != "" && usernameField.text != "" && emailField.text != "" && passwordAgainField.text != "" && passwordAgainField.text != "" {
            if passwordAgainField.text == passwordField.text {
                self.ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
                    var count = 0
                    for child in snapshot.children {
                        count = count + 1
                        let snap = child as! DataSnapshot
                        let value = snap.value as! NSDictionary
                        let username = value["username"] as! String
                        if self.usernameField.text! == username {
                            self.usernameField.textColor = UIColor.red
                        }
                        else {
                            print(count)
                            print(snapshot.childrenCount)
                            if count == snapshot.childrenCount {
                                Auth.auth().createUser(withEmail: self.emailField.text!, password: self.passwordField.text!) { authResult, error in
                                    if error != nil {
                                        let alert = UIAlertController(title: "Hata", message: "Geçersiz e-mail adresi veya şifre", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: { action in
                                            switch action.style{
                                            case .default:
                                                print("default")
                                                
                                            case .cancel:
                                                print("cancel")
                                                
                                            case .destructive:
                                                print("destructive")
                                            }}))
                                        self.present(alert, animated: true, completion: nil)
                                        print(error as Any)
                                    }else {
                                        //do the database auth with other data
                                        print("here")
                                        self.ref.child("users").child((Auth.auth().currentUser?.uid)!).setValue(["name": self.nameField.text!, "username": self.usernameField.text!, "approved": "true"])
                                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                                        UserDefaults.standard.set(self.emailField.text!, forKey: "email")
                                        UserDefaults.standard.set(self.passwordField.text!, forKey: "password")
                                        UserDefaults.standard.synchronize()
                                        self.performSegue(withIdentifier: "signUpSegue", sender: self)
                                    }
                                }
                            }
                        }
                    }
                })
            }else {
                passwordField.textColor = UIColor.red
                passwordAgainField.textColor = UIColor.red
                passwordField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                passwordAgainField.attributedPlaceholder = NSAttributedString(string: "Şifre  Yeniden", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    self.passwordField.textColor = UIColor.black
                    self.passwordAgainField.textColor = UIColor.black
                    self.passwordField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                    self.passwordAgainField.attributedPlaceholder = NSAttributedString(string: "Şifre Yeniden", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                })
            }
        }else {
            nameField.textColor = UIColor.red
            usernameField.textColor = UIColor.red
            emailField.textColor = UIColor.red
            passwordField.textColor = UIColor.red
            passwordAgainField.textColor = UIColor.red
            nameField.attributedPlaceholder = NSAttributedString(string: "Ad Soyad", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            usernameField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı Adı", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            emailField.attributedPlaceholder = NSAttributedString(string: "E-mail Adresi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            passwordField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            passwordAgainField.attributedPlaceholder = NSAttributedString(string: "Şifre Yeniden", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                self.nameField.textColor = UIColor.black
                self.usernameField.textColor = UIColor.black
                self.emailField.textColor = UIColor.black
                self.passwordField.textColor = UIColor.black
                self.passwordAgainField.textColor = UIColor.black
                self.nameField.attributedPlaceholder = NSAttributedString(string: "Ad Soyad", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                self.usernameField.attributedPlaceholder = NSAttributedString(string: "Kullanıcı Adı", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                self.emailField.attributedPlaceholder = NSAttributedString(string: "E-mail Adresi", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                self.passwordField.attributedPlaceholder = NSAttributedString(string: "Şifre", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
                self.passwordAgainField.attributedPlaceholder = NSAttributedString(string: "Şifre Yeniden", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
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
