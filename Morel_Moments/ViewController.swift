//
//  ViewController.swift
//  Morel_Moments
//
//  Created by Hassam Solano-Morel on 11/23/17.
//  Copyright © 2017 Hassam Solano-Morel. All rights reserved.
//

import UIKit
import MobileCoreServices
import Firebase

class ViewController: UIViewController {
    
   // private let storage: StorageReference = Storage.storage().reference().child("Moment1")
    private var elementURLs: [String] = []
    var database: DatabaseReference!


    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.database = Database.database().reference().child("Moment1")
        
        self.database.observe(.value) { (snap) in
            var urls:[String] = []
            
            print("I AM IN HERE!!")
            
            snap.children.forEach({ (element) in
                urls.append((element as! DataSnapshot).value as! String)
                print(urls[0])
            })
            
            self.elementURLs = urls
            
            print(self.elementURLs.count)
            self.collectionView.reloadData()
        }
        
        print(self.database.url)
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    private func uploadPhoto(data: Data){
    
    }
    
    private func uploadMovie(url: URL){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func didPressCameraButton(_ sender: Any) {
        self.collectionView.reloadData()
    }

    @IBAction func didPressLibraryButton(_ sender: Any) {
        let picker:UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        
        present(picker, animated: true, completion: nil)
    }
    
}

extension ViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let mediaType:String = info[UIImagePickerControllerMediaType] as? String else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        if mediaType == (kUTTypeImage as String){
            //User chose a photo
            if let photo = info[UIImagePickerControllerOriginalImage] as? UIImage,
                let imagedata = UIImageJPEGRepresentation(photo, 0.8) {
                
                uploadPhoto(data: imagedata)
                
            }
            
        }else if mediaType == (kUTTypeMovie as String){
            //User chose movie/live photo
            if let url = info[UIImagePickerControllerMediaURL] as? URL{
                
                uploadMovie(url: url)
                
            }
            
        }
     
    }

}
extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ImageCollectionCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "media_collection_cell", for: indexPath) as? ImageCollectionCell)!
        
        cell.image.sd_setImage(with: URL(string: "https://firebasestorage.googleapis.com/v0/b/morel-moments.appspot.com/o/Moment1%2FIMG_0507.JPG?alt=media&token=4d19c184-9a5f-45b1-bdf9-75d8e7dc4d9f"), placeholderImage: #imageLiteral(resourceName: "Screen Shot 2017-11-13 at 2.02.59 PM"), options: [.continueInBackground,.progressiveDownload])
        return cell
    }
}
