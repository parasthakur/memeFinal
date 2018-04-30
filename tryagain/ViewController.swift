//
//  ViewController.swift
//  tryagain
//
//  Created by Paras Thakur on 16/03/18.
//  Copyright © 2018 Paras Thakur. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    // Trying something different.

    @IBAction func editingDidBegin(_ sender: Any) {
         subscribeToKeyboardNotifications()
    }
    @IBAction func editingDidEnd(_ sender: Any) {
        unsubscribeFromKeyboardNotifications()
    }
    
    
    
    //OUTLETS
    
    @IBOutlet var camButtonUnavail: UIBarButtonItem!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var firstToolbarForHide: UIToolbar!
    @IBOutlet var secondToolbarForHide: UIToolbar!
    
    var activityViewController:UIActivityViewController?
    
    @IBAction func topTextFieldAction(_ sender: Any) {
        topTextField.text = nil
    }
    @IBAction func bottomTextFieldAction(_ sender: Any) {
        bottomTextField.text = nil
    }
    
    
    struct Meme{
        var topText: String
        var bottomText: String
        var originalImage: UIImage
        var memedImage: UIImage
    }
    //Edited image generation
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        
        self.firstToolbarForHide.isHidden = true
        self.secondToolbarForHide.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.firstToolbarForHide.isHidden = false
        self.secondToolbarForHide.isHidden = false
        return memedImage
    }
    
    
    func save(memedImage : UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }
    
    func configure(textField: UITextField, withText text:String){
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(textField: topTextField, withText: "TOP")
        configure(textField: bottomTextField, withText: "BOTTOM")
        shareButton.isEnabled=false
        

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        camButtonUnavail.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black/* TODO: fill in appropriate UIColor */,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white /* TODO: fill in appropriate UIColor */,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5/* TODO: fill in appropriate Float */]
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerControllerSourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func pickButton(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        shareButton.isEnabled=true
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pickCamButton(_ sender: UIButton) {
        presentImagePickerWith(sourceType: .camera)
    }
    func camPickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    func camPickerController(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        viewDidLoad()
        imageView.image = nil
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func shareButtonAction(_ sender: Any) {
        let image = generateMemedImage()
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            (_,successful,_,_) in
            if successful {
                self.save(memedImage: image)
            }
        }
        present(activityViewController, animated: true, completion: nil)
    }
    
    
    
}

