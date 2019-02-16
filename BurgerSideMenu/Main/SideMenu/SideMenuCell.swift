//
//  SideMenuCell.swift
//  BurgerSideMenu
//
//  Created by alvin joseph valdez on 16/02/2019.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import SnapKit

public final class SideMenuCell: UITableViewCell {
    
    // MARK: Subviews
    private let menuLabel: UILabel = {
        let view: UILabel = UILabel()
        view.text = "Item"
        return view
    }()
    
    
    // MARK: Initializer
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.subviews(forAutoLayout: [self.menuLabel])
        
        self.backgroundColor = UIColor.lightGray
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.menuLabel.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10.0)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SideMenuCell {
    public static var identifier: String = "SideMenuCell"
    
    public func configure(title: String ) {
        self.menuLabel.text = title
    }
}
