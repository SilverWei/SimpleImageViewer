import Foundation
import UIKit
import YYImage

public typealias ImageCompletion = (YYImage?) -> Void
public typealias ImageBlock = (@escaping ImageCompletion) -> Void

public final class ImageViewerConfiguration {
    public var image: YYImage?
    public var imageView: YYAnimatedImageView?
    public var imageBlock: ImageBlock?
    public var actionButton_action: ((UIBarButtonItem) -> Void)?
    
    public typealias ConfigurationClosure = (ImageViewerConfiguration) -> ()
    
    public init(configurationClosure: ConfigurationClosure) {
        configurationClosure(self)
    }
}
