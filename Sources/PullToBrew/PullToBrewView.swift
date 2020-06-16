
import SpriteKit

public protocol PullToBrewDelegate: AnyObject {
  func refreshViewDidRefresh(_ refreshView: PullToBrewView)
}

public class PullToBrewView: SKView {
  
  private let sceneHeight: CGFloat = 100
  private let brewScene: PullToBrewScene
  private let scrollView: UIScrollView
  public weak var refreshDelegate: PullToBrewDelegate?
  
  public var isRefreshing = false
  private var isDragging = false
  private var isVisible = false
  var scenebackgroundColor: UIColor = .white
  var textColor: UIColor = .black
  
  public init(scrollView: UIScrollView) {
    
    let frame = CGRect(x: 0, y: -sceneHeight-20, width: scrollView.frame.size.width, height: sceneHeight)
    
    brewScene = PullToBrewScene(size: frame.size)
    self.scrollView = scrollView
    
    super.init(frame: frame)
    
    presentScene(brewScene)
    
//    showsFPS = true
//    showsNodeCount = true
//    showsPhysics = true
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  func beginRefreshing() {
    isRefreshing = true
    
//    presentScene(brewScene, transition: .doorsOpenVertical(withDuration: 0.4))
    brewScene.updateLabel("Loading...")
    brewScene.running = true
    
    let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
      self.scrollView.contentInset.top += self.sceneHeight + self.scrollView.safeAreaInsets.top
    })
    
    animator.addCompletion({ position in
      self.isVisible = true
    })
    
    animator.startAnimation()
  }
  
  public func endRefreshing() {
    if !isDragging && isVisible {
      isVisible = false
      
      let animator = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut, animations: {
        self.scrollView.contentInset.top -= self.sceneHeight + self.scrollView.safeAreaInsets.top
        self.frame.origin.y = -self.sceneHeight-20
      })
      
      animator.addCompletion({ position in
        self.isRefreshing = false
//        self.presentScene(self.startScene, transition: .doorsCloseVertical(withDuration: 0.3))
        self.brewScene.running = false
      })
      
      animator.startAnimation()
    } else {
      brewScene.updateLabel("Loading Finished")
      isRefreshing = false
    }
  }
}

extension PullToBrewView: UIScrollViewDelegate {
  
  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    isDragging = true
  }

  public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    isDragging = false

    if !isRefreshing && scrollView.contentOffset.y + scrollView.contentInset.top < -sceneHeight {
      beginRefreshing()
      targetContentOffset.pointee.y = -scrollView.contentInset.top
      refreshDelegate?.refreshViewDidRefresh(self)
    }

    if !isRefreshing {
      endRefreshing()
    }
  }

  public func scrollViewDidScroll(_ scrollView: UIScrollView) {

    if isDragging && !isRefreshing {
      let xPosition = -scrollView.contentOffset.y*5
      brewScene.moveCup(xPosition)
    }
    
    if isRefreshing {
      frame.origin.y = scrollView.contentOffset.y
    } else if isDragging {
      frame.origin.y = min(-sceneHeight, scrollView.contentOffset.y)
    }
  }
}
