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
    
    init(originalImage: UIImage) {
        self.originalImage = originalImage
        
        let eaglContext = EAGLContext(API: .OpenGLES2)
        context = CIContext(EAGLContext: eaglContext, options: nil)
        
        currentFilter = CIFilter(name: "CISepiaTone") //TODO: dynamic filter
        initImageAndFilter()
    }
    
    func setImage(originalImage: UIImage) {
        self.originalImage = originalImage
        initImageAndFilter()
    }
    
    func applyFilter(intensityValue: Float) -> UIImage {
        currentFilter.setValue(intensityValue, forKey: kCIInputIntensityKey)
        
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
        let filter = CIFilter(name: "CISepiaTone")!
        let coreImage = CIImage(image: originalImage)
        
        filter.setValue(coreImage, forKey: kCIInputImageKey)
        filter.setValue(currentFilter.valueForKey(kCIInputIntensityKey), forKey: kCIInputIntensityKey)
        
        let cgImage = context.createCGImage(filter.outputImage!, fromRect: filter.outputImage!.extent)
        let filteredImage = UIImage(CGImage: cgImage, scale: 1.0, orientation: originalImage.imageOrientation)  // Fix for random orientation swap!
        
        UIImageWriteToSavedPhotosAlbum(filteredImage, nil, nil, nil)
    }
}
