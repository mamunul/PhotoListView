
import Foundation
import UIKit

class ImageLoader {
    private var cache = LRUCache<String, UIImage>()
    func loadImage(from url: URL, at pixelSize: Int) -> UIImage {
        if let image = cache.get(key: url.path) {
            return image
        }
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: pixelSize] as CFDictionary
        let imageReference = CGImageSourceCreateWithURL(url as CFURL, options)
        let cgImage = CGImageSourceCreateThumbnailAtIndex(imageReference!, 0, options)
        let image = UIImage(cgImage: cgImage!)

        cache.put(key: url.path, value: image)

        return image
    }
}
