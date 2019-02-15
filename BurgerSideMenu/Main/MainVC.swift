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
    
    private func showSideMenu( _ willShow: Bool) {
        
        switch willShow {
            case true:
                let offSet: CGFloat = self.mainVC.view.frame.width - 80

                self.animateView(with: offSet) {
                    
                    print(self.panGesture)
                    
                    self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(MainVC.didPan))
                    self.mainVC.view.addGestureRecognizer(self.panGesture)
                }
            
            case false:
                self.animateView(with: 0) {
//                    if let pangesture = self.panGesture {
//                        self.mainVC.view.removeGestureRecognizer(pangesture)
//                        self.panGesture = nil
                    
                        self.mainVC.view.gestureRecognizers!.forEach({ (gesture: UIGestureRecognizer) in
                            self.mainVC.view.removeGestureRecognizer(gesture)
                        })
                        
                        let edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(MainVC.panAction))
                        edgePanGesture.edges = .left
                        self.mainVC.view.addGestureRecognizer(edgePanGesture)
                        
                        print("removed gesture")
//                    }
                }
            
        }
    }
}

// MARK: - Target Action Methods
extension MainVC {
    @objc func panAction(sender: UIScreenEdgePanGestureRecognizer) {
        let translation = sender.translation(in: sender.view!)
        
        if !isExpanded {
            self.configureSideMenuController()
        }
        
        self.mainVC.view.frame.origin.x = translation.x
        
        switch sender.state {
            case .changed:
                print("state changed")
            case .ended:
                if let rview = sender.view {
                    let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
                    print("hasMovedGreaterThanHalfway \(hasMovedGreaterThanHalfway)")
                    
                    self.isExpanded = hasMovedGreaterThanHalfway
                    
                    self.showSideMenu(hasMovedGreaterThanHalfway)
                }
            default:
                break
        }
    }
    
    @objc func didPan( _ sender: UIPanGestureRecognizer) {
        
        print("alive pan \(self.panGesture)")
        
        switch sender.state {
            case .began:
                self.configureSideMenuController()
            case .changed:
                print("translation.x \(sender.translation(in: view).x)")
                
                if let mainview = sender.view {
                    mainview.center.x =  mainview.center.x + sender.translation(in: view).x
                    sender.setTranslation(CGPoint.zero, in: view)
                    
                    let hasMovedGreaterThanHalfway = mainview.center.x <= self.mainVCCenterX
                    
                    print("moving mainview.center.x \(mainview.center.x)")
                    
                    print("equal \(hasMovedGreaterThanHalfway) ")
                    
                    if hasMovedGreaterThanHalfway == true {
                        self.isExpanded = false
                        self.showSideMenu(false)
                    }
                }
            
            case .ended:
                if let mainview = sender.view {
                    let hasMovedGreaterThanHalfway = mainview.center.x > view.bounds.size.width
                    print("hasMovedGreaterThanHalfway \(hasMovedGreaterThanHalfway)")
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
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        print("self.view.center.x \(self.view.center.x)")
        print("view.bounds.size.width \(self.view.bounds.size.width) ")
        
        self.mainVCCenterX = self.mainVC.view.center.x
    }
}


// MARK: - HomeVCDelegate Methods
extension MainVC: HomeVCDelegate {
    public func menuToggle() {
        
        if !isExpanded {
            self.configureSideMenuController()
        }
        
        isExpanded = !isExpanded
        self.showSideMenu(self.isExpanded)
    }
}
