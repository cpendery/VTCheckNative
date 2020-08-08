//
//  ScannerViewController.swift
//  BarcodeScanner
//
//  Created by Sameer Dandekar on 2/15/20.
//  Copyright © 2020 Sameer Dandekar. All rights reserved.
//
 
import SwiftUI
import AVFoundation
import UIKit
 
/*
 ----------------------------------------------------------------------------
 SwiftUI framework does not yet directly support barcode scanning. Therefore,
 we do it by using UIKit's UIViewController class, which is wrapped by the
 BarcodeScanner struct in BarcodeScanner.swift to interface with SwiftUI.
 ----------------------------------------------------------------------------
 */
class ScannerViewController: UIViewController {

       @IBOutlet var messageLabel:UILabel!
       @IBOutlet var topbar: UIView!
       
       var captureSession = AVCaptureSession()
       
       var videoPreviewLayer: AVCaptureVideoPreviewLayer?
       var qrCodeFrameView: UIView?

       private let supportedCodeTypes = [AVMetadataObject.ObjectType.upce,
                                         AVMetadataObject.ObjectType.code39,
                                         AVMetadataObject.ObjectType.code39Mod43,
                                         AVMetadataObject.ObjectType.code93,
                                         AVMetadataObject.ObjectType.code128,
                                         AVMetadataObject.ObjectType.ean8,
                                         AVMetadataObject.ObjectType.ean13,
                                         AVMetadataObject.ObjectType.aztec,
                                         AVMetadataObject.ObjectType.pdf417,
                                         AVMetadataObject.ObjectType.itf14,
                                         AVMetadataObject.ObjectType.dataMatrix,
                                         AVMetadataObject.ObjectType.interleaved2of5,
                                         AVMetadataObject.ObjectType.qr]
      
       override func viewDidLoad() {
           super.viewDidLoad()

           // Get the back-facing camera for capturing videos
           guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
               print("Failed to get the camera device")
               return
           }
           
           do {
               // Get an instance of the AVCaptureDeviceInput class using the previous device object.
               let input = try AVCaptureDeviceInput(device: captureDevice)
               
               // Set the input device on the capture session.
               captureSession.addInput(input)
               
               // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
               let captureMetadataOutput = AVCaptureMetadataOutput()
               captureSession.addOutput(captureMetadataOutput)
               
               // Set delegate and use the default dispatch queue to execute the call back
               captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
               captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
   //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
               
           } catch {
               // If any error occurs, simply print it out and don't continue any more.
               print(error)
               return
           }
           
           // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
           videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
           videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
           videoPreviewLayer?.frame = view.layer.bounds
           view.layer.addSublayer(videoPreviewLayer!)
           
           // Start video capture.
           captureSession.startRunning()
           
           // Move the message label and top bar to the front
           view.bringSubviewToFront(messageLabel)
           view.bringSubviewToFront(topbar)
           
           // Initialize QR Code Frame to highlight the QR code
           qrCodeFrameView = UIView()
           
           if let qrCodeFrameView = qrCodeFrameView {
               qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
               qrCodeFrameView.layer.borderWidth = 2
               view.addSubview(qrCodeFrameView)
               view.bringSubviewToFront(qrCodeFrameView)
           }
       }

       override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }
       
       // MARK: - Helper methods

       func launchApp(decodedURL: String) {
           
        var checkedIn = false
           if presentedViewController != nil {
               return
           }
        
        // TO DO: verify roomID
        let components = decodedURL.components(separatedBy: "/")
        let roomID = components.last!
        getOneRoomData(roomID: roomID, action: "get")
        
        let alertPrompt = UIAlertController(title: scannedRoomName, message: "This room is closed due to COVID-19 restrictions.", preferredStyle: .actionSheet)
        let covidAlertPrompt = UIAlertController(title: scannedRoomName, message: "This room is closed due to COVID-19 restrictions.", preferredStyle: .alert)
        
        if scannedRoomInfected {
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
             covidAlertPrompt.addAction(okAction)
            
            present(covidAlertPrompt, animated: true, completion: nil)
        }
        else {

            let titleAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30), NSAttributedString.Key.foregroundColor: UIColor.red]
                let titleString = NSAttributedString(string: "\n\(scannedRoomName)", attributes: titleAttributes)
                alertPrompt.setValue(titleString, forKey: "attributedTitle")
            
            let messageAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30), NSAttributedString.Key.foregroundColor: UIColor.red]
                let messageString = NSAttributedString(string: "\n\nCurrent Occupancy: \(scannedRoomCurrentOccupancy)\n\nLimit: \(scannedRoomLimit)\n\n", attributes: messageAttributes)
                alertPrompt.setValue(messageString, forKey: "attributedMessage")
               
               let checkInAction = UIAlertAction(title: "Check In", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                   
                    getOneRoomData(roomID: roomID, action: "add")
                 let alertPrompt2 = UIAlertController(title: "\(scannedRoomName)", message: "You're checked in!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(action) -> Void in getAllRoomData()})
                 alertPrompt2.addAction(okAction)
                self.present(alertPrompt2, animated: true, completion: nil)
                
               })
            checkInAction.setValue(UIColor.systemGreen, forKey: "titleTextColor")
            
            let checkOutAction = UIAlertAction(title: "Check Out", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                getOneRoomData(roomID: roomID, action: "subtract")
                
                 let alertPrompt2 = UIAlertController(title: "\(scannedRoomName)", message: "You're checked out!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: {(action) -> Void in getAllRoomData()})
                 alertPrompt2.addAction(okAction)
                self.present(alertPrompt2, animated: true, completion: nil)
            })
            checkOutAction.setValue(UIColor.systemRed, forKey: "titleTextColor")
               
               let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
                
                alertPrompt.addAction(checkInAction)
                alertPrompt.addAction(checkOutAction)
                alertPrompt.addAction(cancelAction)
            
            
               present(alertPrompt, animated: true, completion: nil)
        }

       }
     private func updatePreviewLayer(layer: AVCaptureConnection, orientation: AVCaptureVideoOrientation) {
       layer.videoOrientation = orientation
       videoPreviewLayer?.frame = self.view.bounds
     }
     
     override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       
       if let connection =  self.videoPreviewLayer?.connection  {
         let currentDevice: UIDevice = UIDevice.current
         let orientation: UIDeviceOrientation = currentDevice.orientation
         let previewLayerConnection : AVCaptureConnection = connection
         
         if previewLayerConnection.isVideoOrientationSupported {
           switch (orientation) {
           case .portrait:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
             break
           case .landscapeRight:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeLeft)
             break
           case .landscapeLeft:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .landscapeRight)
             break
           case .portraitUpsideDown:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .portraitUpsideDown)
             break
           default:
             updatePreviewLayer(layer: previewLayerConnection, orientation: .portrait)
             break
           }
         }
       }
     }

   }

   extension ScannerViewController: AVCaptureMetadataOutputObjectsDelegate {
       
       func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
           // Check if the metadataObjects array is not nil and it contains at least one object.
           if metadataObjects.count == 0 {
               qrCodeFrameView?.frame = CGRect.zero
               messageLabel.text = "No QR code is detected"
               return
           }
           
           // Get the metadata object.
           let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
           
           if supportedCodeTypes.contains(metadataObj.type) {
               // If the found metadata is equal to the QR code metadata (or barcode) then update the status label's text and set the bounds
               let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
               qrCodeFrameView?.frame = barCodeObject!.bounds
               
               if metadataObj.stringValue != nil {
                   launchApp(decodedURL: metadataObj.stringValue!)
                   messageLabel.text = metadataObj.stringValue
               }
           }
       }
       
}
 
 
 
