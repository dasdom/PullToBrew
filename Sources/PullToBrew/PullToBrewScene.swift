//  Created by dasdom on 12.06.20.
//  
//

import SpriteKit

class PullToBrewScene: SKScene, SKPhysicsContactDelegate {
  
  let cupName = "cup"
  let backgroundLabelName = "backgroundLabel"
  let sourceName = "source"

  var textColor: UIColor = .black
  var cupColor: UIColor = .gray
  private var lastUpdateTime: TimeInterval = 0
  private var drops: [SKSpriteNode] = []
  
  private var contentCreated = false
  
  private var coffeePosition: CGFloat = 0 {
    didSet {
      let source = childNode(withName: sourceName)
      source?.position.x = coffeePosition
    }
  }
  var running = false {
    didSet {
      if running == false {
        coffeePosition = CGFloat.random(in: 20..<frame.size.width-20)
        for drop in drops {
          drop.removeFromParent()
          drop.physicsBody = nil
          drop.removeAllActions()
        }
        drops.removeAll()
      }
    }
  }
  
  override func didMove(to view: SKView) {
    super.didMove(to: view)
    if !contentCreated {
      setupSceneContent()
      contentCreated = true
    }
  }
}

// MARK: - Setup
extension PullToBrewScene {
  
  func setupSceneContent() {
    scaleMode = .aspectFit
    
    backgroundColor = .white
    
    let width: CGFloat = 30

    let cupPath = UIBezierPath()
    cupPath.move(to: CGPoint(x: -width/2, y: 30))
    cupPath.addLine(to: CGPoint(x: -width/2+5, y: -5/2+5))
    cupPath.addLine(to: CGPoint(x: width/2-5, y: -5/2+5))
    cupPath.addLine(to: CGPoint(x: width/2, y: 30))
    
    let cup = SKShapeNode(path: cupPath.cgPath)
    cup.position = CGPoint(x: 0, y: 5)
    cup.name = cupName
    cup.lineWidth = 5
    cup.strokeColor = .gray
    
    cup.physicsBody = SKPhysicsBody(edgeChainFrom: cup.path!)
    cup.physicsBody?.affectedByGravity = false
    
    addChild(cup)
    
    let sourceWidth: CGFloat = 40

    let sourcePath = UIBezierPath()
    sourcePath.move(to: CGPoint(x: -sourceWidth/2, y: frame.size.height+2))
    sourcePath.addLine(to: CGPoint(x: -sourceWidth/2, y: frame.size.height-10.0))
    sourcePath.addLine(to: CGPoint(x: -5, y: frame.size.height-10.0))
    sourcePath.addLine(to: CGPoint(x: -5, y: frame.size.height-20.0))
    sourcePath.addLine(to: CGPoint(x: 5, y: frame.size.height-20.0))
    sourcePath.addLine(to: CGPoint(x: 5, y: frame.size.height-10.0))
    sourcePath.addLine(to: CGPoint(x: sourceWidth/2, y: frame.size.height-10.0))
    sourcePath.addLine(to: CGPoint(x: sourceWidth/2, y: frame.size.height+2))
    sourcePath.addLine(to: CGPoint(x: -sourceWidth/2, y: frame.size.height+2))
    
    let source = SKShapeNode(path: sourcePath.cgPath)
    source.name = sourceName
    source.fillColor = .gray
    
    addChild(source)
    
    physicsWorld.gravity = CGVector(dx: 0.0, dy: -1)
    physicsWorld.contactDelegate = self
    coffeePosition = CGFloat.random(in: 20..<frame.size.width-20)
  }
  
  func setupLoadingLabelNode() {
    let loadingLabelNode = SKLabelNode(text: "Loading...")
    loadingLabelNode.fontColor = textColor
    loadingLabelNode.fontSize = 20
    loadingLabelNode.position = CGPoint(x: frame.midX, y: frame.midY)
    loadingLabelNode.name = backgroundLabelName

    addChild(loadingLabelNode)
  }
}

// MARK: - Update scene content
extension PullToBrewScene {
  func updateLabel(_ text: String) {
    if let label: SKLabelNode = childNode(withName: backgroundLabelName) as? SKLabelNode {
      label.text = text
    }
  }
  
  func moveCup(_ value: CGFloat) {
    let cup = childNode(withName: cupName)
    cup?.position.x = value - frame.size.height*5
  }
  
  override func update(_ currentTime: TimeInterval) {
    
    if running && lastUpdateTime + 0.15 < currentTime {
      lastUpdateTime = currentTime
      addDrop()
    }
  }
  
  func addDrop() {
    let drop = SKSpriteNode(color: UIColor.white, size: CGSize(width: 3, height: 3))
    
    let mid = coffeePosition
    let x = CGFloat.random(in: mid-2...mid+2)
    drop.position = CGPoint(x: x, y: frame.size.height)
    drop.color = .brown
    drop.physicsBody = SKPhysicsBody(circleOfRadius: ceil(drop.size.width/2.0))
    drop.physicsBody?.mass = 0
    
    drops.append(drop)
    insertChild(drop, at: 0)
  }
}
