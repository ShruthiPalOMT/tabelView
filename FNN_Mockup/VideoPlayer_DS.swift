//
//  VideoPlayer_Model.swift
//  FNN_Mockup
//
//  Created by Shruthi on 23/06/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import Foundation
import UIKit

typealias JSON_DATA = [String: AnyObject]
let api_GetFNN = "http://10.0.0.30:15830/devserver/FNN_Cell_Data_Sample/FNN_CellData_Sample.json"

/** 
 Creating Data MOdeel for FNN cell because, It is needed to accesss video url for perticular cell in tableview
 */

//MARK:- Data Structure for Video Player
//
struct FNN_Cell_DS {
    let ID              : String
    let title           : String
    let video_URL       : String
    var tumbnail_Image  : UIImage? = nil
    
    init(_ID:String, _title:String, _url:String) {
        ID = _ID
        title = _title
        video_URL = _url
    }

}

struct FNN_Table_DS {
    
    var cell_DS:[FNN_Cell_DS] = []
    
    init?(withJSON_Data:JSON_DATA) {
        
        guard let
            _data = withJSON_Data["FNN_Cell_Data"] as? [JSON_DATA]
            else {
                debugPrint("FNN data is empty")
                return nil
        }
        
        for data in _data {
            guard let
                _ID = data["ID"] as? String,
                _title = data["title"] as? String,
                _videoURL = data["video_URL"] as? String,
                cell = FNN_Cell_DS(_ID: _ID, _title: _title, _url: _videoURL) as? FNN_Cell_DS
                else {
                    debugPrint("some fields are empty")
                    return nil
            }
                cell_DS.append(cell)
        }
        
        
    }
    
     mutating func setThumbnail(withImage:UIImage, forId:String) {
        guard let _ID = Int(forId) else { return }
            var cell = cell_DS[_ID]
            cell.tumbnail_Image = withImage
            cell_DS[_ID] = cell
    }
    
}

/**
 Following class formating is covineint for use instead of calling apis in view controller , helpful in blackbox model
 */

class FNN {
    
    private class func getDataFromURL(theURL: String, onSuccess:((JSON_DATA)->())? = nil) {
        let session     = NSURLSession.sharedSession()
        
        guard let _URL = NSURL(string: theURL) else { return }
        
        let task = session.dataTaskWithURL(_URL) {
            data, response, error in
            
            guard let data = data,
                json = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? JSON_DATA
                else {
                    debugPrint ("error in parsing json data")
                    return
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                onSuccess?(json)
            }
        }
        
        task.resume()
    }
    
    class func showData(api_URL: String, onSuccess: ((FNN_Table_DS) -> ())? = nil) {
        getDataFromURL(api_URL) {
            json in
            
            guard let _fnn = FNN_Table_DS(withJSON_Data: json) else {
                debugPrint("\nerr in maping json to structure")
                return
            }
            onSuccess?(_fnn)
  
        }

    }
    
}




