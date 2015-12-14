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
        
        let eaglContext = EAGLContext(API: .OpenGLES2)
        context = CIContext(EAGLContext: eaglContext, options: nil)
        
        currentFilter = CIFilter(name: "CISepiaTone")
        
        initFilter()
        applyFilter()
    }

    @IBAction func filterIntensityChanged() {
        print("filterIntensityChanged() called!")
        applyFilter()
    }
    
    func applyFilter() {
        currentFilter.setValue(filterIntensitySlider.value, forKey: kCIInputIntensityKey)
        
        print(currentFilter.outputImage!.extent)
        
        let cgImage = context.createCGImage(currentFilter.outputImage!, fromRect: currentFilter.outputImage!.extent)
        let filteredImage = UIImage(CGImage: cgImage)
        
        mainImageView.image = filteredImage;
    }
    
    func initFilter() {
        let resizedImage = resizeImage(originalImage!, size: CGFloat(450.0))
        let coreImage = CIImage(image: resizedImage)
        
        currentFilter.setValue(coreImage, forKey: kCIInputImageKey)
        
        applyFilter()
    }
    
    func resizeImage(image: UIImage, size: CGFloat) -> UIImage {
        let imageRect = CGRectMake(0, 0, size, size)
        let newSize = CGSize(width: size, height: size)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(imageRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage!
    }
    
    // Shows the ImagePicker, user can choose an image from the photo library
    @IBAction func showImagePicker() {
        print("loadImage() called!")
        
        let imagePicker = UIImagePickerController()
        
        //Sourcetypes: PhotoLibrary, Camera and SavedPhotosAlbum
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    // UIImagePickerControllerDelegate 
    // Methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        print("ImagePickerController() called")
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            print("OriginalImage")
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
