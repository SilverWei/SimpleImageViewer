import UIKit
import SimpleImageViewer

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    fileprivate let contentModes: [UIView.ContentMode] = [.scaleToFill,
                                                         .scaleAspectFit,
                                                         .scaleAspectFill,
                                                         .center,
                                                         .top,
                                                         .bottom,
                                                         .left,
                                                         .right,
                                                         .topLeft,
                                                         .topRight,
                                                         .bottomLeft,
                                                         .bottomRight]
    
    fileprivate let images = [UIImage(named: "1"),
                              UIImage(named: "2"),
                              UIImage(named: "3"),
                              UIImage(named: "4"),
                              UIImage(named: "5"),
                              UIImage(named: "6")]

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return contentModes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.imageView.image = images[indexPath.row]
        cell.imageView.contentMode = contentModes[indexPath.section]
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ImageCell
        
        let configuration = ImageViewerConfiguration { config in
            config.imageView = cell.imageView
            config.imageName = "QQ20190701-140900@2x.jpg"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            config.date = formatter.string(from: Date())
            config.size = "5120 x 2880 (5 MB)"
            config.styleControlIndex = 0
            config.styleControlTitles = ["title0", "title1", "title2"]
            config.copyUrl = "https://i.loli.net/2019/07/08/5d22d5f0ecf2962135.jpg"
            config.copyMsgText = "已复制进剪贴板"
        }
        
        present(ImageViewerController(configuration: configuration), animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderView", for: indexPath) as! HeaderView
        headerView.titleLabel.text = contentModes[indexPath.section].name
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width / 3 - 8
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

private extension UIView.ContentMode {
    var name: String {
        switch self {
        case .scaleToFill:
            return "scaleToFill"
        case .scaleAspectFit:
            return "scaleAspectFit"
        case .scaleAspectFill:
            return "scaleAspectFill"
        case .redraw:
            return "redraw (not animatable)"
        case .center:
            return "center"
        case .top:
            return "top"
        case .bottom:
            return "bottom"
        case .left:
            return "left"
        case .right:
            return "right"
        case .topLeft:
            return "topLeft"
        case .topRight:
            return "topRight"
        case .bottomLeft:
            return "bottomLeft"
        case .bottomRight:
            return "bottomRight"
        }
    }
}
