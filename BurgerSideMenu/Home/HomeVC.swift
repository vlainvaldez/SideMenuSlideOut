//
//  HomeVC.swift
//  BurgerSideMenu
//
//  Created by alvin joseph valdez on 15/02/2019.
//  Copyright © 2019 alvin joseph valdez. All rights reserved.
//

import UIKit

public final class HomeVC: UIViewController {
    
    public weak var delegate: HomeVCDelegate?

    public override func loadView() {
        super.loadView()
        
        self.view = HomeView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavigationBar()
    }
}

extension HomeVC {
        unowned var rootView: HomeView { return self.view as! HomeView } // swiftlint:disable:this force_cast
//        unowned var tableView: UITableView { return self.rootView.tableView }
}

extension HomeVC {
    @objc func menuTapped() {
        self.delegate?.menuToggle()
    }
}

extension HomeVC {
    public func configureNavigationBar() {
        
        guard let navController = self.navigationController else { return }
        
        navController.navigationBar.barTintColor = UIColor.darkGray
        navController.navigationBar.barStyle = UIBarStyle.black
        
        self.navigationItem.title = "Burger Menu"
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: #imageLiteral(resourceName: "ic_menu_white").withRenderingMode(UIImage.RenderingMode.alwaysOriginal),
            style: UIBarButtonItem.Style.plain,
            target: self,
            action: #selector(HomeVC.menuTapped)
        )
    }
}
