//
//  ViewController.swift
//  PixelFx
//
//  Created by SpexX on 08/12/15.
//  Copyright © 2015 Brian Pinsard. All rights reserved.
//

import UIKit

class ViewController:   UIViewController,
                        UIImagePickerControllerDelegate,
                        UINavigationControllerDelegate {

    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var filterIntensitySlider: UISlider!
    @IBOutlet weak var loadImageButton: UIButton!
    @IBOutlet weak var takePictureButton: UIButton!
    
    //var originalImage: UIImage?
    var filterImage: FilterImage!
    
    //var context: CIContext!
    //var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        filterImage = FilterImage(originalImage: mainImageView.image!)
        updatePreview()
    }

    @IBAction func filterIntensityChanged() {
        updatePreview()
    }
    
    func updatePreview() {
        let intensityValue = filterIntensitySlider.value
        mainImageView.image = filterImage.applyFilter(intensityValue)
    }
    
    @IBAction func saveImage() {
        print("saving to album")
        filterImage.saveToPhotosAlbum()
    }
    
    // Shows the ImagePicker, user can choose an image from the photo library
    @IBAction func showImagePicker(sender: UIButton) {
        print("loadImage() called!")
        
        let imagePicker = UIImagePickerController()
        
        //Sourcetypes: PhotoLibrary, Camera and SavedPhotosAlbum
        switch sender {
        case loadImageButton:
            imagePicker.sourceType = .PhotoLibrary
        case takePictureButton:
            imagePicker.sourceType = .Camera
        default:
            imagePicker.sourceType = .PhotoLibrary
        }
        
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    // UIImagePickerControllerDelegate 
    // Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("ImagePickerController() called")
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("OriginalImage")
            filterImage.setImage(pickedImage)
        } else {
            return
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        updatePreview()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
