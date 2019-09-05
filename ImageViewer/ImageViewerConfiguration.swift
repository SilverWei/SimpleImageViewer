import Foundation
import UIKit
import YYWebImage

public final class ImageViewerConfiguration {
    public var image: YYImage?
    public var imageView: YYAnimatedImageView?
    public var actionItem_action: ((UIBarButtonItem) -> Void)?
    public var deleteItem_action: ((UIBarButtonItem) -> Void)?
    public var styleControlTitles: [String]?
    public var styleControlIndex: Int?
    public var imageName: String?
    public var imageUrl: String?
    public var copyMsgText: String?
    public var date: String?
    public var size: String?
    public var urlStyleControl_action: ((Int?) -> Void)?
    public var copyUrlButton_action: ((Int?) -> Void)?
    public var finish_action: (() -> Void)?
    public var errorMessage: String?
    
    public typealias ConfigurationClosure = (ImageViewerConfiguration) -> ()
    
    public init(configurationClosure: ConfigurationClosure) {
        configurationClosure(self)
    }
}
