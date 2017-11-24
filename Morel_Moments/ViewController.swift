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
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.progressBar.isHidden = true
        
        self.database = Database.database().reference().child("Moment1")
        
        self.database.observe(.value) { (snap) in
            var urls:[String] = []
            
            print("I AM IN HERE!!")
            
            snap.children.forEach({ (element) in
                urls.append((element as! DataSnapshot).value as! String)
            })
            
            self.elementURLs = urls
            self.collectionView.reloadData()
        }
    }
    
    private func uploadPhoto(data: Data){
        let databaseRef:DatabaseReference = self.database.childByAutoId()
        
        let storageRef:StorageReference = Storage.storage().reference(withPath: "Moment1/\(databaseRef.key)")
        let metadata:StorageMetadata = StorageMetadata()
        
        metadata.contentType = "image/jpeg"
        
        let uploadTask:StorageUploadTask = storageRef.putData(data, metadata: metadata) { (meta, err) in
            if(err != nil){
                print("Got an error: \(String(describing: err?.localizedDescription))")
            }else{
                print("Image uploaded! Metatdata: \(String(describing: meta))")
                databaseRef.setValue(meta?.downloadURL()?.absoluteString)
                
            }
        }
    
        uploadTask.observe(.progress) { [weak self] (snap) in
            //CODE HERE: To track upload progress of an image.
            guard let strongSelf = self else{ return }
            guard let progress = snap.progress else{ return }
            
            strongSelf.progressBar.isHidden = false
            strongSelf.progressBar.progress = Float(progress.fractionCompleted)
        }
        uploadTask.observe(.success) { [weak self] (snap) in
            guard let strongSelf = self else{ return }
            
            strongSelf.progressBar.progress = 0
            strongSelf.progressBar.isHidden = true
        }
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
        dismiss(animated: true, completion: nil)
     
    }

}
extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.elementURLs.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ImageCollectionCell = (collectionView.dequeueReusableCell(withReuseIdentifier: "media_collection_cell", for: indexPath) as? ImageCollectionCell)!
        
        cell.image.sd_setImage(with: URL(string: self.elementURLs[indexPath.row]), placeholderImage: #imageLiteral(resourceName: "Screen Shot 2017-11-13 at 2.02.59 PM"), options: [.continueInBackground,.progressiveDownload])
        return cell
    }
}
