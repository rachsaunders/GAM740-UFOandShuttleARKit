//
//  ViewController.swift
//  GAM740-UFOandShuttleARKit
//
//  Created by Rachel Saunders on 18/12/2020.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    
    // OUTLETS
    @IBOutlet var sceneView: ARSCNView!
    
    // VARS
    
    var chosenNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        registerGestureRecognizer()
        
        
        
    }
    
    func registerGestureRecognizer() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        
        tap.numberOfTapsRequired = 1
        doubleTap.numberOfTapsRequired = 2
        
        sceneView.addGestureRecognizer(tap)
        sceneView.addGestureRecognizer(doubleTap)
        
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        
        guard let vehicle = chosenNode else {
            return
        }
        
        switch vehicle.name {
        case "ufo"?:
            return ufoAction()
        case "shuttle"?:
            return shuttleAction()
        default: ufoAction()
        }
        
    }
    
    
    @objc func handleDoubleTap(gestureRecognizer: UIGestureRecognizer) {
        guard let name = chosenNode?.name else {
            return
        }
        if name == "ufo" {
            launchUfo()
        } else {
            return
        }
        
        
    }
    
    func addShuttle() {
        
        let scene = SCNScene(named: "art.scnassets/Shuttle/shuttle.dae")!
        guard let fireNode = scene.rootNode.childNode(withName: "fireNode", recursively: true),
              let shuttleNode = scene.rootNode.childNode(withName: "shuttleNode", recursively: true)
              
              else {
            fatalError("Something is missing")
            }
        
        
        let fire = SCNParticleSystem(named: "fire.scnp", inDirectory: nil)
        
        fireNode.addParticleSystem(fire!)
        shuttleNode.addChildNode(fireNode)
        
        shuttleNode.scale = SCNVector3(0.3,0.3,0.3)
        
        // fixes error of position
        shuttleNode.position = SCNVector3(x: 0, y: -0.5, z: -1.5)
        
        sceneView.scene.rootNode.addChildNode(shuttleNode)
        
        shuttleNode.name = "shuttle"
        chosenNode = shuttleNode
        
        
    }
    
    
    func addUfo(){
        let scene = SCNScene(named: "art.scnassets/UFO/Ufo.dae")
        guard let ufoNode = scene?.rootNode.childNode(withName: "ufoNode", recursively: true) else {
            fatalError("Something is missing")
        }
        
        let stars = SCNParticleSystem(named: "stars.scnp", inDirectory: nil)
        
        let starNode = SCNNode()
        starNode.addParticleSystem(stars!)
        
        ufoNode.addChildNode(starNode)
        
        ufoNode.scale = SCNVector3(0.3,0.3,0.3)
        
        // fixes error of position
        ufoNode.position = SCNVector3(x: 0, y: -0.5, z: -0.5)
        
        sceneView.scene.rootNode.addChildNode(ufoNode)
        
        ufoNode.name = "ufo"
        chosenNode = ufoNode
        
    }
    
    func shuttleAction() {
        guard let node = chosenNode else {
            return
        }
        let upAction = SCNAction.move(by: SCNVector3(x: 0, y: 100, z: 0.05), duration: 100)
        node.runAction(SCNAction.repeatForever(upAction))
    }
    
    func ufoAction() {
        guard let node = chosenNode else {
            return
        }
        let leftAction = SCNAction.move(by: SCNVector3(-1,0,0), duration: 1)
        let rightAction = SCNAction.move(by: SCNVector3(1,0,0), duration: 1)
        
        leftAction.timingMode = SCNActionTimingMode.easeInEaseOut
        rightAction.timingMode = SCNActionTimingMode.easeInEaseOut
        
        let rotate = SCNAction.rotateBy(x: 0, y: CGFloat(0.2), z: 0, duration: 0.1)
        
        node.runAction(SCNAction.repeatForever(SCNAction.sequence([leftAction,rightAction])))
        node.runAction(SCNAction.repeatForever(rotate))
    }
    
    func launchUfo() {
        guard let node = chosenNode else {
            return
        }
        let upAction = SCNAction.move(by: SCNVector3(100,100,0), duration: 100)
        node.runAction(SCNAction.repeatForever(upAction))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    
    // IBACTIONS
    
    @IBAction func shuttleButton(_ sender: Any) {
        addShuttle()
    }
    
    
    @IBAction func ufoButton(_ sender: Any) {
        addUfo()
        
    }
    
}
