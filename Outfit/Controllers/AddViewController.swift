//
//  AddViewController.swift
//  Outfit
//
//  Created by Lionel Maquet on 09/09/2020.
//  Copyright © 2020 Lionel Maquet. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UINavigationControllerDelegate {

    @IBAction func pickAPictureButtonTapped(_ sender: UIButton) {
        self.present(imagePicker!, animated: true)
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: UIImagePickerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker?.sourceType = .photoLibrary
        imagePicker!.delegate = self
        self.present(imagePicker!, animated: true)
    }
    
    @IBAction func validateButtonTapped(_ sender: UIButton) {
        if imageView.image != nil  {
            performSegue(withIdentifier: "goToDescriptionVC", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DescriptionViewController
        destinationVC.imagePicked = self.imageView.image
    }
    

}

extension AddViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = userPickedImage

        }
        
        imagePicker!.dismiss(animated: true, completion: nil)
    }
}
