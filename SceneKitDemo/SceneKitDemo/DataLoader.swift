//
//  DataLoader.swift
//  SceneKitDemo
//
//  Created by Daniel Ho on 6/18/17.
//  Copyright © 2017 Daniel Ho. All rights reserved.
//

import Foundation
import QuartzCore
import SceneKit

struct SceneModelData {
    let fileName: String
    let armatureName: String
}

struct CharacterAnimationData {
    let fileName: String
    let animationName: String
}

struct DataLoader {
    static let sharedInstance = DataLoader()
    
    let armatureName = "Armtr"
    let sceneFile = "art.scnassets/Male.dae"
    let characterAnimationDatas = [CharacterAnimationData(fileName: "art.scnassets/MaleWalking.dae", animationName: "Walk"),
                                   CharacterAnimationData(fileName: "art.scnassets/MaleDribbling.dae", animationName: "Dribble"),
                                   CharacterAnimationData(fileName: "art.scnassets/spidermanAnimation.dae", animationName: "Spiderman"),
                                   CharacterAnimationData(fileName: "art.scnassets/stairsAnimation.dae", animationName: "Stairs")]
    
    func defaultModelScene() -> SceneModelData {
        return SceneModelData(fileName: sceneFile, armatureName: armatureName)
    }
    
    func characterAnimations() -> [CharacterAnimationData] {
        var allAnimations: [CharacterAnimationData] = []
        for data in characterAnimationDatas {
            allAnimations.append(data)
        }
        
        return allAnimations
    }
    
    func modelScene(sceneData: SceneModelData) -> SCNScene {
        // create a new scene
        let scene = SCNScene(named: sceneData.fileName)!
        return scene
    }
    
    func armatureNode(in scene: SCNScene?) -> SCNNode? {
        if let scene = scene {
            return scene.rootNode.childNode(withName: armatureName, recursively: true)
        }
        return nil
    }
    
    func loadAnimation(scene: SCNScene?, animationData: CharacterAnimationData, speedScale: Double? = nil) {
        // animation
        if let scene = scene {
            let armtr = scene.rootNode.childNode(withName: armatureName, recursively: true)
            armtr?.removeAllAnimations()
            if let animation = CAAnimation.animationWithSceneNamed(animationData.fileName) {
                if let speedScale = speedScale,
                    let group = animation as? CAAnimationGroup,
                    let animations = group.animations {
                        for subAnimation in animations {
                            subAnimation.duration = subAnimation.duration / speedScale

                            if let subAnimation = subAnimation as? CAKeyframeAnimation {
                                if subAnimation.keyPath! == "/Hips.transform.translation" {
                                    print("yay")
                                }
                            }
                        }
                    animation.duration = animation.duration / speedScale

                }
                armtr?.addAnimation(animation, forKey: animationData.animationName)
                
            }
        }
    }
}
