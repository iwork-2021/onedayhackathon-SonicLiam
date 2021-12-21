//
//  MyTableViewController.swift
//  MyAlbum
//
//  Created by SonicLiam on 2021/12/21.
//

import UIKit
import CoreMedia
import CoreML
import Vision

class MyTableViewController: UITableViewController {
    let AllClasses = [
        "apple","banana","cake","candy","carrot",
        "cookie","doughnut","grape","hot dog","ice cream",
        "juice","muffin","orange","pineapple","popcorn",
        "pretzel","salad","strawberry","waffle","watermelon"
        
    ]
    
    var AllPictures = [String:[UIImage]]()
    
    var ImagePicked = UIImage()
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do{
            let classifier = try snacks(configuration: MLModelConfiguration())
            let model = try VNCoreMLModel(for: classifier.model)
            let request = VNCoreMLRequest(model: model, completionHandler: {
                [weak self] request,error in
                self?.processObservations(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed")
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for label in AllClasses{
            AllPictures.updateValue([UIImage](), forKey: label)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AllClasses.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! MyTableViewCell
        let label = AllClasses[indexPath.row]
        cell.label.text! = label
        cell.classLabel = label
        return cell
    }
    
    
    @IBAction func pictureFromCamera(_ sender: Any) {
        presentPhotoPicker(sourceType: .camera)
    }
    
    
    @IBAction func pictureFromPhotos() {
        presentPhotoPicker(sourceType: .photoLibrary)
    }
    func presentPhotoPicker(sourceType: UIImagePickerController.SourceType) {
          let picker = UIImagePickerController()
          picker.delegate = self
          picker.sourceType = sourceType
          present(picker, animated: true)
    }
    
    func classify(image:UIImage){
        DispatchQueue.global(qos: .userInitiated).async {
        //DispatchQueue.main.async {
            let handler = VNImageRequestHandler(cgImage: image.cgImage!)
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification: \(error)")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTableView"{
            let controller = segue.destination as! PicturesTableViewController
            let cell = sender as! MyTableViewCell
            controller.pictures = AllPictures[cell.classLabel]!
            controller.tableView.reloadData()
        }else if segue.identifier == "toCollectionView"{
            let controller = segue.destination as! MyAlbumViewController
            let cell = sender as! MyTableViewCell
            controller.pictures = AllPictures[cell.classLabel]!
            controller.collectionView.reloadData()
        }
    }
    

}

extension MyTableViewController {
    func processObservations(for request: VNRequest, error: Error?) {
        if let results = request.results as? [VNClassificationObservation] {
            if !results.isEmpty {
                let result = results[0].identifier
                let confidence = results[0].confidence
                self.AllPictures[result]?.append(self.ImagePicked)
                print(result + String(format: "  %.1f%%", confidence * 100))
            }
        } else if let error = error {
            print("Error: \(error.localizedDescription)")
        } else {
            print("Unknown ERROR")
        }
    }
}

extension MyTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ imagePicker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
      imagePicker.dismiss(animated: true)

      let image = info[.originalImage] as! UIImage
      self.ImagePicked = image
      classify(image: image)
  }
}
