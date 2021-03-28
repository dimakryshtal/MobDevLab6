//
//  PhotosViewController.swift
//  MobDevLab1
//
//  Created by Dima on 14.03.2021.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var arrayOfPictures = [Photo]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let layout = collectionView?.collectionViewLayout as? MyCollectionViewLayout {
            layout.delegate = self
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCollectionViewCell")
        getPictures()
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
 
    func getPictures() {
        NetworkManager.sharad.getPhotos(with: "small+animals", count: 18) { [weak self](data, error) in
            
            if let data = data {
                if let photos = Manager.shared.parseJSON(data: data, type: Photos.self) {
                    self?.arrayOfPictures = photos.hits
                    self?.collectionView.reloadData()
                }
                self?.collectionView.reloadData()
            }
            
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfPictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        cell.configure(url: arrayOfPictures[indexPath.item].largeImageURL)

        
        return cell
    }
    
    
}


extension PhotosViewController: MyCollectionViewLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if((indexPath.item + 1) % 6 == 1) {
            return collectionView.frame.width/5*3
        } else if (((indexPath.item + 1) % 6 == 2 ) || (indexPath.item + 1) % 6 == 3) {
            return collectionView.frame.width/5*2
        } else {
            return collectionView.frame.width/5
        }
    }
}

extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBAction func openPhotos() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let newImage = info[.originalImage] as? UIImage else { return }
        collectionView.reloadData()
    }
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



