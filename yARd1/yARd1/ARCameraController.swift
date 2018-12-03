import UIKit
import SceneKit
import ARKit

class ARCameraController: UIViewController, ARSCNViewDelegate {

  @IBOutlet var sceneView: ARSCNView!
  @IBAction func onSelectPlantsSelected(_ sender: UIBarButtonItem) {
    print("Button pressed")
  }

  enum Plant {
    case fir
    case package
    case unselected
  }
  
  // Actual model of what's assigned to what
  // Image 0 should pull the model for index, etc
  var selectedPlants: [Plant] = [Plant.unselected, Plant.unselected, Plant.unselected]
  var possiblePlants: [Plant] = [Plant.fir, Plant.package, Plant.unselected]

  static func getPlantDisplayName(plant: Plant) -> String {
    switch plant {
    case Plant.fir:
      return "Fir Tree"
    case Plant.package:
      return "Package"
    default:
      return "Unassigned"
    }
  }
  
  static func getPlantModelPath(plant: Plant) -> String {
    switch plant {
    case Plant.fir:
      return "art.scnassets/fir-sapling/fir.scn"
    case Plant.package:
      return "art.scnassets/20-package/plant_000.scn"
    default:
      return ""
    }
  }
  
  // Map image found to a "stick" and a plant model
  func recognizedImageNameToModelPath(name: String) -> String {
    switch name {
    case "yardCode0":
      return ARCameraController.getPlantModelPath(plant: selectedPlants[0])
    case "yardCode1":
      return ARCameraController.getPlantModelPath(plant: selectedPlants[1])
    case "yardCode2":
      return ARCameraController.getPlantModelPath(plant: selectedPlants[2])
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
  
    guard let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "recognized_codes", bundle: Bundle.main) else {
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
      planeNode.eulerAngles.x = -.pi / 2
      /*
       ^^^ `SCNPlane` is vertically oriented in its local coordinate space, but
       `ARImageAnchor` assumes the image is horizontal in its local space, so
       rotate the plane to match.
     */

      let assetName = recognizedImageNameToModelPath(name: imageAnchor.referenceImage.name!)
      if (assetName.count > 0) {
        let plantScene = SCNScene(named: assetName)!
        let plantNode = plantScene.rootNode.childNodes.first!
        planeNode.addChildNode(plantNode)
        node.addChildNode(planeNode)
      }
    }
  
    return node
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let vc = segue.destination as? AddEditPlantsController {
      vc.plantSelections = selectedPlants
      vc.possiblePlants = possiblePlants
      vc.onPlantsSelected = { (updatedModel: [Plant]) in
        self.selectedPlants = updatedModel
      }
    }
  }

}
