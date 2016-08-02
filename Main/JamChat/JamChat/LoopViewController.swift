//
//  LoopViewController.swift
//  JamChat
//
//  Created by Alexina Boudreaux-Allen on 7/27/16.
//  Copyright © 2016 Jammers. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import RandomColorSwift

class LoopViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, IndicatorInfoProvider {
    
    var jam: Jam!
    var array: [Loop] = []
    var panGesture: UIPanGestureRecognizer?
    var currentDragAndDropIndexPath: NSIndexPath?
    var currentDragAndDropSnapshot: UIView?
    var dragLoopHandler: ((UIView, UIPanGestureRecognizer) -> ())?
    var highlightView: UIView?
    var waveformY: CGFloat!
    var waveformHeight: CGFloat!
    
    @IBOutlet weak var loopCollection: UICollectionView!
    
    override func viewDidLoad() {
        
        loopCollection.delegate = self
        loopCollection.dataSource = self
                
        if(jam.tempo == 80){
            array = Loop.Loops80
        }
        else if(jam.tempo == 110){
            array = Loop.Loops110
        }
        else{
            array = Loop.Loops140
        }
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(LoopViewController.dragLoop(_:)))
        self.loopCollection.addGestureRecognizer(self.panGesture!)
        
        super.viewDidLoad()
    }
    
    var selectedLoopView: UIView?
    func dragLoop(sender: UIPanGestureRecognizer){
    
        switch sender.state{
        case .Began:
            if let indexPathForLocation = self.loopCollection.indexPathForItemAtPoint(sender.locationInView(loopCollection)) {
                let selectedCell: LoopCell? = self.loopCollection.cellForItemAtIndexPath(indexPathForLocation) as? LoopCell
                selectedLoopView = selectedCell!.snapshot
                selectedLoopView?.center = selectedCell!.center
                self.view.superview!.superview!.addSubview(selectedLoopView!)
                highlightView = UIView(frame: CGRectMake(0, 13-waveformY, self.view.frame.width/CGFloat(self.jam.numMeasures!), waveformHeight))
                highlightView!.layer.cornerRadius = 25
                highlightView!.alpha = 0.3
                self.view.superview!.superview!.addSubview(highlightView!)
            }
        case .Changed:
            UIView.animateWithDuration(0.25, animations: {() -> Void in
                let point = sender.locationInView(self.view)
                    self.selectedLoopView!.center.x = point.x
                    self.selectedLoopView!.center.y = point.y
                if (self.selectedLoopView!.frame.origin.y > (13-self.waveformY) && self.selectedLoopView!.frame.origin.y < ((13-self.waveformY)+self.selectedLoopView!.frame.height)){
                    let highlightedX = floor(self.selectedLoopView!.center.x/(self.highlightView!.frame.width))
                    self.highlightView!.frame = CGRect(x: highlightedX*self.highlightView!.frame.width, y: self.highlightView!.frame.origin.y, width: self.highlightView!.frame.width, height: self.highlightView!.frame.height)
                    self.highlightView?.backgroundColor = UIColor.orangeColor()
                }
            })
        default:
            selectedLoopView?.removeFromSuperview()
            highlightView?.backgroundColor = UIColor.clearColor()
        }
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = loopCollection.dequeueReusableCellWithReuseIdentifier("LoopCell", forIndexPath: indexPath) as! LoopCell

        cell.loop = array[indexPath.row]

        return cell
    }
    
    func indicatorInfoForPagerTabStrip(pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "Drum Loops")
    }
    
 }
