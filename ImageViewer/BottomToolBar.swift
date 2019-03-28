//
//  BottomToolBar.swift
//  Example
//
//  Created by dmql on 2019/3/27.
//  Copyright © 2019 aFrogleap. All rights reserved.
//

import UIKit
import PinterestSegment

class BottomToolBar: UIView {
    fileprivate var nameLabel: UILabel?
    fileprivate var dateLabel: UILabel?
    public var urlLabel: UILabel?
    fileprivate var copyUrlButton: UIButton?
    fileprivate var urlStyleControl: PinterestSegment?
    
    fileprivate var configuration: ImageViewerConfiguration?
    
    init(configuration: ImageViewerConfiguration?) {
        self.configuration = configuration
        super.init(frame: UIApplication.shared.keyWindow?.rootViewController?.view.frame ?? CGRect.zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        translatesAutoresizingMaskIntoConstraints = false
        let urlBackgroundView = { () -> UIView in
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
            addSubview(view)
            let left = NSLayoutConstraint(item: view, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 20.0)
            if #available(iOS 11.0, *) {
                addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .bottom, multiplier: 1.0, constant: -20.0))
            }
            else {
                addConstraint(NSLayoutConstraint(item: view, attribute: .bottom, relatedBy: .equal, toItem: bottomAnchor, attribute: .bottom, multiplier: 1.0, constant: -20.0))
            }
            addConstraints([left])
            view.layer.rasterizationScale = UIScreen.main.scale
            view.layer.cornerRadius = 5
            return view
        }()
        urlLabel = { () -> UILabel in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = label.font.withSize(17.0)
            addSubview(label)
            let centerY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: urlBackgroundView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            let centerX = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: urlBackgroundView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: urlBackgroundView, attribute: .left, multiplier: 1.0, constant: 7.5)
            addConstraints([centerY, centerX, left])
            
            label.textColor = .lightGray
            label.text = configuration?.imageUrl ?? ""
            return label
        }()
        copyUrlButton = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "copy", in: Bundle(for: type(of: self)), compatibleWith: nil), for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            addSubview(button)
            let left = NSLayoutConstraint(item: button, attribute: .left, relatedBy: .equal, toItem: urlBackgroundView, attribute: .right, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: button, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
            let ratio = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: button, attribute: .height, multiplier: 1.5, constant: 0.0)
            let height = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 44.0)
            let bottom = NSLayoutConstraint(item: button, attribute: .bottom, relatedBy: .equal, toItem: urlBackgroundView, attribute: .bottom, multiplier: 1.0, constant: 0.0)
            let equalHeight = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: urlBackgroundView, attribute: .height, multiplier: 1.0, constant: 0.0)
            addConstraints([left, right, ratio, height, bottom, equalHeight])
            
            button.addTarget(self, action: #selector(copyUrlButton_action), for: .touchUpInside)
            return button
        }()
        nameLabel = { () -> UILabel in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = label.font.withSize(18.0)
            addSubview(label)
            let top = NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 10)
            let right = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: copyUrlButton, attribute: .right, multiplier: 1.0, constant: -20.0)
            addConstraints([top, right])
            if #available(iOS 11.0, *) {
                addConstraint(NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .left, multiplier: 1.0, constant: 20.0))
            }
            else {
                addConstraint(NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: bottomAnchor, attribute: .left, multiplier: 1.0, constant: 20.0))
            }
            
            label.textColor = .white
            label.text = configuration?.imageName ?? ""
            return label
        }()
        let timeImageView = { () -> UIImageView in
            let imageView = UIImageView(image: UIImage(named: "time", in: Bundle(for: type(of: self)), compatibleWith: nil))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addSubview(imageView)
            let top = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: nameLabel, attribute: .bottom, multiplier: 1.0, constant: 10)
            let left = NSLayoutConstraint(item: imageView, attribute: .left, relatedBy: .equal, toItem: nameLabel, attribute: .left, multiplier: 1.0, constant: 0.0)
            addConstraints([top, left])
            return imageView
        }()
        dateLabel = { () -> UILabel in
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = label.font.withSize(15.0)
            addSubview(label)
            let left = NSLayoutConstraint(item: label, attribute: .left, relatedBy: .equal, toItem: timeImageView, attribute: .right, multiplier: 1.0, constant: 5.0)
            let centerY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: timeImageView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            let right = NSLayoutConstraint(item: label, attribute: .right, relatedBy: .equal, toItem: copyUrlButton, attribute: .right, multiplier: 1.0, constant: -20.0)
            addConstraints([left, centerY, right])
            
            label.textColor = .lightGray
            label.text = configuration?.date ?? "—— ——"
            return label
            }()
        urlStyleControl = { () -> PinterestSegment in
            let control = PinterestSegment()
            control.translatesAutoresizingMaskIntoConstraints = false
            addSubview(control)
            let bottomSpace = NSLayoutConstraint(item: control, attribute: .bottom, relatedBy: .equal, toItem: urlBackgroundView, attribute: .top, multiplier: 1.0, constant: -10)
            let top = NSLayoutConstraint(item: control, attribute: .top, relatedBy: .equal, toItem: timeImageView, attribute: .bottom, multiplier: 1.0, constant: 10)
            let height = NSLayoutConstraint(item: control, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40)
            let right = NSLayoutConstraint(item: control, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0.0)
            addConstraints([bottomSpace, top, height, right])
            if #available(iOS 11.0, *) {
                addConstraint(NSLayoutConstraint(item: control, attribute: .left, relatedBy: .equal, toItem: safeAreaLayoutGuide, attribute: .left, multiplier: 1.0, constant: 0.0))
            }
            else {
                addConstraint(NSLayoutConstraint(item: control, attribute: .left, relatedBy: .equal, toItem: bottomAnchor, attribute: .left, multiplier: 1.0, constant: 0.0))
            }
            
            control.titles = configuration?.styleControlTitles ?? []
            control.style.titleFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(5))
            control.style.indicatorColor = UIColor(white: 1.0, alpha: 0.15)
            control.style.titlePendingHorizontal = 10
            control.style.normalTitleColor = .lightGray
            control.style.selectedTitleColor = .white
            
            control.setSelectIndex(index: 0)
            control.valueChange = { index in
                self.configuration?.urlStyleControl_action?(index)
                self.configuration?.styleControlIndex = index
            }
            
            return control
        }()
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
    
    @objc func copyUrlButton_action() {
        configuration?.copyUrlButton_action?(configuration?.styleControlIndex)
    }
}
