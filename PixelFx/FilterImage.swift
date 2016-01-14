//
//  FilterImage.swift
//  PixelFx
//
//  Created by SpexX on 09/01/16.
//  Copyright © 2016 Brian Pinsard. All rights reserved.
//

import UIKit

class FilterImage {
    var originalImage: UIImage
    
    var context: CIContext
    
    var currentFilter: CIFilter!
    var filterIntensityMultiplier: Float?
    var filterInputKey: String?
    
    init(originalImage: UIImage) {
        self.originalImage = originalImage
        
        let eaglContext = EAGLContext(API: .OpenGLES2)
        context = CIContext(EAGLContext: eaglContext, options: nil)
    }
    
    func setImage(originalImage: UIImage) {
        self.originalImage = originalImage
        initImageAndFilter()
    }
    
    func setFilter(filterName: String) -> Bool {
        currentFilter = CIFilter(name: filterName)
        initImageAndFilter()
        
        let filterProperties = Filters.properties[filterName]!
        
        if filterProperties != nil {
            filterInputKey = filterProperties!.inputKey
            filterIntensityMultiplier = filterProperties!.maxInputValue
        } else {
            filterInputKey = nil
            filterIntensityMultiplier = nil
            return false
        }
        
        return true
    }
    
    func applyFilter(intensityValue: Float) -> UIImage {
        if let inputKey = filterInputKey, let intensityMultiplier = filterIntensityMultiplier {
            currentFilter.setValue(intensityValue * intensityMultiplier, forKey: inputKey)
        }
        
        let cgImage = context.createCGImage(currentFilter.outputImage!, fromRect: currentFilter.outputImage!.extent)
        let filteredImage = UIImage(CGImage: cgImage)
        
        return filteredImage
    }
    
    private func initImageAndFilter() {
        let resizedImage = resizeImage(originalImage, size: CGFloat(450.0))
        let coreImage = CIImage(image: resizedImage)
        
        currentFilter.setValue(coreImage, forKey: kCIInputImageKey)
    }
    
    private func resizeImage(image: UIImage, size: CGFloat) -> UIImage {
        let imageRect = CGRectMake(0, 0, size, size)
        let newSize = CGSize(width: size, height: size)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(imageRect)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    func saveToPhotosAlbum() {
        let filter = CIFilter(name: currentFilter.name)!
        let coreImage = CIImage(image: originalImage)
        
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        
        if let inputKey = filterInputKey {
            filter.setValue(currentFilter.valueForKey(inputKey), forKey: inputKey)
        }
        
        let cgImage = context.createCGImage(filter.outputImage!, fromRect: filter.outputImage!.extent)
        let filteredImage = UIImage(CGImage: cgImage, scale: 1.0, orientation: originalImage.imageOrientation)  // Fix for random orientation swap!

        UIImageWriteToSavedPhotosAlbum(filteredImage, nil, nil, nil)
    }
}
