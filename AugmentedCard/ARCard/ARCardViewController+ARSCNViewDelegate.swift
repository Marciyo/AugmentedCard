//
//  ARCardViewController.swift
//  ARKitImageRecognition
//
//  Created by Marcel Mierzejewski on 07/01/2019.
//  Copyright © 2019 Snow.dog. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

extension ARCardViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }

        updateQueue.async {
            let cardSize = CGSize(width: imageAnchor.referenceImage.physicalSize.width,
                                  height: imageAnchor.referenceImage.physicalSize.height)
            self.viewModel.trackedCardSize = cardSize
            self.displayARLayout(on: node)
        }
    }

    func displayARLayout(on node: SCNNode) {
        let mainNode = self.viewModel.sceneFactory.createPlaneNode(size: viewModel.trackedCardSize)
        node.addChildNode(mainNode)

        displayAvatar(on: mainNode)
        displaySaveButton(on: mainNode)

        guard let trackedCard = viewModel.trackedCard.value else { return }
        if !trackedCard.phoneNumber.isEmpty {
            displayCallButton(on: mainNode)
        }
        if !trackedCard.email.isEmpty {
            displayMailButton(on: mainNode)
        }
        if trackedCard.webpage != nil {
            displayWebButton(on: mainNode)
        }
//        displayWebview(on: mainNode)
    }

    private func displayAvatar(on node: SCNNode) {
        viewModel.googleSearchForImages { (image) in
            let cardSize: CGSize = self.viewModel.trackedCardSize
            let avatarNode = self.viewModel.sceneFactory.createAvatarPlaneNode(cardSize: cardSize,
                                                                               image: image)
            node.addChildNode(avatarNode)
            avatarNode.runAction(self.moveByFromInsideAction(xOffset: 0,
                                                             yOffset: cardSize.height * 1.5))
        }
    }

    private func displayCallButton(on node: SCNNode) {
        let xOffsetMultiplier: CGFloat = 0.7
        let yOffsetMultiplier: CGFloat = 0.3
        displayButton(on: node, type: .call, xOffsetM: xOffsetMultiplier, yOffsetM: yOffsetMultiplier)
    }

    private func displayMailButton(on node: SCNNode) {
        let xOffsetMultiplier: CGFloat = -0.7
        let yOffsetMultiplier: CGFloat = 0.3
        displayButton(on: node, type: .mail, xOffsetM: xOffsetMultiplier, yOffsetM: yOffsetMultiplier)
    }

    private func displayWebButton(on node: SCNNode) {
        let xOffsetMultiplier: CGFloat = -0.7
        let yOffsetMultiplier: CGFloat = -0.3
        displayButton(on: node, type: .web, xOffsetM: xOffsetMultiplier, yOffsetM: yOffsetMultiplier)
    }

    private func displaySaveButton(on node: SCNNode) {
        let xOffsetMultiplier: CGFloat = 0.7
        let yOffsetMultiplier: CGFloat = -0.3
        displayButton(on: node, type: .save, xOffsetM: xOffsetMultiplier, yOffsetM: yOffsetMultiplier)
    }

    private func displayButton(on node: SCNNode, type: ARButtonType, xOffsetM: CGFloat, yOffsetM: CGFloat) {
        let cardSize: CGSize = self.viewModel.trackedCardSize
        let buttonNode = viewModel.sceneFactory.createButtonPlaneNode(cardSize: cardSize, type: type)
        node.addChildNode(buttonNode)
        buttonNode.runAction(moveByFromInsideAction(xOffset: cardSize.width * xOffsetM,
                                                    yOffset: cardSize.height * yOffsetM))
    }

    private func displayWebview(on node: SCNNode) {
        guard let webViewUrl = viewModel.trackedCard.value?.webpage else { return }
        let cardSize: CGSize = self.viewModel.trackedCardSize
        viewModel.sceneFactory.webViewNode.bindAndFire { (webViewNode) in
            guard let webViewNode = webViewNode else { return }
            node.addChildNode(webViewNode)
            webViewNode.runAction(self.moveByFromInsideAction(xOffset: 0,
                                                              yOffset: -cardSize.height * 2))
        }
        viewModel.sceneFactory.createWebViewNode(cardSize: cardSize, url: webViewUrl)
    }

    private func moveByFromInsideAction(xOffset: CGFloat, yOffset: CGFloat) -> SCNAction {
        return SCNAction.group([
            .moveBy(x: xOffset, y: yOffset, z: 0.001, duration: 0.6),
            .fadeOpacity(to: 1.0, duration: 1.5),
            ])
    }
}
