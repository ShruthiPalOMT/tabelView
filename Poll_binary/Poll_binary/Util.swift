//
//  Util.swift
//  Poll_binary
//
//  Created by Shruthi on 4/07/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import Foundation

/**
 Returns a
 
 - Parameters: the url as string
                data as poll array of PollData for post and nil otherwise
                type of request
 
 - Returns: on success returns JSON data
 */
func getDataFromURL(theURL: String, data: [PollData]?, type: RequestType, onSuccess:((JSON_DATA)->())? = nil) {
    let session     = NSURLSession.sharedSession()
    
    guard let _URL = NSURL(string: theURL) else { return }
    
    
    switch type {
    case .Get:
        
        let task = session.dataTaskWithURL(_URL) {
            data, response, error in
            
            guard let data = data,
                json = (try? NSJSONSerialization.JSONObjectWithData(data, options: [])) as? JSON_DATA
                else { debugPrint ("error in parsing json data"); return }
            
            
            dispatch_async(dispatch_get_main_queue()) {
                onSuccess?(json)
            }
        }
        
        task.resume()
        
        
        break
        
    case .Post:
        
        if data != nil {
        let stringData      = data!.description,
        request         = NSMutableURLRequest(URL: _URL),
        requestData     = stringData.dataUsingEncoding(NSUTF8StringEncoding)
        
        request.HTTPMethod = type.rawValue
        
        
        let task = NSURLSession.sharedSession().uploadTaskWithRequest(request,fromData: requestData!) { //TODO unwrap but request data cannot be nil
            data, response, error in
            guard let responseData = data,
                responseString = (try? NSJSONSerialization.JSONObjectWithData(responseData, options: []))
                else { debugPrint ("error in parsing json data"); return }
            debugPrint(responseString)
            
        }
        
        task.resume()

}
               
        break
        
        
    }
    
    
}

enum RequestType:String {
    case Get = "get"
    case Post = "POST"
}
