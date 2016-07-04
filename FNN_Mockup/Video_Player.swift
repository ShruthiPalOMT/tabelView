//
//  Video_Player.swift
//  FNN_Mockup
//
//  Created by Shruthi on 27/06/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation
/**
 enumerated player layer type to handle full screen later
 */
enum PlayerFit {
    case Unknown
    case FitToRect
    case FitToView
    case FullScreen
}
/**
 video player class to create player instance to be reused on load player
 */
class Video_Player {
    
    // Requireed variables to show video player on did select row
    private var player          : AVPlayer      = AVPlayer()
    private var player_layer    : AVPlayerLayer?
    private let layer_PlayPause = CAShapeLayer()
    
    init () {
        player_layer = AVPlayerLayer(player: player)
    }
    //MARK:- load player with item from url
    /**
     loadPlayer
     
     - Parameters: url which should be played in video, view where player layer should be created and index of selction
     - Returns: uiview in add to view function
     */
    
    func getPlayerLayer(withFrame: CGRect?, type:PlayerFit, forURL:NSURL?, forView:UIView?) -> AVPlayerLayer {
        
        switch type {
        case .FitToRect:
            if forURL == nil && withFrame == nil {
                debugPrint("url and frame cannot be nil for player fit to rect")
                return player_layer!
            }
            let _playerItem = AVPlayerItem(URL: forURL!)
            player.replaceCurrentItemWithPlayerItem(_playerItem)
            player_layer?.player = player
            player_layer?.frame = withFrame! // unwrapped in if
            player_layer?.player?.play()
            debugPrint("player layer in fit rect")
            return player_layer!
            
        case .FitToView:
            if forURL == nil && forView == nil {
                debugPrint("url and forView cannot be nil for player fit to rect")
                return player_layer!
            }
            let _playerItem = AVPlayerItem(URL: forURL!)
            player.replaceCurrentItemWithPlayerItem(_playerItem)
            player_layer?.player = player
            player_layer?.frame = (forView?.bounds)! // unwrapped in if
            player_layer?.player?.play()
            debugPrint("player layer in fit view")
            return player_layer!
            
        case .Unknown:
            player_layer!.frame = CGRectZero
            return player_layer!
        default:
            break
            
        }
        player_layer!.frame = CGRectZero
        return player_layer!
    }
    
    // remove player from view
    func removeFromView() {
        debugPrint("player layer removed")
        player_layer?.removeFromSuperlayer()
        
    }
}