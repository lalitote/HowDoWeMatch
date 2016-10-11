//
//  ViewController.swift
//  HowDoWeMatch
//
//  Created by lalitote on 16.08.2016.
//  Copyright © 2016 lalitote. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoImageView_down: UIImageView!
    @IBOutlet weak var buttonCheck: UIButton!
    
    var checkingInProgress = CheckingInProgress()
    
    var imageSize: Int = 0
    var imageSize_up: Int = 0
    var imageSize_down: Int = 0
    
    var photo: UIImageView!
    
    var iteration: Int = 0
    let numberOfIterations = 6
    
    let imagePickerController = UIImagePickerController()
    
    //var resultMessage: String = "Perfect! 100%"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.layer.cornerRadius = 3
        photoImageView.clipsToBounds = true
        
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = UIColor.black.cgColor
        
        photoImageView_down.layer.cornerRadius = 3
        photoImageView_down.clipsToBounds = true
        
        photoImageView_down.layer.borderWidth = 1
        photoImageView_down.layer.borderColor = UIColor.black.cgColor
        
        buttonCheck.layer.cornerRadius = 3
        buttonCheck.clipsToBounds = true
        
        buttonCheck.layer.borderWidth = 1
        buttonCheck.layer.borderColor = UIColor.black.cgColor
        
        imagePickerController.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    func photoAlert(){
        let alert = UIAlertController(
            title: "Adding Photo",
            message: "Make a photo or chose from the Photo Library",
            preferredStyle: .alert)
        let makePhoto = UIAlertAction(
            title: "Camera",
            style: .default) {(action) -> Void in self.shootPhoto()}
        let addPhotoFromCamera = UIAlertAction(
            title: "Photo Library",
            style: .default) { (action) -> Void in self.photoFromLibrary()}
        alert.addAction(makePhoto)
        alert.addAction(addPhotoFromCamera)
        present(alert,
                              animated: true,
                              completion: nil)
    }
    
    func shootPhoto() {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.modalPresentationStyle = .fullScreen
            present(imagePickerController, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera() {
        let missingCameraAlert = UIAlertController (title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .alert)
        let okAction = UIAlertAction (title: "OK", style: .default, handler: nil)
        missingCameraAlert.addAction(okAction)
        present(missingCameraAlert, animated: true, completion: nil)
    }
    
    func photoFromLibrary() {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func addPhoto(_ sender: UITapGestureRecognizer) {
        photoAlert()
        photo = photoImageView
    }
    
    @IBAction func addPhoto_down(_ sender: UITapGestureRecognizer) {
        photoAlert()
        photo = photoImageView_down
    }
    
    // Functions for checking the matching
    
    func randomNumber(_ range: Range<Int>) -> Int {
        let min = range.lowerBound
        let max = range.upperBound
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    func close() {
        checkingInProgress.hideIndicator()

        if iteration != 0 {
            checking()
        } else {
            result()
        }
    }
    
    func setCloseTimer() {
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.close), userInfo: nil, repeats: false)
    }
    
    func checking() {
        
        iteration -= 1
        
        var height: Int
        if iteration % 2 == 0 {
            height = randomNumber(40..<Int(photoImageView.bounds.height)-40)
        } else {
            height = randomNumber(Int(photoImageView.bounds.height + 48)..<Int(photoImageView.bounds.height * 2)-40)
        }
        let width = randomNumber(40..<Int(photoImageView.bounds.width))
        
        checkingInProgress.position.x = CGFloat(width)
        checkingInProgress.position.y = CGFloat(height)
        
        checkingInProgress.showIndicator(view)
        setCloseTimer()
    }

    func twoPhotosMissing() {
        let alert = UIAlertController(
            title: "Oops!",
            message: "You didn't choose the photos",
            preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func onePhotosMissing() {
        let alert = UIAlertController(
            title: "Oops!",
            message: "Choose another photo",
            preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
    
    func resultMessage(_ imageSize_up: Int, imageSize_down: Int) -> String {
        var result = (imageSize_up + imageSize_down) % 100
        if imageSize_down == imageSize_up {
            result = 100
        } else if result < 50 {
            result += 50
        }
        
        var message: String
        
        switch result {
        case 100:
            message = "You match perfectly!"
        case 90...100:
            message = "You guys rock!"
        case 80...90:
            message = "Amazing!"
        case 70...80:
            message = "Fabulous!"
        case 60...70:
            message = "Well, well!"
        default:
            message = "Congratulations!"
        }
        return "\(result)% \r\n" + message
    }
    
    func result() {
        let imgData_up: Data = NSData(data: UIImageJPEGRepresentation(photoImageView.image!, 1)!) as Data
        imageSize_up = imgData_up.count
        
        let imgData_down: Data = NSData(data: UIImageJPEGRepresentation(photoImageView_down.image!, 1)!) as Data
        imageSize_down = imgData_down.count
        
        let alert = UIAlertController(
            title: nil,
            message: resultMessage(imageSize_up, imageSize_down: imageSize_down),
            preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }

    
    @IBAction func checkIfWeMatch(_ sender: UIButton) {
        if photoImageView.image == nil && photoImageView_down.image == nil  {
            twoPhotosMissing()
        } else if photoImageView_down.image == nil || photoImageView.image == nil {
            onePhotosMissing()
        } else {
            iteration = numberOfIterations
            checking()
        }
    }
    
    //MARK: Delegates
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photo.contentMode = .scaleAspectFill
        photo.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


