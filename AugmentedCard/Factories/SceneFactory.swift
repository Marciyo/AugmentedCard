//
//  SceneFactory.swift
//  AugmentedCard
//
//  Created by Marcel Mierzejewski on 24/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import SceneKit
import UIKit
import ARKit
import Foundation

enum ARButtonType: String {
    case call, save, mail, web
}

final class SceneFactory {
    struct Layout {
        static let cornerRadius: CGFloat = 0.01
    }

    var webViewNode = Dynamic<SCNNode?>(nil)

    func createPlaneNode(size: CGSize) -> SCNNode {
        let plane = SCNPlane(width: size.width, height: size.height)
        plane.firstMaterial?.colorBufferWriteMask = .alpha
        
        let plainNode = SCNNode(geometry: plane)
        plainNode.eulerAngles.x = -.pi / 2
        plainNode.renderingOrder = -1
        plainNode.opacity = 1
        return plainNode
    }

    func createAvatarPlaneNode(cardSize: CGSize, image: UIImage) -> SCNNode {
        let detailPlane = SCNPlane(width: cardSize.width, height: cardSize.width)
        detailPlane.cornerRadius = Layout.cornerRadius

        let detailNode = SCNNode(geometry: detailPlane)
        detailNode.geometry?.firstMaterial?.diffuse.contents = image
        detailNode.opacity = 0

        return detailNode
    }

    func createButtonPlaneNode(cardSize: CGSize, type: ARButtonType) -> SCNNode {
        let cardDiameter = cardSize.height / 2.5
        let detailPlane = SCNPlane(width: cardDiameter, height: cardDiameter)
        let detailNode = SCNNode(geometry: detailPlane)
        detailPlane.cornerRadius = cardDiameter / 2
        var buttonImage: UIImage
        switch type {
        case .call:
            detailNode.name = ARButtonType.call.rawValue
            buttonImage = #imageLiteral(resourceName: "call_icon")
        case .mail:
            detailNode.name = ARButtonType.mail.rawValue
            buttonImage = #imageLiteral(resourceName: "mail_icon")
        case .save:
            detailNode.name = ARButtonType.save.rawValue
            buttonImage = #imageLiteral(resourceName: "download_icon")
        case .web:
            detailNode.name = ARButtonType.web.rawValue
            buttonImage = #imageLiteral(resourceName: "web_icon")
        }
        detailPlane.firstMaterial?.diffuse.contents = buttonImage
        let floatingAction = SCNAction.sequence([
            SCNAction.scale(to: 1.1, duration: 0.6),
            SCNAction.scale(to: 1.0, duration: 1.0)
            ])
        let repeatAction = SCNAction.repeatForever(floatingAction)
        detailNode.runAction(repeatAction)
        return detailNode
    }


    func createWebViewNode(cardSize: CGSize, url: URL) {
        // Xcode yells at us about the deprecation of UIWebView in iOS 12.0, but there is currently
        // a bug that does now allow us to use a WKWebView as a texture for our webViewNode
        // Note that UIWebViews should only be instantiated on the main thread!
        DispatchQueue.main.async {
            let request = URLRequest(url: url)
            print("Displaying \(String(describing: url.absoluteString)) on WebView")
            let webView = UIWebView(frame: CGRect(x: 0, y: 0, width: 400, height: 672))
            webView.loadRequest(request)

            let planeHeight = cardSize.width * 1.5
            let webViewPlane = SCNPlane(width: cardSize.width, height: planeHeight)
            webViewPlane.cornerRadius = Layout.cornerRadius

            let webViewNode = SCNNode(geometry: webViewPlane)
            webViewNode.geometry?.firstMaterial?.diffuse.contents = webView
            webViewNode.opacity = 0

            self.webViewNode.value = webViewNode
        }
    }
}
