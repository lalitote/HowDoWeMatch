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
    
    var photo: UIImageView!
    
    var iteration: Int = 0
    let numberOfIterations = 6
    
    let imagePickerController = UIImagePickerController()
    
    var resultMessage: String = "You match perfectly! 88%"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.layer.cornerRadius = 3
        photoImageView.clipsToBounds = true
        
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = UIColor.blackColor().CGColor
        
        photoImageView_down.layer.cornerRadius = 3
        photoImageView_down.clipsToBounds = true
        
        photoImageView_down.layer.borderWidth = 1
        photoImageView_down.layer.borderColor = UIColor.blackColor().CGColor
        
        buttonCheck.layer.cornerRadius = 3
        buttonCheck.clipsToBounds = true
        
        buttonCheck.layer.borderWidth = 1
        buttonCheck.layer.borderColor = UIColor.blackColor().CGColor
        
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
            preferredStyle: .Alert)
        let makePhoto = UIAlertAction(
            title: "Camera",
            style: .Default) {(action) -> Void in self.shootPhoto()}
        let addPhotoFromCamera = UIAlertAction(
            title: "Photo Library",
            style: .Default) { (action) -> Void in self.photoFromLibrary()}
        alert.addAction(makePhoto)
        alert.addAction(addPhotoFromCamera)
        presentViewController(alert,
                              animated: true,
                              completion: nil)
    }
    
    func shootPhoto() {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            imagePickerController.allowsEditing = false
            imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
            imagePickerController.cameraCaptureMode = .Photo
            imagePickerController.modalPresentationStyle = .FullScreen
            presentViewController(imagePickerController, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera() {
        let missingCameraAlert = UIAlertController (title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction (title: "OK", style: .Default, handler: nil)
        missingCameraAlert.addAction(okAction)
        presentViewController(missingCameraAlert, animated: true, completion: nil)
    }
    
    func photoFromLibrary() {
        imagePickerController.allowsEditing = false
        imagePickerController.sourceType = .PhotoLibrary
        presentViewController(imagePickerController, animated: true, completion: nil)
    }

    @IBAction func addPhoto(sender: UITapGestureRecognizer) {
        photoAlert()
        photo = photoImageView
    }
    
    @IBAction func addPhoto_down(sender: UITapGestureRecognizer) {
        photoAlert()
        photo = photoImageView_down
    }
    
    // Functions for checking the matching
    
    func randomNumber(range: Range<Int>) -> Int {
        let min = range.startIndex
        let max = range.endIndex
        return Int(arc4random_uniform(UInt32(max - min))) + min
    }
    
    func close() {
        checkingInProgress.hideIndicator()
        //CheckingInProgress.shared.hideIndicator()
        if iteration != 0 {
            checking()
        } else {
            result()
        }
    }
    
    func setCloseTimer() {
        _ = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(ViewController.close), userInfo: nil, repeats: false)
    }
    
    func checking() {
        
        iteration -= 1
        
        var height: Int
        if iteration % 2 == 0 {
            height = randomNumber(40...Int(photoImageView.bounds.height)-40)
        } else {
            height = randomNumber(Int(photoImageView.bounds.height + 48)...Int(photoImageView.bounds.height * 2)-40)
        }
        let width = randomNumber(40...Int(photoImageView.bounds.width))
        
        checkingInProgress.position.x = CGFloat(width)
        checkingInProgress.position.y = CGFloat(height)
        
        checkingInProgress.showIndicator(view)
        setCloseTimer()
        
        //CheckingInProgress.shared.showIndicator(view)
    }

    func twoPhotosMissing() {
        let alert = UIAlertController(
            title: "Oops!",
            message: "You didn't choose the photos",
            preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okButton)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func onePhotosMissing() {
        let alert = UIAlertController(
            title: "Oops!",
            message: "Choose another photo",
            preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okButton)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func result() {
        let alert = UIAlertController(
            title: nil,
            message: resultMessage,
            preferredStyle: .Alert)
        let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(okButton)
        presentViewController(alert, animated: true, completion: nil)
    }

    
    @IBAction func checkIfWeMatch(sender: UIButton) {
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
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        photo.contentMode = .ScaleAspectFill
        photo.image = selectedImage
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}


