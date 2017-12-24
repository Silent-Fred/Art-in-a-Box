//
//  ViewController.swift
//  Art-in-a-Box
//
//  Created by Michael Kühweg on 18.12.17.
//  Copyright © 2017 Michael Kühweg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var mondrianImageView: UIImageView!
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            transitionToNewImage(image: randomImage(), transition: .transitionFlipFromRight)
        }
    }
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            transitionToNewImage(image: randomImage(), transition: .transitionCurlUp)
        }
    }
    
    @IBAction func tapOnImage(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            transitionToNewImage(image: randomImage())
        }
    }
    
    @IBAction func refreshImage(_ sender: UIBarButtonItem) {
        transitionToNewImage(image: randomImage())
    }
    
    private func randomImage() -> UIImage {
        let creativeIdea = Mondrian()
        creativeIdea.randomArtwork()
        // images are supposed to possibly serve as background images
        let canvasSize = max(mondrianImageView.frame.width, mondrianImageView.frame.height)
        let art = MondrianOnCanvas(mondrian: creativeIdea, canvasSize: Int(canvasSize))
        return art.asImage()
    }
    
    private func transitionToNewImage(image: UIImage,
                                      transition: UIViewAnimationOptions = .transitionCrossDissolve) {
        UIView.transition(with: mondrianImageView,
                          duration: 1,
                          options: transition,
                          animations: { self.mondrianImageView.image = image },
                          completion: nil)
    }
    
    @IBAction func shareImage(_ sender: UIBarButtonItem) {
        let imageToShare = [ mondrianImageView.image! ]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        // according to stackoverflow, the following is required so that iPads won't crash
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list
        activityViewController.excludedActivityTypes = [
            UIActivityType.postToFacebook,
            UIActivityType.postToFlickr,
            UIActivityType.openInIBooks,
            UIActivityType.postToTencentWeibo,
            UIActivityType.postToVimeo,
            UIActivityType.postToWeibo
        ]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

