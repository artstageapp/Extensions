import UIKit

extension UIImage {
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        let scaleFactor = min(widthRatio, heightRatio)
        let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        let renderer = UIGraphicsImageRenderer(size: scaledImageSize)
        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        return scaledImage
    }
    
    func resizeImage(image: UIImage, height: CGFloat, width: CGFloat) -> UIImage {
        let targetSize = CGSize(width: width, height: height)
        let scaledImage = image.scalePreservingAspectRatio(targetSize: targetSize)
        return scaledImage
    }
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImage.Orientation.up {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        if let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return normalizedImage
        } else {
            return self
        }
    }
    
}

extension UIButton {
    func adjustImageAndTitleOffsetsForButton (button: UIButton) {
        let spacing: CGFloat = 6.0
        let titleSize = button.titleLabel!.frame.size
        let imageSize = button.imageView!.frame.size
        button.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageSize.width, bottom: -22, right: 0)
    }
}

extension UIView {
    public func addSubview(_ subview: UIView, constant: CGFloat, stretchToFit: Bool = false) {
        addSubview(subview)
        if stretchToFit {
            subview.translatesAutoresizingMaskIntoConstraints = false
            leftAnchor.constraint(equalTo: subview.leftAnchor, constant: constant).isActive = true
            rightAnchor.constraint(equalTo: subview.rightAnchor, constant: -constant + 0.5).isActive = true
            topAnchor.constraint(equalTo: subview.topAnchor, constant: constant).isActive = true
            bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: -constant + 0.5).isActive = true
        }
    }
    
    func scale(by scale: CGFloat) {
        self.contentScaleFactor = scale
        for subview in self.subviews {
            subview.scale(by: scale)
        }
    }
    
    func getImage(scale: CGFloat? = nil) -> UIImage {
        let newScale = scale ?? UIScreen.main.scale
        self.scale(by: newScale)
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = newScale
        
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)
        
        let image = renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }
        
        return image
    }

}
