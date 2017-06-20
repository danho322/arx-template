//
//  GameViewController.swift
//  SceneKitDemo
//
//  Created by Daniel Ho on 6/13/17.
//  Copyright © 2017 Daniel Ho. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    var sceneView: SCNView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = DataLoader.sharedInstance.modelScene(sceneData: DataLoader.sharedInstance.defaultModelScene())
        if let animationData = DataLoader.sharedInstance.characterAnimations().first {
            DataLoader.sharedInstance.loadAnimation(scene: scene, animationData: animationData)
        }
        
        // retrieve the SCNView
        if let scnView = self.view as? SCNView {
            // set the scene to the view
            scnView.scene = scene
            
            // allows the user to manipulate the camera
            scnView.allowsCameraControl = true
            
            // show statistics such as fps and timing information
            scnView.showsStatistics = true
            
            // configure the view
            scnView.backgroundColor = UIColor.black
            
            // add a tap gesture recognizer
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            scnView.addGestureRecognizer(tapGesture)
            
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
            scnView.addGestureRecognizer(panGesture)
        }
    }
    
    func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view).x
        print(translation)
        
        let xTranslation = Float(translation / view.frame.width)
        if gesture.state == .began || gesture.state == .changed {
            
        }
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.5
            
            // on completion - unhighlight
            SCNTransaction.completionBlock = {
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.5
                
                material.emission.contents = UIColor.black
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.red
            
            SCNTransaction.commit()
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

}
