//
//  WriteViewController.swift
//  Taily
//
//  Created by Ahmet Emre Gucer on 24.06.2019.
//  Copyright © 2019 Ahmet Emre Gucer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class WriteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    var letterLimit = true
    var genresA = ["Tür Seç", "Komedi", "Fantastik", "Macera", "Korku", "Romantik", "Rastgele","Hayali"]
    var selectedGenre = ""
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genresA.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genresA[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGenre = genresA[row]
    }
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var contentView: UITextView!
    @IBOutlet weak var genrePicker: UIPickerView!
    @IBOutlet weak var titleCounter: UILabel!
    @IBOutlet weak var contentCounter: UILabel!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        contentView.delegate = self
        contentView.layer.cornerRadius = 20
        ref = Database.database().reference()
    }
    
    @objc private func textFieldDidChange(textField: UITextField){
        
        if titleField.text != "" {
            titleCounter.text = "\(30 - titleField.text!.count)"
            if 30 - titleField.text!.count < 0 {
                titleCounter.textColor = UIColor.red
                letterLimit = false
            }else{
                titleCounter.textColor = UIColor.init(red: 0.0, green: 206.0, blue: 198.0, alpha: 1.0)
                letterLimit = true
            }
        }
        else{
            titleCounter.text = "30"
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if contentView.text != "" {
            contentCounter.text = "\(250 - contentView.text!.count)"
            if 250 - contentView.text!.count < 0 {
                contentCounter.textColor = UIColor.red
                letterLimit = false
            }else{
                contentCounter.textColor = UIColor.init(red: 0.0, green: 206.0, blue: 198.0, alpha: 1.0)
                letterLimit = true
            }
        }
        else{
            contentCounter.text = "250"
            letterLimit = false
        }
    }
    
    @IBAction func share(_ sender: Any) {
        if titleField.text  != "" && contentView.text != "" && selectedGenre != "Tür Seç" && selectedGenre != "" {
            if letterLimit{
                if !(titles.contains(titleField.text!)) {
                    titles  = []
                    owners = []
                    contents = []
                    likes = []
                    numbers = []
                    keys = []
                    genres = []
                    let data = ["title": titleField.text!, "owner": username, "number": "1", "likes": "0", "first": contentView.text!, "genre": selectedGenre]
                    let id = UUID()
                    ref.child("posts").child(id.uuidString).setValue(data)
                    var tempStoryline = [String] ()
                    tempStoryline.append(contentView.text!)
                    var tempContrubutors = [String] ()
                    tempContrubutors.append(username)
                    ref.child("posts").child(id.uuidString).child("storyline").setValue(tempStoryline)
                    ref.child("posts").child(id.uuidString).child("contributors").setValue(tempContrubutors)
                    performSegue(withIdentifier: "backSegue", sender: self)
                }else{
                    let alert = UIAlertController(title: "Hata", message: "Bu isimde bir hikaye daha önce yazılmış.", preferredStyle: .alert)
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
                }
            }else{
                let alert = UIAlertController(title: "Hata", message: "Lütfen istenilen harf limitlerini aşmayın.", preferredStyle: .alert)
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
            }
        }else{
            let alert = UIAlertController(title: "Hata", message: "Lütfen bütün boşlukları doldurun.", preferredStyle: .alert)
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
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentView.resignFirstResponder()
        titleField.resignFirstResponder()
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
