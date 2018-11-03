import UIKit
import SceneKit
import ARKit

class ARCameraController: UIViewController, ARSCNViewDelegate {

  @IBOutlet var sceneView: ARSCNView!
  @IBAction func onSelectPlantsSelected(_ sender: UIBarButtonItem) {
    print("Button pressed")
  }

  struct Plants {
    static var fir = "art.scnassets/fir-sapling/fir.scn"
    static var unselected = ""
  }
  
  // Actual model of what's assigned to what
  // Image 1 should pull the model for stick 1, etc
  struct PlantSelections {
    var stick1 = Plants.unselected
    var stick2 = Plants.unselected
    var stick3 = Plants.unselected
  }
  
  var selectedPlants:PlantSelections = PlantSelections()
  
  static func getPlantDisplayName(plant: String) -> String {
    switch plant {
    case Plants.fir:
      return "Fir Tree"
    default:
      return "Unassigned (Please tap to assign a plant)"
    }
  }
  
  // Map image found to a "stick" and a plant model
  func recognizedImageNameToModelPath(name: String) -> String {
    switch name {
    case "yardCode1":
      return selectedPlants.stick1
    case "yardCode2":
      return selectedPlants.stick2
    case "yardCode3":
      return selectedPlants.stick3
    default:
      return ""
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the view's delegate
    sceneView.delegate = self
    
    // Create a new scene
    let scene = SCNScene(named: "art.scnassets/GameScene.scn")!
    sceneView.scene = scene
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  
    guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "Photos", bundle: Bundle.main) else {
        print("No images available")
        return
    }

    let configuration = ARImageTrackingConfiguration()
    configuration.trackingImages = trackedImages
    configuration.maximumNumberOfTrackedImages = 3
  
    // Run the view's session
    sceneView.session.run(configuration)
  }
    
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
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

      let assetName = recognizedImageNameToModelPath(name: imageAnchor.referenceImage.name!)
      let plantScene = SCNScene(named: assetName)!
      let plantNode = plantScene.rootNode.childNodes.first!
      planeNode.addChildNode(plantNode)
      node.addChildNode(planeNode)
    }
  
    return node
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? AddEditPlantsController {
      vc.plantSelections = selectedPlants
      vc.onPlantsSelected = { (updatedModel: PlantSelections) in
        self.selectedPlants = updatedModel
      }
    }
  }

}
