//
//  StoryViewController.swift
//  Taily
//
//  Created by Ahmet Emre Gucer on 25.06.2019.
//  Copyright © 2019 Ahmet Emre Gucer. All rights reserved.
//

import UIKit
import Firebase

class StoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    var ref: DatabaseReference!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var blockBtn: UIButton!
    var holder = [String]()
    
    let nextBar = UIView()
    let txt = UITextView()
    
    var addViewText = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedStoryline.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < selectedStoryline.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! StoryCardTableViewCell
            cell.contentText.text = selectedStoryline[indexPath.row]
            cell.usernameLbl.text = "@\(selectedContributors[indexPath.row])"
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "lastCell", for: indexPath) as! LastTableViewCell
            cell.addText.delegate = self as UITextViewDelegate
            cell.addText.text = ""
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 195
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        txt.isEditable = false
        txt.isSelectable = false
        txt.backgroundColor = UIColor.clear
        txt.font = UIFont(name: "Helvetica Neue", size: 18)
        titleLbl.text = selectedTitle
        ref = Database.database().reference()
        if selectedLikes.contains(username) {
            likeBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
        if selectedOwner == username {
            blockBtn.isEnabled = false
        }
        titles  = []
        owners = []
        contents = []
        likes = []
        numbers = []
        keys = []
        genres = []
        genreLbl.text = selectedGen
    }
    
    @IBAction func likeTapped(_ sender: Any) {
        if !(selectedLikes.contains(username)) {
            selectedLikes.append(username)
            likeBtn.setImage(UIImage(named: "heart"), for: .normal)
            let data = ["title": selectedTitle, "owner": selectedOwner, "number": "\(selectedNum)", "likes": "\(selectedLikeNumber + 1)", "first": selectedFirst, "genre": selectedGen]
            ref.child("posts").child(selectedKey).setValue(data)
            ref.child("posts").child(selectedKey).child("peopleLiked").setValue(selectedLikes)
            ref.child("posts").child(selectedKey).child("storyline").setValue(selectedStoryline)
            ref.child("posts").child(selectedKey).child("contributors").setValue(selectedContributors)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        addViewText = textView.text
        if textView.text.count >= 250 {
            textView.textColor = UIColor.red
        }else{
            textView.textColor = UIColor.black
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            tableView.frame.size.height = tableView.frame.height + 285
            if addViewText != "" && addViewText.count < 250 {
                selectedStoryline.append(addViewText)
                selectedContributors.append(username)
                ref.child("posts").child(selectedKey).child("contributors").setValue(selectedContributors)
                ref.child("posts").child(selectedKey).child("storyline").setValue(selectedStoryline)
                tableView.reloadData()
            }else{
                let alert = UIAlertController(title: "Hata", message: "Paylaşımın 250 kelimelik limiti aşıyor. Hikayeni bölebilir veya kısaltabilirsin.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: { action in
                    self.tableView.frame.size.height = self.tableView.frame.height + 285
                    switch action.style{
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
            return false
        }
        return true
    }
    
    @IBAction func addTapped(_ sender: Any) {
        if addViewText != "" && addViewText.count < 250 {
            selectedStoryline.append(addViewText)
            selectedContributors.append(username)
            ref.child("posts").child(selectedKey).child("contributors").setValue(selectedContributors)
            ref.child("posts").child(selectedKey).child("storyline").setValue(selectedStoryline)
            tableView.reloadData()
        }else{
            let alert = UIAlertController(title: "Hata", message: "Paylaşımın 250 kelimelik limiti aşıyor. Hikayeni bölebilir veya kısaltabilirsin.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .cancel, handler: { action in
                self.tableView.frame.size.height = self.tableView.frame.height + 285
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func blockTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Bu Hikayeyi Bloklamak İstediğine Emin Misin?", message: "Eğer bloklarsan bu hikayeyi hesabından bir daha hiç okuyamayacaksın. Eğer bu hikayenin topluluk kurallarını çiğnediğini düşünüyorsan lütfen bizle Profil sayfandan iletişim kurmaktan çekinme.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Vazgeç", style: .cancel, handler: { action in
            }))
        alert.addAction(UIAlertAction(title: "Blokla", style: .destructive, handler: { action in
            blockedUsers.append(selectedKey)
            self.ref.child("users").child((Auth.auth().currentUser?.uid)!).child("blocked").setValue(blockedUsers)
            self.performSegue(withIdentifier: "storyBackSegue", sender: self)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: selectedStoryline.count, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        tableView.frame.size.height = tableView.frame.height - 285
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
