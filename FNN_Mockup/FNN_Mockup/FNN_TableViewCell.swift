//
//  FNN_TableViewCell.swift
//  FNN_Mockup
//
//  Created by Shruthi on 24/06/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class FNN_TableViewCell: UITableViewCell {

    @IBOutlet weak var viewVideo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    //MARK:- awakeFromNib
    /**
     create layer with playPause button and add it to viewvideo layer
     */
    override func awakeFromNib() {
        // add play layer
        let playPause_Layer = create_pausePlayLayer(self.viewVideo.bounds)
        self.viewVideo.layer.addSublayer(playPause_Layer)
        
    }
    // commented as this did not change playpause x position  it changes in debug but not refected in UI
//    //MARK:- layout paypause layer constraint
//    //
//    //
//    override func layoutSublayersOfLayer(layer: CALayer) {
//            playPause_Layer.frame = viewVideo.bounds
//    }
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state

    }
    //MARK:- create_pausePlayLayer
    //      parameters: frame of view
    //      returns   : layer as CAShapeLayer
    //
    private func create_pausePlayLayer(forViewFrame: CGRect) -> CAShapeLayer{
        // create layer
        let layer_PlayPause = CAShapeLayer()
        layer_PlayPause.frame = forViewFrame
        layer_PlayPause.frame.origin = CGPointZero
        // constants for bezier path
        let origin = CGSizeMake(UIScreen.mainScreen().bounds.width, forViewFrame.size.height) //forViewFrame.size commented as the width is not after applying constraints
        let pathSize = CGSizeMake(50, 50)
        let point_start = CGPointMake((origin.width - pathSize.width)/2, (origin.height - pathSize.height)/2)
        
        // create play icon in bezeir path
        layer_PlayPause.fillColor = UIColor.grayColor().CGColor
        let path = UIBezierPath()
        path.moveToPoint(point_start)
        path.addLineToPoint(CGPointMake(point_start.x, point_start.y + pathSize.height))
        path.addLineToPoint(CGPointMake(pathSize.width + point_start.x, point_start.y + pathSize.height/2))
        path.closePath()
        
        //Positions for debugging
//        path.moveToPoint(CGPointMake(0, forViewFrame.size.height))
//        path.addLineToPoint(CGPointMake(forViewFrame.size.width, forViewFrame.size.height))
//      
//        path.moveToPoint(CGPointMake(forViewFrame.size.width/2, 0))
//        path.addLineToPoint(CGPointMake(forViewFrame.size.width/2, forViewFrame.size.height))
//        
//        
//        layer_PlayPause.strokeColor = UIColor.blueColor().CGColor
//        layer_PlayPause.lineWidth = 3
        
        layer_PlayPause.path = path.CGPath
                
        return layer_PlayPause
    }


}
