//
//  LoadViewController.swift
//  Taily
//
//  Created by Ahmet Emre Gucer on 24.06.2019.
//  Copyright © 2019 Ahmet Emre Gucer. All rights reserved.
//

import UIKit
import Firebase
var keys = [String] ()
var userKeys = [String] ()
var blockedUsers = [String] ()

class LoadViewController: UIViewController {
    var ref: DatabaseReference!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userTitles = []
        userContents = []
        Userowners = []
        userLikes = []
        userNumbers = []
        userGenres = []
        userKeys =  []
        blockedUsers = []
        titles = []
        owners = []
        contents = []
        likes = []
        numbers = []
        genres = []
        keys = []
        indicator.startAnimating()
        ref = Database.database().reference()
    }
    override func viewDidAppear(_ animated: Bool) {
        getUserInfo()
    }
    
    func getUserInfo() {
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            username = value?["username"] as? String ?? ""
            name = value?["name"] as? String ?? ""
        }) { (error) in
            print(error.localizedDescription)
        }
        self.ref.child("users").child(userID!).child("blocked").observeSingleEvent(of: .value, with: { (snapshot) in
            var counter = 0
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value
                blockedUsers.append(value as? String ?? "")
                counter = counter + 1
                if counter == snapshot.childrenCount {
                    self.getKeys()
                }
            }
            if snapshot.childrenCount == 0 {
                self.getKeys()
            }
        })
    }
    
    func getKeys() {
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            var counter = 0
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                if !(blockedUsers.contains(key)) {
                    keys.append(key)
                }
                counter = counter + 1
                if counter == snapshot.childrenCount {
                    self.getPosts()
                }
            }
        })
    }
    
    func getPosts () {
        var counter = 0
        for key in keys {
            ref.child("posts").child(key).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                let value = snapshot.value as? NSDictionary
                let title = value?["title"] as? String ?? ""
                let content = value?["first"] as? String ?? ""
                let owner  = value?["owner"] as? String ?? ""
                let like  = value?["likes"] as? String ?? ""
                let number  = value?["number"] as? String ?? ""
                let genre  = value?["genre"] as? String ?? ""
                genres.append(genre)
                titles.append(title)
                contents.append(content)
                owners.append(owner)
                likes.append(like)
                numbers.append(number)
                if owner == username {
                    userGenres.append(genre)
                    userTitles.append(title)
                    userContents.append(content)
                    Userowners.append(owner)
                    userLikes.append(like)
                    userNumbers.append(number)
                    userKeys.append(key)
                }
                counter  = counter + 1
                if counter == keys.count {
                    self.performSegue(withIdentifier: "loadSegue", sender: self)
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
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
