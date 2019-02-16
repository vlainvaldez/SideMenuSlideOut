//
//  SecondCell.swift
//  BurgerSideMenu
//
//  Created by alvin joseph valdez on 16/02/2019.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit
import SnapKit

public final class SecondCell: UICollectionViewCell {
    
    // MARK: Subviews
    public let tableView: UITableView = {
        let view: UITableView = UITableView(frame: CGRect.zero, style: UITableView.Style.plain)
        view.backgroundColor = UIColor.lightGray
        view.separatorColor = UIColor.clear
        return view
    }()
    
    // MARK: Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.lightGray
        
        
        self.subviews(forAutoLayout: [self.tableView] )
        
        self.tableView.snp.remakeConstraints { (make: ConstraintMaker) -> Void in
            make.top.equalToSuperview().offset(20.0)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        self.tableView.register(
            SideMenuCell.self,
            forCellReuseIdentifier: SideMenuCell.identifier
        )
        
        self.tableView.dataSource = self
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SecondCell {
    public static var identifier: String = "SecondCell"
}

extension SecondCell: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let
            cell: SideMenuCell = tableView.dequeueReusableCell(
                withIdentifier: SideMenuCell.identifier,
                for: indexPath
                ) as? SideMenuCell
            else {
                return UITableViewCell()
        }
        
        cell.configure(title: "Another Item \(indexPath.item)")
        
        
        return cell
    }
}

extension SecondCell: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}
