//
//  SideMenuView.swift
//  BurgerSideMenu
//
//  Created by alvin joseph valdez on 16/02/2019.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import SnapKit

public final class SideMenuView: UIView {
    
    // MARK: Subviews
    public let tableView: UITableView = {
        let view: UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = UIColor.lightGray
        view.separatorColor = UIColor.clear
        return view
    }()
    
    public let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.minimumLineSpacing = 2.0
        let view: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.lightGray
        view.isPagingEnabled = true
        return view
    }()

    // MARK: Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGray
        
        self.subview(forAutoLayout: self.collectionView)
        
        self.collectionView.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func remakeConstraint() {
        self.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
