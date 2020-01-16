//
//  ViewController.swift
//  ARKitImageRecognition
//
//  Created by Marcel Mierzejewski on 07/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit
import ARKit
import MessageUI
import SafariServices
import LocalAuthentication
//import AVFoundation

final class ARCardViewController: UIViewController {

    struct Layout {
        static let cornerRadius: CGFloat = 0.01
    }

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var newCardButton: UIButton!
    @IBOutlet weak var addContactLabel: UILabel!
    @IBOutlet weak var decisionButtonsStack: UIStackView!
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
//
//    private lazy var cameraLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
//    private lazy var captureSession: AVCaptureSession = {
//        let session = AVCaptureSession()
//        session.sessionPreset = AVCaptureSession.Preset.photo
//        guard
//            let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
//            let input = try? AVCaptureDeviceInput(device: backCamera)
//            else { return session }
//        session.addInput(input)
//        return session
//    }()

    var viewModel: ARCardViewModel!
    private let picker = UIImagePickerController()

    let updateQueue = DispatchQueue(label: "\(Bundle.main.bundleIdentifier!).serialSCNQueue")

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = ARCardViewModel()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .camera
        picker.cameraCaptureMode = .photo
        picker.modalPresentationStyle = .popover
        picker.cameraOverlayView = CameraOverlayView(frame: view.frame)

        imagePreview.layer.cornerRadius = 14
        imagePreview.contentMode = .scaleAspectFill
        imagePreview.layer.masksToBounds = true

        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.pointOfView?.camera?.wantsHDR = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true

        addContactLabel.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        addContactLabel.layoutMargins = .init(top: 5, left: 10, bottom: 5, right: 10)
        addContactLabel.isHidden = true
        addContactLabel.layer.cornerRadius = 5
        addContactLabel.clipsToBounds = true

        newCardButton.layer.cornerRadius = 4
        newCardButton.layer.masksToBounds = true
        newCardButton.backgroundColor = UIColor.green.withAlphaComponent(0.7)

        yesButton.backgroundColor = UIColor.green.withAlphaComponent(0.7)
        yesButton.isHidden = true
        yesButton.layer.cornerRadius = yesButton.frame.width/2

        cancelButton.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        cancelButton.isHidden = true
        cancelButton.layer.cornerRadius = cancelButton.frame.width/2

        viewModel.visionManager.finalImage.bindAndFire { (image) in
            guard let imageToTrack = image else { return }
            self.newCardButton.isHidden = true
            self.startARSession(for: imageToTrack)
        }

        viewModel.trackedCard.bindAndFire { (card) in
            if card == nil {
                self.sceneView.session.pause()
//                self.sceneView?.layer.addSublayer(self.cameraLayer)
//                self.captureSession.startRunning()
            } else {
//                self.captureSession.stopRunning()
            }
        }
//
//        let videoOutput = AVCaptureVideoDataOutput()
//        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "MyQueue"))
//        self.captureSession.addOutput(videoOutput)
    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        self.cameraLayer.frame = self.sceneView?.bounds ?? .zero
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let firstTouch = touches.first!
        let location = firstTouch.location(in: sceneView)
        let hits = sceneView.hitTest(location, options: [:])
        guard let firstHit = hits.first else { return }
        handleHitTestResult(result: firstHit)
    }

    private func handleHitTestResult(result: SCNHitTestResult) {
        guard let tappedNodeName = result.node.name else { return }
        switch tappedNodeName {
        case ARButtonType.call.rawValue:
            guard let url = viewModel.phoneUrl else { return }
            self.makeCall(phoneUrl: url)
        case ARButtonType.mail.rawValue:
            sendEmail()
        case ARButtonType.web.rawValue:
            openWebsite()
        case ARButtonType.save.rawValue:
            #warning("TODO: -Add save to contacts")
            checkBiometrics {
                let alert = UIAlertController(title: "Add to contacts?", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break
        }
    }

    private let myContext = LAContext()
    var authError: NSError?

    private func checkBiometrics(handler: @escaping () -> Void) {
        if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Are you sure?") { (success, error) in
                DispatchQueue.main.async {
                    if success {
                        print("Successfully authenticated user")
                        handler()
                    } else {
                        print("Not successfully authenticated user")
                    }
                }
            }
        } else {
            print("user is not capable of touch id")
        }
    }

    private func makeCall(phoneUrl: URL) {
        if (UIApplication.shared.canOpenURL(phoneUrl)) {
            UIApplication.shared.open(phoneUrl, options: [:], completionHandler: nil)
        }
    }

    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([viewModel.trackedCard.value?.email ?? ""])
            present(mail, animated: true)
        }
    }

    private func openWebsite() {
        guard var url = viewModel.trackedCard.value?.webpage else { return }
        if !url.absoluteString.starts(with: "http://") {
            url = URL(string: "http://\(url.absoluteString)")!
        }
        let svc = SFSafariViewController(url: url)
        present(svc, animated: true, completion: nil)
    }

    @IBAction func newCardAction(_ sender: Any) {
        present(picker, animated: true, completion: nil)
    }

    private func startARSession(for image: UIImage) {
        guard let cgImage = image.cgImage
            else {
                print("Can't load image for new AR session. CGImage: \(String(describing: image.cgImage))")
                return
        }
        let refImage = ARReferenceImage(cgImage, orientation: .up, physicalWidth: 0.09)

        let configuration = ARImageTrackingConfiguration()
        configuration.maximumNumberOfTrackedImages = 1

        viewModel.ocrManager.runOCR(forImage: image) { (visionText) in
            self.viewModel.createCard(fromText: visionText)
            configuration.trackingImages = [refImage]
            self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

            self.addContactLabel.isHidden = false
            self.yesButton.isHidden = false
            self.cancelButton.isHidden = false
        }
    }

    @IBAction func addContanct(_ sender: Any) {
        hidePrompt()
    }

    @IBAction func removeCard(_ sender: Any) {
        hidePrompt()
        viewModel.trackedCard.value = nil
    }

    func hidePrompt() {
        yesButton.isHidden = true
        cancelButton.isHidden = true
        addContactLabel.isHidden = true
        imagePreview.image = nil
        newCardButton.isHidden = false
    }
}

extension ARCardViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
//
//extension ARCardViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
//    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
//        guard
//            let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
//            else { return }
//
//        try? viewModel.visionManager.recognizeRectangle(in: pixelBuffer)
//    }
//}
