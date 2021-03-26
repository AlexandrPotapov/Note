import UIKit

class GalleryCollectionViewController: UICollectionViewController {
    
    var imagesArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let cell = sender as? UICollectionViewCell,
        let indexPath = collectionView?.indexPath(for: cell),
        let managePageViewController = segue.destination as? ManagePageViewController {
        managePageViewController.imageArray = imagesArray
        managePageViewController.currentIndex = indexPath.row
      }
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
    
        cell.imageView.image = imagesArray[indexPath.row]

        return cell
    }



}

extension GalleryCollectionViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        @IBAction func addImage(_ sender: UIBarButtonItem) {
    
            let image = UIImagePickerController()
            image.delegate = self
    
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = true
    
            self.present(image, animated: true, completion: nil)
        }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage

        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }

        self.collectionView?.performBatchUpdates({
            let indexPath = IndexPath(row: imagesArray.count, section: 0)
            self.imagesArray.append(newImage)
            self.collectionView?.insertItems(at: [indexPath])
        }, completion: nil)
        self.dismiss(animated: true, completion: nil)

        dismiss(animated: true)
    }
    
}
