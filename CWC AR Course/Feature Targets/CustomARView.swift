// Created by Florian Schweizer on 21.05.22

import ARKit
import Combine
import SwiftUI
import RealityKit
import UIKit

class CustomARView: ARView {
    private weak var resultLabel: UILabel!
    var timer = Timer()
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
    
    dynamic required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This is the init that we will actually use
    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        
        subscribeToActionStream()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private var skateboard: Skateboard.Scene? = nil
    
    func subscribeToActionStream() {
        ARManager.shared
            .actionStream
            .sink { [weak self] action in
                switch action {
                    case .placeBlock(let color):
                        self?.placeBlock(ofColor: color)
                        
                    case .placeSkateboard:
                        do {
                            let skateboard = try Skateboard.loadScene()
                            self?.scene.addAnchor(skateboard)
                            
                            self?.skateboard = skateboard
                        } catch {
                            print(error)
                        }
                        
                    case .playSkateboardAnimation:
                        self?.skateboard?.notifications.mySkateboardTrick.post()
                        
                    case .removeAllAnchors:
                        self?.scene.anchors.removeAll()
                }
            }
            .store(in: &cancellables)
    }
    
    
    func placeBlock(ofColor color: Color) {
        let block = MeshResource.generateBox(size: 0.3)
        let material = SimpleMaterial(color: UIColor(color), isMetallic: false)
        let entity = ModelEntity(mesh: block, materials: [material])
        
//        let dist = MeshResource.generateText(String(resultLabel.text))
//        let entitytwo = ModelEntity(mesh: dist, materials: [material])
        
//        let anchor = AnchorEntity(world: CGPoint)
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(entity)
//        anchor.addChild(entitytwo)
        
//        let camera = cameraTransform
        
        
        scene.addAnchor(anchor)
        
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.distanceBetweenEntities(a: anchor.position(relativeTo: nil),
                                         b: self.cameraTransform.translation)
            })
        
                        
                        // WORKS
//        updateResultLabel(dst)
        
//        let dialog = UIAlertController(title:"My Alert", message:"distance is .", preferredStyle: .alert)
//        let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
//        dialog.addAction(okAction)
//        UIKit.UIAlertAction(
    }
    
//    func updateResultLabel(_ value: Float) {
//        let cm = value * 100.0
//        let inch = cm*0.3937007874
//        resultLabel.text = String(format: "%.2f cm / %.2f\"", cm, inch)
//    }
//
     func distanceBetweenEntities(a: SIMD3<Float>,
                                           b: SIMD3<Float>) {
       
       var distance: SIMD3<Float> = [0, 0, 0]
       distance.x = abs(a.x - b.x)
       distance.y = abs(a.y - b.y)
       distance.z = abs(a.z - b.z)
        let finalDist = sqrt((distance.x * distance.x) + (distance.y * distance.y) + (distance.z * distance.z) )
        let out = "The distance is: \(finalDist)"
         print(out)
         resultLabel.text = out
//        distanceBetweenEntities(a: a,b: cameraTransform.translation)
//        return finalDist
   }
    
//    func getCameraPosition() -> Transform{
//        let camera = cameraTransform
//        return camera.translation
//    }
}
