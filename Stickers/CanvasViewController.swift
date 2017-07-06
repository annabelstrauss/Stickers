//
//  CanvasViewController.swift
//  Stickers
//
//  Created by Annabel Strauss on 7/6/17.
//  Copyright © 2017 Annabel Strauss. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trayDownOffset = 140
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        //Add code to run when the tray is panned
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed {
            print("Gesture is changing")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended {
            print("Gesture ended")
            var velocity = sender.velocity(in: view)
            if velocity.y > 0  { //moving down
                UIView.animate(withDuration: 0.4, animations: {
                    self.trayView.center = self.trayDown
                })
            }
            else if velocity.y < 0 { //moving up
                UIView.animate(withDuration: 0.4, animations: {
                    self.trayView.center = self.trayUp
                })
            }
        }//close else if
        
    }//close didPanTray
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            var imageView = sender.view as! UIImageView //imageView now refers to the face that you panned on
            //Create a new image view that has the same image as the one you're currently panning.
            newlyCreatedFace = UIImageView(image: imageView.image)

            //add the new face to the main view
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center //initalize position
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
            //makes the image bigger when you're dragging it around
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            
            // set up panGestureRecognizer so you can move faces in the canvas
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPanInCanvas(sender:)))
            
            // Attach panGestureRecognizer to the image view
            newlyCreatedFace.isUserInteractionEnabled = true
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            // set up pinchGestureRecognizer so you can move faces in the canvas
            let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(didPinch(sender:)))
            
            // Attach it to a view of your choice. If it's a UIImageView, remember to enable user interaction
            newlyCreatedFace.addGestureRecognizer(pinchGestureRecognizer)
        }
        else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            
        }
        else if sender.state == .ended {
            //bumps image back to smaller siez so it looks like you're "dropping" it
            newlyCreatedFace.transform = newlyCreatedFace.transform.scaledBy(x: 0.75, y: 0.75)
        }
        
    }//close didPanFace
    
    func didPanInCanvas(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            newlyCreatedFace = sender.view as! UIImageView //gets the face that we panned on
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
        } else if sender.state == .changed {
             newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            
        }
    }//close didPanInCanvas
    
    func didPinch(sender: UIPinchGestureRecognizer) {
        // get the scale value from the pinch gesture recognizer
        let scale = sender.scale
        let imageView = sender.view as! UIImageView
        imageView.transform = imageView.transform.scaledBy(x: scale, y: scale)
        sender.scale = 1
    }//close didPinch

}//close class
