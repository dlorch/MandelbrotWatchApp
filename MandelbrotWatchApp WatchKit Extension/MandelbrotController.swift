//
//  MandelbrotController.swift
//  MandelbrotWatchApp WatchKit Extension
//
//  Created by Daniel Lorch on 15.06.19.
//  Copyright © 2019 Daniel Lorch. All rights reserved.
//

import WatchKit
import Foundation


class MandelbrotController: WKInterfaceController {

    @IBOutlet weak var image: WKInterfaceImage!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        let bounds            = self.contentFrame.size
        let maxIteration: Int = 1000
        let width: Int        = Int(bounds.width)
        let height: Int       = Int(bounds.height)
        
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
        
        var palette:[CGColor] = []
        for i in 0 ..< maxIteration {
            palette.append(UIColor(hue: CGFloat(i)/256.0, saturation: 1, brightness: CGFloat(i)/(CGFloat(i)+8.0), alpha: 1).cgColor)
        }
        
        // see https://en.wikipedia.org/wiki/Mandelbrot_set#Escape_time_algorithm
        for row in 0 ..< height {
            for col in 0 ..< width {
                let x0: Double = (3.5 / Double(width)) * Double(col) - 2.5
                let y0: Double = (3.0 / Double(height)) * Double(row) - 1.5
                var x: Double  = 0.0
                var y: Double  = 0.0
                var iteration: Int = 0
                
                while(x*x+y*y <= 2*2 && iteration <= maxIteration) {
                    let xTemp: Double = x*x - y*y + x0
                    y = 2*x*y + y0
                    x = xTemp
                    iteration += 1
                }
                
                var color: CGColor
                
                if(iteration < maxIteration) {
                    color = palette[iteration]
                } else {
                    color = UIColor.black.cgColor
                }
                
                plot(context: context, x: CGFloat(col), y: CGFloat(row), color: color)
            }
        }
        
        let cgimage = context.makeImage()
        let uiimage = UIImage(cgImage: cgimage!)
        
        UIGraphicsEndImageContext()
        
        image.setImage(uiimage)
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func plot(context: CGContext, x: CGFloat, y: CGFloat, color: CGColor) {
        context.setStrokeColor(color)
        context.stroke(CGRect(x: x, y: y, width: 0, height: 0), width: 1.0)
    }
}
