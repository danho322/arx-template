//
//  CharacterAnimationPickerViewController.swift
//  SceneKitDemo
//
//  Created by Daniel Ho on 6/18/17.
//  Copyright © 2017 Daniel Ho. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class CharacterAnimationPickerViewController: UIViewController {

    @IBOutlet weak var sceneView: SCNView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sliderView: UISlider!
    
    var animationDatas: [CharacterAnimationData] = []
    var currentAnimationData: CharacterAnimationData?
    var sliderValue: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let sceneData = DataLoader.sharedInstance.defaultModelScene()
        animationDatas = DataLoader.sharedInstance.characterAnimations()
        
        tableView.dataSource = self
        tableView.delegate = self
        sliderValue = sliderView.value
        
        // retrieve the SCNView
        sceneView.scene = DataLoader.sharedInstance.modelScene(sceneData: sceneData)
        let target = DataLoader.sharedInstance.armatureNode(in: sceneView.scene)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 5, z: 5)
        let constraint = SCNLookAtConstraint(target: target)
        cameraNode.constraints = [constraint]
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        sceneView.scene?.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        sceneView.scene?.rootNode.addChildNode(ambientLightNode)
        
        // Add floore
        let floor = SCNFloor()
        floor.firstMaterial?.diffuse.contents = UIColor.white
        floor.firstMaterial?.specular.contents = UIColor.white
        floor.firstMaterial?.reflective.contents = UIColor.black
        floor.width = 10
        floor.length = 10
        let floorNode = SCNNode(geometry: floor)
        sceneView.scene?.rootNode.addChildNode(floorNode)
        
        // allows the user to manipulate the camera
//        sceneView.allowsCameraControl = true
        sceneView.pointOfView = cameraNode
        
        // show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // configure the view
        sceneView.backgroundColor = UIColor.black
        
//        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
//
//        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
//        sceneView.addGestureRecognizer(panGesture)
    }
    
    func updateCurrentAnimation() {
        if let currentAnimationData = currentAnimationData {
            DataLoader.sharedInstance.loadAnimation(scene: sceneView.scene, animationData: currentAnimationData, speedScale: Double(sliderValue) * 2)
        }
    }

    func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view).x
        print(translation)
        
        let xTranslation = Float(translation / view.frame.width)
        if gesture.state == .began || gesture.state == .changed {
            
        }
    }
    
    @IBAction func onSliderTouchUpOutside(_ sender: Any) {
        // Reset slider
        sliderView.value = sliderValue
    }
    
    @IBAction func onSliderTouchUpInside(_ sender: Any) {
        sliderValue = sliderView.value
        updateCurrentAnimation()
    }
    
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let target = DataLoader.sharedInstance.armatureNode(in: sceneView.scene)
        print(target?.position)
    }

}

// MARK: - UITableViewDataSource
extension CharacterAnimationPickerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animationDatas.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnimationCell")
        let data = animationDatas[indexPath.row]
        cell?.textLabel?.text = data.animationName
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableViewDelegate
extension CharacterAnimationPickerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentAnimationData = animationDatas[indexPath.row]
        updateCurrentAnimation()
    }
}
