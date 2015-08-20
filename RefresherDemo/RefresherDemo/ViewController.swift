//
//  ViewController.swift
//  RefresherDemo
//
//  Created by 云之彼端 on 15/8/20.
//  Copyright (c) 2015年 cezr. All rights reserved.
//

import UIKit


class AutoView: UIView, AutoToNextViewDelegate {
    
    
    func autoToNextStart(view: AutoToNextView) {
        
    }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView = UITableView(frame: CGRectMake(0, 20, view.bounds.size.width, view.bounds.size.height-20), style: UITableViewStyle.Plain)
        tableView?.backgroundColor = UIColor.whiteColor()
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        let beatAnimator = BeatAnimator(frame: CGRectMake(0, 0, 320, 80))
        tableView?.addPullToRefreshWithAction({
            NSOperationQueue().addOperationWithBlock {
                sleep(2)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.num = 30
                    self.tableView?.reloadData()
                    self.tableView?.stopPullToRefresh()
                })
            }
            }, withAnimator: beatAnimator)
        
        view.addSubview(tableView!)
        
        
        
        
        tableView?.addAotuToNextWithAction({ () -> () in
            println("Loading...")
            
            NSOperationQueue().addOperationWithBlock({ () -> Void in
                sleep(2)
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    var indexPaths = [NSIndexPath]()
                    for var n = self.num; n < self.num+10; n++ {
                        
                        indexPaths.append(NSIndexPath(forRow: n, inSection: 0))
                    }
                    self.num += 10
                    self.tableView?.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
                    
                    
                    self.tableView?.autoToNextView?.endLoading()
                })
            })
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var num = 30

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return num
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "Cell")
        cell.textLabel?.text = "Row " + String(indexPath.row + 1)
        return cell
    }
}

