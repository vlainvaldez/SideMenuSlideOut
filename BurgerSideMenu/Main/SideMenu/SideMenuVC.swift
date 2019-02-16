//
//  SideMenuVC.swift
//  BurgerSideMenu
//
//  Created by alvin joseph valdez on 15/02/2019.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public final class SideMenuVC: UIViewController {
    
    // MARK: Initializer
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: LifeCycle Methods
    public override func loadView() {
        super.loadView()
        self.view = SideMenuView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(FirstCell.self, forCellWithReuseIdentifier: FirstCell.identifier)
        self.collectionView.register(SecondCell.self, forCellWithReuseIdentifier: SecondCell.identifier)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    // MARK: Stored Properties
    
    // MARK: Computed Properties
}


// MARK: - Views

extension SideMenuVC {
    unowned var rootView: SideMenuView { return self.view as! SideMenuView } // swiftlint:disable:this force_cast
    unowned var collectionView: UICollectionView { return self.rootView.collectionView }
}

extension SideMenuVC: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
            case 0:
                guard
                    let cell: FirstCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: FirstCell.identifier,
                        for: indexPath) as? FirstCell
                else {
                    return UICollectionViewCell()
                }
            
                return cell
            
            case 1:
                guard
                    let cell: SecondCell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: SecondCell.identifier,
                        for: indexPath) as? SecondCell
                    else {
                        return UICollectionViewCell()
                }
                
                return cell
            default:
                return UICollectionViewCell()
        }
        
        
    }
        
}

extension SideMenuVC: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(
            width: self.rootView.collectionView.frame.width,
            height: self.rootView.collectionView.frame.height - 50
        )
    }

    
}
