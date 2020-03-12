
import Foundation

protocol PhotoProviderDelegate: AnyObject {
    func onPhotoReceived(urls: [URL])
}

class PhotoProvider {
    weak var delegate: PhotoProviderDelegate?
    private var fileManager: FileManager
    private var documentsUrl: URL
    init(fileManager: FileManager = FileManager.default) {
        self.fileManager = fileManager
        documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        createSampleFile()
    }

    private func createSampleFile() {
        let filePath = documentsUrl.path + "/test.txt"
        let rawData: Data? = "sample file".data(using: .utf8)
        fileManager.createFile(atPath: filePath, contents: rawData, attributes: nil)
    }

    func getTifImageUrls() {
        do {
            let directoryContents =
                try fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil)
            let tiffURLS =
                directoryContents.filter {
                    $0.pathExtension.lowercased() == "tif" || $0.pathExtension.lowercased() == "tiff"
                }
            delegate?.onPhotoReceived(urls: tiffURLS)
        } catch {
            print(error)
        }
    }
}
