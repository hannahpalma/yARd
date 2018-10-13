import UIKit
import SceneKit
import ARKit

class ARCameraController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
  @IBAction func onSelectPlantsSelected(_ sender: UIBarButtonItem) {
    print("Button pressed")
  }
  override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else {
            print("No images available")
            return
        }

        configuration.trackingImages = trackedImages
        configuration.maximumNumberOfTrackedImages = 2
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor {
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1, alpha: 0)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2 // why?
          
            var assetName = ""
          
            if imageAnchor.referenceImage.name == "code1" {
//              assetName = "art.scnassets/EU-trees/EU55_2.scn"
//              assetName = "art.scnassets/ivy/plants1.scn"
              assetName = "art.scnassets/fluffy-bush/berbersys.scn"
              
            } else if imageAnchor.referenceImage.name == "ship" {
//              assetName = "art.scnassets/EU-trees/EU55_3.scn"
              assetName = "art.scnassets/fir-sapling/fir.scn"
            }
          
            let plantScene = SCNScene(named: assetName)!
            let plantNode = plantScene.rootNode.childNodes.first!
            planeNode.addChildNode(plantNode)
            node.addChildNode(planeNode)
            
        }
        
        return node
        
    }
    
    
}
