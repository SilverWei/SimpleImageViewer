//
//  BottomToolBar.swift
//  Example
//
//  Created by dmql on 2019/3/27.
//  Copyright © 2019 aFrogleap. All rights reserved.
//

import UIKit
import PinterestSegment
import SnapKit

class BottomToolBar: UIView {
    public var urlLabel: UILabel?
    fileprivate var copyMsgLabel: UILabel?
    fileprivate var urlBackgroundView: UIView?
    
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
        
        urlBackgroundView = { () -> UIView in
            let view = UIView()
            view.backgroundColor = UIColor(white: 1.0, alpha: 0.15)
            addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.left.equalTo(self).offset(20)
                if #available(iOS 11.0, *) {
                    make.bottom.equalTo(safeAreaLayoutGuide).offset(-20.0)
                }
                else {
                    make.bottom.equalTo(self).offset(-20)
                }
            })
            view.layer.rasterizationScale = UIScreen.main.scale
            view.layer.cornerRadius = 5
            if #available(iOS 11.0, *) {
                view.isUserInteractionEnabled = true
                view.addInteraction(UIDragInteraction(delegate: self))
            }
            return view
        }()
        urlLabel = { () -> UILabel in
            let label = UILabel()
            label.font = label.font.withSize(17.0)
            addSubview(label)
            label.snp.makeConstraints({ (make) in
                if let urlBackgroundView = urlBackgroundView {
                    make.center.equalTo(urlBackgroundView)
                    make.left.equalTo(urlBackgroundView).offset(7.5)
                }
            })
            
            label.textColor = .lightGray
            label.text = configuration?.copyUrl ?? ""
            return label
        }()
        copyMsgLabel = { () -> UILabel in
            let label = UILabel()
            label.font = label.font.withSize(17.0)
            addSubview(label)
            label.snp.makeConstraints({ (make) in
                if let urlBackgroundView = urlBackgroundView {
                    make.center.equalTo(urlBackgroundView)
                    make.left.equalTo(urlBackgroundView).offset(7.5)
                }
            })
            
            label.textColor = .lightGray
            label.text = configuration?.copyMsgText ?? ""
            label.textAlignment = .center
            label.alpha = 0.0
            return label
        }()
        let copyUrlButton = { () -> UIButton in
            let button = UIButton(type: .custom)
            button.setImage(UIImage(named: "link", in: Bundle(for: type(of: self)), compatibleWith: nil)?.yy_image(byTintColor: .white), for: .normal)
            addSubview(button)
            button.snp.makeConstraints({ (make) in
                if let urlBackgroundView = urlBackgroundView {
                    make.left.equalTo(urlBackgroundView.snp.right)
                    make.right.equalTo(self)
                    make.width.equalTo(button.snp.height).multipliedBy(1.5)
                    make.height.equalTo(44)
                    make.bottom.equalTo(urlBackgroundView)
                    make.height.equalTo(urlBackgroundView)
                }
            })
            
            button.addTarget(self, action: #selector(copyUrlButton_action), for: .touchUpInside)
            return button
        }()
        let nameLabel = { () -> UILabel in
            let label = UILabel()
            label.font = label.font.withSize(18.0)
            addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.top.equalTo(self).offset(10)
                make.right.equalTo(copyUrlButton).offset(-20)
                if #available(iOS 11.0, *) {
                    make.left.equalTo(safeAreaLayoutGuide).offset(20.0)
                }
                else {
                    make.left.equalTo(self).offset(20)
                }
            })
            
            label.textColor = .white
            label.text = configuration?.imageName ?? ""
            return label
        }()
        let timeImageView = { () -> UIImageView in
            let imageView = UIImageView(image: UIImage(named: "time", in: Bundle(for: type(of: self)), compatibleWith: nil))
            addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.top.equalTo(nameLabel.snp.bottom).offset(10)
                make.left.equalTo(nameLabel)
                make.height.equalTo(imageView.snp.width)
            })
            return imageView
        }()
        _ = { () -> UILabel in
            let label = UILabel()
            label.font = label.font.withSize(15.0)
            addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(timeImageView.snp.right).offset(5)
                make.centerY.equalTo(timeImageView)
                make.right.equalTo(copyUrlButton).offset(-20)
            })
            
            label.textColor = .lightGray
            label.text = configuration?.date ?? "—— ——"
            return label
        }()
        let sizeImageView = { () -> UIImageView in
            let imageView = UIImageView(image: UIImage(named: "size", in: Bundle(for: type(of: self)), compatibleWith: nil))
            addSubview(imageView)
            imageView.snp.makeConstraints({ (make) in
                make.top.equalTo(timeImageView.snp.bottom).offset(10)
                make.left.equalTo(nameLabel)
                make.height.equalTo(imageView.snp.width)
            })
            return imageView
        }()
        _ = { () -> UILabel in
            let label = UILabel()
            label.font = label.font.withSize(15.0)
            addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.left.equalTo(sizeImageView.snp.right).offset(5)
                make.centerY.equalTo(sizeImageView)
                make.right.equalTo(copyUrlButton).offset(-20)
            })
            
            label.textColor = .lightGray
            label.text = configuration?.size ?? "—— ——"
            return label
        }()
        _ = { () -> PinterestSegment in
            let control = PinterestSegment()
            addSubview(control)
            control.snp.makeConstraints({ (make) in
                if let urlBackgroundView = urlBackgroundView {
                    make.bottom.equalTo(urlBackgroundView.snp.top).offset(-10)
                    make.top.equalTo(sizeImageView.snp.bottom).offset(10)
                    make.height.equalTo(40)
                    make.right.equalTo(self)
                    if #available(iOS 11.0, *) {
                        make.left.equalTo(safeAreaLayoutGuide)
                    }
                    else {
                        make.left.equalTo(self)
                    }
                }
            })
            
            control.titles = configuration?.styleControlTitles ?? []
            control.style.titleFont = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight(5))
            control.style.indicatorColor = UIColor(white: 1.0, alpha: 0.15)
            control.style.titlePendingHorizontal = 10
            control.style.normalTitleColor = .lightGray
            control.style.selectedTitleColor = .white
            control.setSelectIndex(index: configuration?.styleControlIndex ?? 0)
            control.valueChange = { [weak self] index in
                self?.configuration?.urlStyleControl_action?(index)
                self?.configuration?.styleControlIndex = index
            }
            return control
        }()
    }
    
    func addIn(vc: UIViewController) {
        vc.view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.equalTo(vc.view)
            make.right.equalTo(vc.view)
            make.bottom.equalTo(vc.view)
        }
        vc.view.bringSubviewToFront(self)
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
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.urlLabel?.alpha = 0
            self.copyMsgLabel?.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.3, delay: 0.75, options: .curveEaseInOut, animations: {
                self.urlLabel?.alpha = 1
                self.copyMsgLabel?.alpha = 0
            }, completion: nil)
        }
        configuration?.copyUrlButton_action?(configuration?.styleControlIndex)
        
    }
}
extension BottomToolBar: UIDragInteractionDelegate{
    @available(iOS 11.0, *)
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let url = urlLabel?.text else { return [] }
        let provider = NSItemProvider(object: url as NSItemProviderWriting)
        let item = UIDragItem(itemProvider: provider)
        item.previewProvider = { [weak self] in
            let view = UIView(frame: self?.urlBackgroundView?.frame ?? CGRect.zero)
            view.backgroundColor = .white
            view.layer.rasterizationScale = UIScreen.main.scale
            view.layer.cornerRadius = 5
            let label = UILabel(frame: self?.urlLabel?.frame ?? CGRect.zero)
            label.textColor = UIColor(red:0.31, green:0.37, blue:0.47, alpha:1.0)
            label.text = url
            label.font = label.font.withSize(17.0)
            view.addSubview(label)
            label.snp.makeConstraints({ (make) in
                make.center.equalTo(view)
                make.left.equalTo(view).offset(7.5)
            })
            return UIDragPreview(view: view)
        }
        return [item]
    }
}
