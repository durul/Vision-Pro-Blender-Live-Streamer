//
//  ImmersiveView.swift
//  VisionPro Blender Streamer
//
//  Created by Justin Leger on 6/22/25.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
    @Environment(AppModel.self) private var appModel

    // The main container entity for dynamic content (Blender scene)
    @State private var dynamicContentAnchor = AnchorEntity()

    var body: some View {
        RealityView { content, attachments in
            // Set the initial position of the anchor:
            // 1.0 meter up (positive Y)
            // -2.0 meters forward (negative Z)
            dynamicContentAnchor.transform.translation = SIMD3<Float>(x: 0.0, y: 1.0, z: -2.0)

            // Add the main anchor for dynamic content to the RealityView's scene
            content.add(dynamicContentAnchor)

            // Add placeholder initially
            if let placeholder = attachments.entity(for: "placeholder") {
                dynamicContentAnchor.addChild(placeholder)
            }
        }
        update: { _, _ in
            // Updates handled via task
        }
        attachments: {
            Attachment(id: "placeholder") {
                Text("Awaiting Blender Scene...")
                    .font(.extraLargeTitle)
                    .padding()
                    .glassBackgroundEffect()
            }
        }
        .gesture(SpatialTapGesture().onEnded { _ in
            print("Spatial tap detected in RealityView!")
        })
        .task {
            for await newEntity in appModel.receiver.sceneEntityUpdates {
                // Replace content when new entity arrives
                dynamicContentAnchor.children.removeAll()
                dynamicContentAnchor.addChild(newEntity)
                print("RealityView's dynamic content updated via AsyncStream.")
            }
            print("AsyncStream for entities finished in RealityView.")
        }
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
