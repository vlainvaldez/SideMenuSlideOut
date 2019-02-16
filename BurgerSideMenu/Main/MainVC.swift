//
//  ViewController.swift
//  BurgerSideMenu
//
//  Created by alvin joseph valdez on 15/02/2019.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public final class MainVC: UIViewController {
    
    
    // MARK: Initializers
    
    
    // MARK: LifeCycle Methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.configureHomeController()
      
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Stored Properties
    private var menuVC: SideMenuVC!
    private var mainVC: UIViewController!
    private var isExpanded: Bool = false
    private var origCenter: CGPoint = CGPoint(x: 0.0, y: 0.0)
    private var panGesture: UIPanGestureRecognizer!
    private var mainVCCenterX: CGFloat!
    private var reachedFar: Bool = false
    private lazy var offSet: CGFloat = self.mainVC.view.frame.width - 80
    // MARK: Computed Properties
}


// MARK: Controllers Configuration
extension MainVC {
    
    private func configureHomeController() {
        let homeController: HomeVC = HomeVC()
         self.mainVC = UINavigationController(
            rootViewController: homeController
        )
        homeController.delegate = self
        
        self.view.addSubview(self.mainVC.view)
        self.addChild(self.mainVC)
        self.mainVC.didMove(toParent: self)
        
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainVC.panAction))
        edgePanGesture.edges = .left
        self.mainVC.view.addGestureRecognizer(edgePanGesture)
        
    }
    
    private func configureSideMenuController() {
        if self.menuVC == nil {
            self.menuVC = SideMenuVC()
            
            self.view.insertSubview(self.menuVC.view, at: 0)
            self.addChild(self.menuVC)
            self.menuVC.didMove(toParent: self)
        }
    }
}

// MARK: - Target Action Methods
extension MainVC {
    @objc func panAction(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!)
        
        self.mainVC.view.frame.origin.x = translation.x
        
        switch sender.state {
            case .changed:
                
                if let mainview = sender.view {
                    
                    let hasMovedGreaterThanHalfway = mainview.center.x >= view.bounds.size.width
                    
                    if hasMovedGreaterThanHalfway {
                        self.reachedFar = true
                    }
                    
                    // check if from right is going to left
                    if self.reachedFar && translation.x <= 50.0 {
                        self.resetGestures()
                        self.isExpanded = false
                        self.showSideMenu(false)
                        self.reachedFar = false
                    }

                }
            case .began:
                if self.menuVC == nil {
                    self.configureSideMenuController()
                }
            case .ended:
                if let mainVCView = sender.view {
                    let hasMovedGreaterThanHalfway = mainVCView.center.x > view.bounds.size.width
                    self.isExpanded = hasMovedGreaterThanHalfway
                    self.showSideMenu(hasMovedGreaterThanHalfway)
                }
            
            default:
                break
        }
    }
    
    @objc func didPan( _ sender: UIPanGestureRecognizer) {
        
        switch sender.state {
            case .changed:

                if let mainview = sender.view {
                    mainview.center.x =  mainview.center.x + sender.translation(in: view).x
                    sender.setTranslation(CGPoint.zero, in: view)
                    
                    let hasMovedGreaterThanHalfway = mainview.center.x <= self.mainVCCenterX + 30.0

                    if hasMovedGreaterThanHalfway {
                        self.isExpanded = false
                        self.showSideMenu(false)
                    }
                }
            
            case .ended:
                if let mainview = sender.view {
                    let hasMovedGreaterThanHalfway = mainview.center.x > view.bounds.size.width
                    self.isExpanded = hasMovedGreaterThanHalfway
                    self.showSideMenu(hasMovedGreaterThanHalfway)
                }
            
            default:
                break
        }
    }
}

// MARK: - Helper Methods
extension MainVC {
    
    private func showSideMenu( _ willShow: Bool) {
        
        switch willShow {
        case true:
            self.animateView(with: self.offSet) {
                self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(MainVC.didPan))
                self.mainVC.view.addGestureRecognizer(self.panGesture)
            }
            
        case false:
            self.animateView(with: 0) {
                self.resetGestures()
            }
        }
    }
    
    private func animateView(with offSet: CGFloat , completion: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: UIView.AnimationOptions.curveLinear,
            animations: {
                self.mainVC.view.frame.origin.x = offSet
            },
            completion: { (isCompleted: Bool) in
                if isCompleted {
                    completion()
                }
            }
        )
    }
    
    private func resetGestures() {
        // remove all gesture from the container or mainVC
        self.mainVC.view.gestureRecognizers!.forEach({ (gesture: UIGestureRecognizer) in
            self.mainVC.view.removeGestureRecognizer(gesture)
        })
        
        // add the edge gesture again because it was remove from the top ^
        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainVC.panAction))
        edgePanGesture.edges = .left
        self.mainVC.view.addGestureRecognizer(edgePanGesture)
        
        // NOTE: for some reason the pan gesture is not removed by
        // doing it specifically using:
        // self.mainVC.view.removeGestureRecognizer(self.panGesture)
        // self.panGesture = nil
        // thats why I have to removed all the gesture then
        // readd the edge gesture again
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // save the origin X of mainVCView
        self.mainVCCenterX = self.mainVC.view.center.x
    }
}


// MARK: - HomeVCDelegate Methods
extension MainVC: HomeVCDelegate {
    public func menuToggle() {
        
        if !isExpanded {
            if self.menuVC == nil {
                self.configureSideMenuController()
            }
        }
        
        isExpanded = !isExpanded
        self.showSideMenu(self.isExpanded)
    }
}
