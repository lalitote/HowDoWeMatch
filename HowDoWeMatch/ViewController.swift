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
    @IBOutlet weak var spinningCircle: SpinningCircleView!
    
    var photo: UIImageView!
    
    let imagePickerController = UIImagePickerController()
    
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
    
    func createCircles() {
        let circleCenter = CGPoint(x: 100, y: 100)
        let circleRadius = spinningCircle.circleRadius
        let circleView = SpinningCircleView()
        view.addSubview(circleView)
    }
    
    @IBAction func checkIfWeMatch(sender: UIButton) {
        createCircles()
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

