//
//  FNN_TableViewController.swift
//  FNN_Mockup
//
//  Created by Shruthi on 24/06/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

/**
 while using multiple constraints and when there is ambeguity in handling constraints this method will list all constraits ID and constant value
 */
extension NSLayoutConstraint {
    
    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" 
    }
}

//MARK:- Tobleview with video and placeholder immage from view asset
//

class FNN_ViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    private var data            : FNN_Table_DS?
    private var cell_Thumbnail  = [String:UIImage]()
    
     var checkedRows=Set<NSIndexPath>() // for fixing repeating cells
    
    var video_player = Video_Player()
    
    //MARK:- initData with datastructure
    //
    func initData(tableData:FNN_Table_DS) {
        data = tableData
        
    }
    
    //MARK:- View load
    //
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //commented to be used in cell awake from nib

        FNN.showData(api_GetFNN) {
            data in
            self.initData(data)
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    //
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _data = data else {
            return 0
        }
        
        return _data.cell_DS.count
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FNN_Cell", forIndexPath: indexPath) as! FNN_TableViewCell //TODO unwrap
        
        //Get cell data
        guard let
        _data = data,
        cellData = _data.cell_DS[indexPath.row] as? FNN_Cell_DS,
        video_url = NSURL(string: cellData.video_URL)
            else {
                debugPrint("no cell ds to display cell \(data)")
                return cell
        }
        // add Title
        cell.lblTitle.text = cellData.title
       
        // add thumbnail image view
//        cell.viewVideo.image = UIImage(named: "default_cell")// this can be uncommented and replacedd with placeholder image
        
        // If this image is already cached, don't re-download
        if let img = cell_Thumbnail[cellData.video_URL] {
            cell.viewVideo.image = img
            cell.viewVideo.backgroundColor = UIColor.clearColor() // color used as placeholder

        }
        else {
            // cell thumbnail downloading in background TODO: move to data_structure during get data
            let request: NSURLRequest = NSURLRequest(URL: video_url)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                if error == nil {
                    // Convert the downloaded data in to a UIImage object
                    /**
                     generate thumbnail and add to an array to be used for cell design
                     */

                    do {
                        let asset           = AVURLAsset(URL: video_url ),
                        imgGenerator    = AVAssetImageGenerator(asset: asset),
                        cgImage         = try imgGenerator.copyCGImageAtTime(CMTimeMake(0, 1), actualTime: nil),
                        image           = UIImage(CGImage: cgImage)
                        
                        // Store the image in to our cache
                        self.cell_Thumbnail[cellData.video_URL] = image
                        // Update the cell
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? FNN_TableViewCell {
                                cellToUpdate.viewVideo.image = image
                                cellToUpdate.viewVideo.backgroundColor = UIColor.clearColor() // color used as placeholder
                            }
                        })

                        debugPrint("image size is \(image.size)")
                        
                    } catch let error as NSError {
                        debugPrint("Error generating thumbnail: \(error)")
                    }
                }
                else {
                    debugPrint("Error: \(error!.localizedDescription)")// todo unwrap
                }
            })
        }
 
        // add video layer with zero frame
        cell.viewVideo.layer.addSublayer(layerForCell(indexPath, forFrame: cell.viewVideo.bounds, forURL: nil, inView: nil))
        
        return cell
                
    }
    
    
    /**
     Returns a avplayerLayer based on the parameter. Note: either forFrame or inView can be nil based on the player type but not both cannot be nil.
     
     - Parameters: index path to check if player is playing then remove and add new instance
     - Returns: avplayer layer with the type provided
     */
    func layerForCell(indexPath: NSIndexPath, forFrame: CGRect?, forURL:NSURL?, inView:UIView?, ofType:PlayerFit = PlayerFit.Unknown) -> AVPlayerLayer {
        
        
        // if cell selected return player layer
        if self.checkedRows.contains(indexPath) {
            if forURL != nil {
                self.checkedRows.remove(indexPath)
                video_player.removeFromView()
                return video_player.getPlayerLayer(forFrame, type: ofType, forURL: forURL, forView: inView)
            }
            
        }
        // else add empty layer with no frame
        return video_player.getPlayerLayer(forFrame, type: ofType, forURL: forURL, forView: inView)
        
        
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /** get cell and cell data ,
         remove any layers exsisting and
         add player layer */
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) as? FNN_TableViewCell {
            
            guard let
                _data = data,
                cellData = _data.cell_DS[indexPath.row] as? FNN_Cell_DS,
                url = NSURL(string: cellData.video_URL)
                else {
                    debugPrint("no cell video to display  \(data)")
                    return
            }
            
            // for fixing layer repeating in cells on scroll
            if checkedRows.contains(indexPath) {
                self.checkedRows.remove(indexPath)
                video_player.removeFromView()
            } else {
                self.checkedRows.insert(indexPath)
                cell.viewVideo.layer.addSublayer(layerForCell(indexPath, forFrame: nil, forURL: url, inView: cell.viewVideo, ofType: PlayerFit.FitToView))
                
            }
            
        }
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
