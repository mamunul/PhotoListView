
import UIKit

class PhotoTableViewController: UIViewController {
    @IBOutlet var photoTableView: UITableView!
    private var photoUrls: [URL] = []
    private var photoProvider = PhotoProvider()
    private var imageLoader = ImageLoader()
    let ThumbImagePixelSize = 200
    private var loadingImage = UIImage(named: "loading")
    override func viewDidLoad() {
        super.viewDidLoad()

        photoProvider.delegate = self
        DispatchQueue.global().async { [weak self] in

            guard let self = self else { return }
            self.photoProvider.getTifImageUrls()
        }
    }
}

// MARK: -PhotoProviderDelegate-

extension PhotoTableViewController: PhotoProviderDelegate {
    func onPhotoReceived(urls: [URL]) {
        photoUrls = urls
        DispatchQueue.main.async {
            self.photoTableView.reloadData()
        }
    }
}

// MARK: -UITableViewDataSource-

extension PhotoTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photoUrls.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.CellIdentifier, for: indexPath) as! PhotoCell
        cell.photoImageView.image = loadingImage
        DispatchQueue.global().async {
            let thumbImage = self.imageLoader.loadImage(from: self.photoUrls[indexPath.row], at: self.ThumbImagePixelSize)
            DispatchQueue.main.async {
                cell.photoImageView.image = thumbImage
            }
        }

        return cell
    }
}
