//
//  NavigationBar.swift
//  Example
//
//  Created by dmql on 2019/3/19.
//  Copyright © 2019 aFrogleap. All rights reserved.
//

import UIKit

class NavigationBar: UIView {
    fileprivate var navigationBar: UINavigationBar?
    fileprivate weak var superView: UIView?
    
    fileprivate var configuration: ImageViewerConfiguration?
    
    var closeItemAction: (() -> Void)?
    
    init(configuration: ImageViewerConfiguration?) {
        self.configuration = configuration
        super.init(frame: UIApplication.shared.keyWindow?.rootViewController?.view.frame ?? CGRect.zero)
        setup()
        setupItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        
        navigationBar = { () -> UINavigationBar in
            let navigationBar = UINavigationBar()
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.translatesAutoresizingMaskIntoConstraints = false
            addSubview(navigationBar)
            if #available(iOS 11.0, *) {
                addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .top, multiplier: 1.0, constant: 0.0))
            }
            else {
                addConstraint(NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: topAnchor, attribute: .top, multiplier: 1.0, constant: 0.0))
            }
            let left = NSLayoutConstraint(item: navigationBar, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: navigationBar, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
            let bottom = NSLayoutConstraint(item: navigationBar, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            addConstraints([left, right, bottom])
            return navigationBar
        }()
    }
    
    private func setupItems() {
        let navItem = UINavigationItem()
        let backItem = { () -> UIBarButtonItem in
            let item = UIBarButtonItem(image: UIImage(named: "back", in: Bundle(for: type(of: self)), compatibleWith: nil), style: .plain, target: self, action: #selector(closeButtonPressed))
            item.tintColor = UIColor.white
            return item
        }()
        navItem.leftBarButtonItems = [backItem]
        
        let deleteItem = { () -> UIBarButtonItem in
            let item = UIBarButtonItem(image: UIImage(named: "ic_delete", in: Bundle(for: type(of: self)), compatibleWith: nil), style: .plain, target: self, action: #selector(deleteItem_action(_:)))
            item.tintColor = .white
            return item
        }()
        let actionItem = { () -> UIBarButtonItem in
            let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(actionItem_action(_:)))
            item.tintColor = .white
            return item
        }()
        navItem.rightBarButtonItems = [actionItem, deleteItem]
        
        navigationBar?.items = [navItem]
    }
    
    func switchDisplay() {
        if alpha == 1.0 || alpha == 0.0 {
            UIView.animate(withDuration: 0.2, animations: {
                if self.alpha == 0.0 {
                    self.alpha = 1.0
                }
                else {
                    self.alpha = 0.0
                }
            })
        }
    }
    
    @objc func deleteItem_action(_ sender: UIBarButtonItem) {
        configuration?.deleteItem_action?(sender)
    }
    
    @objc func actionItem_action(_ sender: UIBarButtonItem) {
        configuration?.actionItem_action?(sender)
    }
    
    @objc func closeButtonPressed() {
        closeItemAction?()
    }
}
