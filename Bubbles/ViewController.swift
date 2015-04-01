//
//  ViewController.swift
//  Bubbles
//
//  Created by Eric Ito on 3/31/15.
//  Copyright (c) 2015 Eric Ito. All rights reserved.
//

import UIKit

struct ImageParams {
    
    var text: NSString = ""
    var textColor = UIColor.blackColor()
    var borderWidth: CGFloat = 1.0
    var borderColor = UIColor.blackColor()
    var font = UIFont.systemFontOfSize(12.0)
    var fillColor = UIColor.whiteColor()
}

extension UIImage {
    
    class func bubbleImageWithParams(params: ImageParams) -> UIImage! {
        
        var textSize = params.text.sizeWithAttributes([NSFontAttributeName : params.font])
        
        let radius = textSize.height / 2
        
        let bubbleWidth = textSize.width + (2 * radius)
        let bubbleHeight = textSize.height + radius
        var bubbleSize = CGSize(width: bubbleWidth, height: bubbleHeight > bubbleWidth ? bubbleWidth : bubbleHeight)
        
        let inset = params.borderWidth / 2
        var rect = CGRect(x: inset, y: inset, width: bubbleSize.width - (2 * inset), height: bubbleSize.height - (2 * inset))
        
        UIGraphicsBeginImageContextWithOptions(bubbleSize, false, 0.0)
        
        let ctx = UIGraphicsGetCurrentContext()
        
        CGContextSetLineWidth(ctx, params.borderWidth / UIScreen.mainScreen().scale)
        CGContextSetStrokeColorWithColor(ctx, params.borderColor.CGColor)
        CGContextSetFillColorWithColor(ctx, params.fillColor.CGColor)

        let bezier = UIBezierPath(roundedRect: rect, cornerRadius: (bubbleSize.height - 2) / 2)
        CGContextAddPath(ctx, bezier.CGPath)
        CGContextDrawPath(ctx, kCGPathEOFillStroke)
        
        let textRect = CGRect(x: radius, y: (rect.height - textSize.height) / 2, width: textSize.width, height: textSize.height)
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.Center
        params.text.drawInRect(textRect, withAttributes: [
            NSForegroundColorAttributeName : params.textColor,
            NSFontAttributeName : params.font,
            NSParagraphStyleAttributeName : textStyle]
        )
        
//        CGContextStrokeRect(ctx, textRect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

class ViewController: UIViewController{

    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var borderWidthSlider: UISlider!
    @IBOutlet weak var numberSlider: UISlider!
    
    
    
    private var borderWidth: CGFloat = 1.0 {
        didSet {
            resetImage()
        }
    }
    
    private var value: Int = 0 {
        didSet {
            resetImage()
        }
    }
    
    func resetImage() {
        
        var params = ImageParams()
        params.text = "\(value)"
        params.borderWidth = borderWidth
        params.textColor = UIColor.whiteColor()
        params.borderColor = UIColor.blackColor()
        params.fillColor = UIColor.orangeColor()
        params.font = UIFont.systemFontOfSize(64)
        imageView.image = UIImage.bubbleImageWithParams(params)
        imageView.frame.size = imageView.image!.size
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        title = "Bubbles"

        let image = imageWithNumber(0)
        imageView.frame.size = image.size
        imageView.image = image
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        
        value = Int(sender.value)
    }

    @IBAction func borderValueChanged(sender: UISlider) {
        
        borderWidth = CGFloat(sender.value)
    }
    
    func imageWithNumber(num: Int) -> UIImage! {
        
        var params = ImageParams()
        params.text = "\(num)"
        params.borderWidth = 2
        params.textColor = UIColor.whiteColor()
        params.borderColor = UIColor.blackColor()
        params.fillColor = UIColor.orangeColor()
        params.font = UIFont.systemFontOfSize(64)
        return UIImage.bubbleImageWithParams(params)
    }

}

