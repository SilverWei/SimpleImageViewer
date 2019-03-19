//
//  NavigationBarView.swift
//  Example
//
//  Created by dmql on 2019/3/19.
//  Copyright © 2019 aFrogleap. All rights reserved.
//

import UIKit

class NavigationBarView: UIView {
    fileprivate var navigationBar: UINavigationBar?
    fileprivate weak var superVC: UIViewController?
    fileprivate var backItem: UIBarButtonItem?
    fileprivate var shareButton: UIButton?
    
    fileprivate var configuration: ImageViewerConfiguration?
    
    init(viewController: UIViewController, configuration: ImageViewerConfiguration?) {
        self.configuration = configuration
        super.init(frame: viewController.view.frame)
        superVC = viewController
        setup()
        setupItems()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        translatesAutoresizingMaskIntoConstraints = false
        superVC?.view.addSubview(self)
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
            addConstraints([left, right])
            return navigationBar
        }()
        if let superView = superVC?.view {
            let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 0.0)
            let left = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: superView, attribute: .left, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 0.0)
            let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: navigationBar, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            superView.addConstraints([top, left, right, bottom])
        }
    }
    
    private func setupItems() {
        let navItem = UINavigationItem()
        backItem = UIBarButtonItem(image: UIImage(named: "back", in: Bundle(for: type(of: self)), compatibleWith: nil), style: .plain, target: self, action: #selector(closeButtonPressed))
        if let backItem = backItem {
            backItem.tintColor = UIColor.white
            navItem.leftBarButtonItems = [backItem]
        }
        
        shareButton = UIButton(type: .custom)
        shareButton?.setImage(UIImage(named: "ic_share_white", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
        shareButton?.addTarget(self, action: #selector(downloadButton_touchUp), for: .touchUpInside)
        if let shareButton = shareButton {
            let shareItem = UIBarButtonItem(customView: shareButton)
            navItem.rightBarButtonItems = [shareItem]
        }
        
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
    
    @objc func downloadButton_touchUp() {
        if let shareButton = shareButton {
            configuration?.downloadButton_action?(shareButton)
        }
    }
    
    @objc func closeButtonPressed() {
        superVC?.dismiss(animated: true)
    }
}
