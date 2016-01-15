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

    @IBOutlet weak var filterNameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var filterIntensitySlider: UISlider!
    
    @IBOutlet weak var loadImageButton: UIBarButtonItem!
    @IBOutlet weak var takePictureButton: UIBarButtonItem!
    @IBOutlet weak var saveImageButton: UIBarButtonItem!
    
    var filterImage: FilterImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Preview"
        
        filterImage = FilterImage(originalImage: mainImageView.image!)
        
        let sliderState = filterImage.setFilter(Filters.SEPIA)
        filterIntensitySlider.enabled = sliderState
        
        updatePreview()
    }

    @IBAction func filterIntensityChanged() {
        updatePreview()
    }
    
    func updatePreview() {
        filterNameLabel.text = CIFilter.localizedNameForFilterName(filterImage.currentFilter.name)
        let intensityValue = filterIntensitySlider.enabled ? filterIntensitySlider.value : 0.0
        
        mainImageView.image = filterImage.applyFilter(intensityValue)
    }
    
    @IBAction func saveImage() {
        print("saving to album")
        filterImage.saveToPhotosAlbum()
    }
    
    @IBAction func unwindFromFilters(segue: UIStoryboardSegue) {
        let filtersController = segue.sourceViewController as! FiltersTableViewController
        
        if let selectedFilter = filtersController.selectedFilter {
            filterIntensitySlider.enabled = filterImage.setFilter(selectedFilter)
            
            if(!filterIntensitySlider.enabled) {
                    setSliderValue(0.0)
            }
            
            updatePreview()
        }
    }
    
    func setSliderValue(intensityValue: Float) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.filterIntensitySlider.setValue(intensityValue, animated: true)
        })
    }
    
    // Designate this viewcontroller as first responder to handle motion events
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // Handling the shake motion event
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent?) {
        if motion == .MotionShake && filterIntensitySlider.enabled {
            print("shake shake shake!")
            let intensityValue = filterIntensitySlider.value
            let shakeValue: Float = intensityValue > (1 - intensityValue) ? 0.0 : 1.0
            
            setSliderValue(shakeValue)
            
            filterIntensityChanged()
        }
    }
    
    // Shows the ImagePicker, user can choose an image from the photo library
    @IBAction func showImagePicker(sender: UIBarButtonItem) {
        let imagePicker = UIImagePickerController()
        
        //Sourcetypes: PhotoLibrary, Camera and SavedPhotosAlbum
        switch sender {
        case loadImageButton:
            imagePicker.sourceType = .PhotoLibrary
        case takePictureButton:
            imagePicker.sourceType = .Camera
        default:
            break
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
