//
//  ExploreViewController.swift
//  Taily
//
//  Created by Ahmet Emre Gucer on 26.06.2019.
//  Copyright © 2019 Ahmet Emre Gucer. All rights reserved.
//

import UIKit
import Firebase

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    var genresA = ["Komedi", "Fantastik", "Macera", "Korku", "Romantik", "Rastgele", "Hayali"]
    var ref: DatabaseReference!
    
    @IBOutlet weak var backBtn: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        isSearching = false
        collection.reloadData()
        backBtn.isEnabled = false
        backBtn.alpha = 0.0
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return currentStoryArray.count
        }else {
            return genresA.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isSearching {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as? SearchCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.title.text = currentStoryArray[indexPath.row].title
            cell.usernameLbl.text = currentStoryArray[indexPath.row].owner
            cell.like.text = currentStoryArray[indexPath.row].like
            cell.content.text = currentStoryArray[indexPath.row].content
            return cell
        }else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "genreCell", for: indexPath) as? GenreCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.img.image = UIImage(named: genresA[indexPath.row])
            return cell
        }
    }
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearching = false
    
    var storyArray = [Story] ()
    var currentStoryArray = [Story] ()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpStories()
        setUpSearchBar()
        backBtn.isEnabled = false
        backBtn.alpha = 0.0
        ref = Database.database().reference()
    }
    
    private func setUpStories () {
        for i in 0..<keys.count {
            storyArray.append(Story(title: titles[i], content: contents[i], like:likes[i], owner:owners[i], genre: genres[i], number: numbers[i], key: keys[i]))
        }
        currentStoryArray = storyArray
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            isSearching = false
            currentStoryArray = storyArray
            collection.reloadData()
            return
        }
        currentStoryArray = storyArray.filter({ (story) -> Bool in
            isSearching = true
            return story.title.lowercased().contains(searchText.lowercased())
        })
        collection.reloadData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isSearching {
            selectedIndex = indexPath.row
            selectedKey  = currentStoryArray[selectedIndex].key
            selectedLikeNumber = Int(currentStoryArray[selectedIndex].like)!
            selectedTitle = currentStoryArray[selectedIndex].title
            selectedOwner = currentStoryArray[selectedIndex].owner
            selectedNum = Int(currentStoryArray[selectedIndex].number)!
            selectedFirst = currentStoryArray[selectedIndex].content
            selectedGen = currentStoryArray[selectedIndex].genre
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
                                                self.performSegue(withIdentifier: "exploreSegue", sender: self)
                                            }
                                        }
                                        if snapshot.childrenCount == 0 {
                                            self.performSegue(withIdentifier: "exploreSegue", sender: self)
                                        }
                                    })
                                }
                            }
                        })
                    }
                }
            })
        }else {
            var counter = 0
            currentStoryArray = []
            for story in storyArray {
                counter = counter + 1
                if story.genre == genresA[indexPath.row] {
                    currentStoryArray.append(story)
                }
                if counter == storyArray.count {
                    backBtn.isEnabled = true
                    backBtn.alpha = 1.0
                    isSearching = true
                    collection.reloadData()
                }
            }
        }
    }

}

class Story {
    let title: String
    let content:String
    let like: String
    let owner: String
    let genre: String
    let number: String
    let key: String
    
    init(title: String, content: String, like:String, owner:String, genre: String, number: String, key: String) {
        self.title = title
        self.content = content
        self.like = like
        self.owner = owner
        self.genre = genre
        self.number = number
        self.key = key
    }
}
