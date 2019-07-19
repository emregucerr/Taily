//
//  HomeViewController.swift
//  Taily
//
//  Created by Ahmet Emre Gucer on 24.06.2019.
//  Copyright © 2019 Ahmet Emre Gucer. All rights reserved.
//

import UIKit
import Firebase

var  username =  ""
var name = ""
var titles = [String] ()
var contents = [String] ()
var owners = [String] ()
var likes = [String] ()
var numbers = [String] ()
var genres = [String] ()
var userTitles = [String] ()
var userContents = [String] ()
var Userowners = [String] ()
var userLikes = [String] ()
var userNumbers = [String] ()
var userGenres = [String] ()
var selectedIndex = 0
var selectedTitle = ""
var selectedOwner = ""
var selectedKey = ""
var selectedLikes = [String] ()
var selectedLikeNumber = 0
var selectedNum = 0
var selectedFirst = ""
var selectedGen = ""
var selectedStoryline = [String] ()
var selectedContributors = [String] ()

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var ref: DatabaseReference!
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if keys.count != 0 {
            return keys.count
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! StoryCollectionViewCell
        if titles.count != 0 {
            cell.title.text = titles[indexPath.row]
            cell.content.text = contents[indexPath.row]
            cell.usernameLbl.text = "@\(owners[indexPath.row])"
            cell.likeLbl.text = likes[indexPath.row]
        }else{
            cell.title.text = "Hiçbir Başlık Bulunamadı"
            cell.content.text = "Hiçbir Hikaye Bulunamadı"
            cell.usernameLbl.text = ""
            cell.likeLbl.text = "0"
        }
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Carry it to LoadViewController later on.
        ref = Database.database().reference()
        selectedIndex = 0
        selectedKey  = ""
        selectedLikeNumber = 0
        selectedTitle = ""
        selectedOwner = ""
        selectedLikes = []
        selectedStoryline = []
        selectedContributors = []
        selectedGen = ""
    }
    @IBAction func logOut(_ sender: Any) {
        UserDefaults.standard.set("", forKey: "email")
        UserDefaults.standard.set("", forKey: "password")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        performSegue(withIdentifier: "logOutSegue", sender: self)
    }
    @IBAction func refresh(_ sender: Any) {
        titles  = []
        owners = []
        contents = []
        likes = []
        numbers = []
        keys = []
        genres = []
        performSegue(withIdentifier: "refreshSegue", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        selectedKey  = keys[selectedIndex]
        selectedLikeNumber = Int(likes[selectedIndex])!
        selectedTitle = titles[selectedIndex]
        selectedOwner = owners[selectedIndex]
        selectedNum = Int(numbers[selectedIndex])!
        selectedFirst = contents[selectedIndex]
        selectedGen = genres[selectedIndex]
        ref.child("posts").child(selectedKey).child("storyline").observeSingleEvent(of: .value, with: { (snapshot) in
            var counter = 0
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let value = snap.value
                selectedStoryline.append(value as? String ?? "")
                counter = counter + 1
                if counter == snapshot.childrenCount {
                    self.ref.child("posts").child(selectedKey).child("contributors").observeSingleEvent(of: .value, with: { (snapshot) in
                        var counter = 0
                        for child in snapshot.children {
                            let snap = child as! DataSnapshot
                            let value = snap.value
                            selectedContributors.append(value as? String ?? "")
                            counter = counter + 1
                            if counter == snapshot.childrenCount {
                                self.ref.child("posts").child(selectedKey).child("peopleLiked").observeSingleEvent(of: .value, with: { (snapshot) in
                                    var counter = 0
                                    for child in snapshot.children {
                                        let snap = child as! DataSnapshot
                                        let value = snap.value
                                        selectedLikes.append(value as? String ?? "")
                                        counter = counter + 1
                                        if counter == snapshot.childrenCount {
                                            self.performSegue(withIdentifier: "storySegue", sender: self)
                                        }
                                    }
                                    if snapshot.childrenCount == 0 {
                                        self.performSegue(withIdentifier: "storySegue", sender: self)
                                    }
                                })
                            }
                        }
                    })
                }
            }
        })
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
