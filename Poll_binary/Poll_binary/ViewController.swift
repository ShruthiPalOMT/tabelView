//
//  ViewController.swift
//  Poll_binary
//
//  Created by Shruthi on 1/07/2016.
//  Copyright © 2016 Shruthi. All rights reserved.
//

import UIKit



let selectedColor = UIColor.colorWithHexString("FFCC66")
let unSelectedColor = UIColor.lightGrayColor()

let _DEBUG_ = 0

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var table: UITableView!
    
    var data: [PollData] = []
    
    
    //MARK:- View Controller methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setDummyData()
        
        table.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PollCell") as! PollCell
        
        let cellData = data[indexPath.row]
        
        cell.lblQuestion.text = cellData.title
        setTitle(cellData.btnTitle1, forBtn: cell.btn1)
        setTitle(cellData.btnTitle2, forBtn: cell.btn2)
        
        setHighlighted(cell, btnSelected: cellData.selectedOpt)
        
        cell.callBack = {
            btnNumber in
            
            // setData with selected options
            self.data[indexPath.row].selectedOpt = btnNumber
            
            var theTitle: String = cellData.btnTitle1
            if btnNumber  == 2 {
                theTitle = cellData.btnTitle2
            }
            
            
            switch btnNumber {
            case 1:
                self.btnSelectState(cell.btn1)
                
            case 2:
                self.btnSelectState(cell.btn2)
            default:
                break
                
            }
            
            self.setHighlighted(cell, btnSelected: btnNumber)
            
            debugPrint("pressed button is \(theTitle)")
        }
        return cell
    }
    
    //MARK:- set style for button and toggle selection
    //
    func setTitle(title:String, forBtn:UIButton) {
        forBtn.setTitle(title, forState: .Normal)
    }
    
    func btnSelectState(btnSelected:UIButton) {
        
        btnSelected.setTitleColor(UIColor.yellowColor(), forState: .Normal)
        btnSelected.tintColor = UIColor.yellowColor()
        
    }

    func setHighlighted(cell: PollCell, btnSelected:Int) {
        
        cell.btn1.setTitleColor(unSelectedColor, forState: .Normal)
        cell.btn2.setTitleColor(unSelectedColor, forState: .Normal)
        
        if btnSelected == 1 {
            cell.btn1.setTitleColor(selectedColor, forState: .Normal)
        }
        
        if btnSelected == 2 {
            cell.btn2.setTitleColor(selectedColor, forState: .Normal)
        }
    }
    
    
    func debugPrintQuestions(data:[PollData]) {
        debugPrint(data.map { ($0.title, $0.selectedOpt) })
    }
    
    
    //MARK:-
    @IBAction func nextAction(sender:UIButton)  {
        debugPrintQuestions(data)
        
        getDataFromURL(post_url, data: data, type: RequestType.Post)
    }
    
    //TODO base url
    let api_url =  "http://10.0.0.30:15830/devserver/Quick_Poll_Sample/pollSample.json"
    let post_url = "http://10.0.0.30:15830/devserver/Quick_Poll_Sample/submitResult.json"
    
    //MARK:- get and set table data
    //
    func setDummyData() {
        if _DEBUG_ == 1 {
            
            data.append(PollData(title: "question 1", btnTitle1: "Yes", btnTitle2: "No"))
            data.append(PollData(title: "question second", btnTitle1: "Yes", btnTitle2: "No"))
            data.append(PollData(title: "Is your age above 30", btnTitle1: "Yes", btnTitle2: "No"))
            data.append(PollData(title: "Do you like getting subscription for free", btnTitle1: "Yes", btnTitle2: "No"))
            data.append(PollData(title: "do you like pink color", btnTitle1: "Yes", btnTitle2: "No"))
            data.append(PollData(title: "do you like this app", btnTitle1: "Yes", btnTitle2: "cannot say"))
            data.append(PollData(title: "question to choose ", btnTitle1: "true", btnTitle2: "false"))
            data.append(PollData(title: "some other question", btnTitle1: "Yes", btnTitle2: "No"))
        } else {
            //load from json
            loadFromJSON(api_url)
        }
    }
    
    //MARK:- api integration
    //
    func loadFromJSON(api_url:String) {
        
        getDataFromURL(api_url, data: nil, type: RequestType.Get) {
            json in
            
            if let tableDS = PollTable_DS(withJSON_Data: json) {
                self.data = tableDS.tableData
                self.table.reloadData()
            }
        }
        
        
    }
    
  }

