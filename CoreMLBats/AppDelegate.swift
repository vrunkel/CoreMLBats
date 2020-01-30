//
//  AppDelegate.swift
//  CoreMLBats
//
//  Created by Volker Runkel on 13.12.19.
//  Copyright © 2019 ecoObs GmbH, Volker Runkel. All rights reserved.
//

import Cocoa
import CoreML
import Vision

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var classificationLabel: NSTextField!
    @IBOutlet weak var inputFile: NSTextField!
    @IBOutlet weak var imagePreview: NSImageView!
    @IBOutlet weak var modelPanel: NSPanel!
    @IBOutlet weak var modelPopup: NSPopUpButton!
    
    // MARK: - Image Classification
    
    /// - Tag: MLModelSetup
    
    var selectedModelIndex: Int = 1
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            var model : VNCoreMLModel
            
            if self.selectedModelIndex == 0 {
                model = try VNCoreMLModel(for: NyctaloidBatCalls().model)
            }
            else {
                model = try VNCoreMLModel(for: NyctaloidBatCallswithoutVmur().model)
            }
            
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .scaleFill
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    /// - Tag: PerformRequests
    func updateClassifications(for image: NSImage) {
        classificationLabel.stringValue = "Classifying..."
        
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
                
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                let myRequest = self.classificationRequest
                _ = try handler.perform([myRequest])
            } catch {
                /*
                 This handler catches general image processing errors. The `classificationRequest`'s
                 completion handler `processClassifications(_:error:)` catches errors specific
                 to processing that request.
                 */
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    /// Updates the UI with the results of the classification.
    /// - Tag: ProcessClassifications
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.stringValue = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            let classifications = results as! [VNClassificationObservation]
        
            if classifications.isEmpty {
                self.classificationLabel.stringValue = "Nothing recognized."
            } else {
                let topClassifications = classifications.prefix(3)
                let descriptions = topClassifications.map { classification in
                   return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                self.classificationLabel.stringValue = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        self.window.beginSheet(self.modelPanel) { response in
            //self.modelPanel.performClose(nil)
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @IBAction func openImage(_ sender: AnyObject?) {
        let openPanel = NSOpenPanel()
        openPanel.allowedFileTypes = NSImage.imageTypes
        let response = openPanel.runModal()
        if response == .OK {
            self.inputFile.stringValue = openPanel.url?.lastPathComponent ?? "---"
            if let image = NSImage(contentsOf: openPanel.url!) {
                self.imagePreview.image = image
                self.updateClassifications(for: image)
            }
        }
    }
    
    @IBAction func openImageFromDrop(_ sender: NSImageView) {
        self.inputFile.stringValue = "dropped"
        if let image = sender.image {
            self.updateClassifications(for: image)
        }
    }

    @IBAction func selectModelIndex(_ sender: AnyObject) {
        self.selectedModelIndex = self.modelPopup.indexOfSelectedItem
    }
    
    @IBAction func endModelPanel(_ sender: AnyObject) {
        self.window.endSheet(self.modelPanel)
    }
}

