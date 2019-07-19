//
//  ProfileViewController.swift
//  Taily
//
//  Created by Ahmet Emre Gucer on 26.06.2019.
//  Copyright © 2019 Ahmet Emre Gucer. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var ref: DatabaseReference!

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if userKeys.count != 0 {
            return userKeys.count
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! UserStoryCollectionViewCell
        if userTitles.count != 0 {
            cell.contentText.text = userContents[indexPath.row]
            cell.titleLbl.text = userTitles[indexPath.row]
            cell.likeLbl.text = userLikes[indexPath.row]
            cell.usernameLbl.text = "@\(Userowners[indexPath.row])"
        }else {
            cell.contentText.text = "Şimdiye kadar hiç hıkaye yazmadın ama ilk hikayeni ana sayfadaki kalem ikonuna basarak yazabilirsin."
            cell.titleLbl.text = "Hiç Hikayen Yok"
            cell.likeLbl.text = "0"
            cell.usernameLbl.text = ""
        }
        return cell
    }
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        let nameLetter = name.prefix(1).lowercased()
        profileImg.image = UIImage(named: nameLetter)
        nameLbl.text = name
        usernameLbl.text = "@\(username)"
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if userTitles.count != 0 {
            selectedIndex = indexPath.row
            selectedKey  = userKeys[selectedIndex]
            selectedLikeNumber = Int(userLikes[selectedIndex])!
            selectedTitle = userTitles[selectedIndex]
            selectedOwner = Userowners[selectedIndex]
            selectedNum = Int(userNumbers[selectedIndex])!
            selectedFirst = userContents[selectedIndex]
            selectedGen = userGenres[selectedIndex]
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
                                                userTitles = []
                                                userContents = []
                                                Userowners = []
                                                userLikes = []
                                                userNumbers = []
                                                userGenres = []
                                                userKeys =  []
                                                self.performSegue(withIdentifier: "profileStorySegue", sender: self)
                                            }
                                        }
                                        if snapshot.childrenCount == 0 {
                                            userTitles = []
                                            userContents = []
                                            Userowners = []
                                            userLikes = []
                                            userNumbers = []
                                            userGenres = []
                                            userKeys = []
                                            self.performSegue(withIdentifier: "profileStorySegue", sender: self)
                                        }
                                    })
                                }
                            }
                        })
                    }
                }
            })
        }
    }
    
    @IBAction func reportTepped(_ sender: Any) {
        if let url = NSURL(string: "https://forms.gle/KxxbT2fXPYfDgpwy6") {
            UIApplication.shared.openURL(url as URL)
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
