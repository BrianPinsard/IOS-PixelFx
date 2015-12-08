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
    
    var originalImage: UIImage?
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalImage = mainImageView.image
        context = CIContext(options: nil)
        currentFilter = CIFilter(name: "CISepiaTone")
        
        initFilter()
        applyFilter()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func filterIntensityChanged() {
        print("filterIntensityChanged() called!")
        applyFilter()
    }

    
    @IBAction func loadImage() {
        print("loadImage() called!")
        
        let imagePicker = UIImagePickerController()
        
        //Sourcetypes: PhotoLibrary, Camera and SavedPhotosAlbum
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func applyFilter() {
        currentFilter.setValue(filterIntensitySlider.value, forKey: kCIInputIntensityKey)
        
        print(currentFilter.outputImage!.extent)
        let cgImage = context.createCGImage(currentFilter.outputImage!, fromRect: currentFilter.outputImage!.extent)
        let filteredImage = UIImage(CGImage: cgImage)
        
        mainImageView.image = filteredImage;
    }
    
    func initFilter() {
        let coreImage = CIImage(image: originalImage!)
        currentFilter.setValue(coreImage, forKey: kCIInputImageKey)
        
        applyFilter()
    }
    
    // UIImagePickerControllerDelegate 
    // Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("ImagePickerController() called")
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("OriginalImage")
            originalImage = pickedImage
        } else if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            print("EditedImage")
            originalImage = pickedImage
        } else {
            return
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
        //mainImageView.image = originalImage
        initFilter()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

