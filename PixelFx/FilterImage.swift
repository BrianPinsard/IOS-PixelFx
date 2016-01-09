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
        
        currentFilter = CIFilter(name: "CISepiaTone")
        initImageAndFilter()
    }
    
    func setImage(originalImage: UIImage) {
        self.originalImage = originalImage
        initImageAndFilter()
    }
    
    func applyFilter(intensityValue: Float) -> UIImage {
        currentFilter.setValue(intensityValue, forKey: kCIInputIntensityKey)
        
        print(currentFilter.outputImage!.extent)
        
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
}
