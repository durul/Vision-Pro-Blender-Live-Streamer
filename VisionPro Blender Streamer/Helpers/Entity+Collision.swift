//
//  Entity+Collision.swift
//  VisionPro Blender Streamer
//
//  Created by Justin Leger on 11/22/25.
//

import RealityKit

extension Entity {
    /// Dynamically updates the CollisionComponent of the entity based on its current children's bounds.
    func updateCollisionShapesFromChildren() {
        
        // Calculate the combined visual bounds of all descendants relative to the parent itself.
        // Using 'self' as the reference entity gives the bounds in the parent's local coordinate system.
        let bounds = self.visualBounds(relativeTo: self)
        
        // Ensure bounds are valid (e.g., not an empty box if no children have meshes)
        guard bounds.extents.x > 0 && bounds.extents.y > 0 && bounds.extents.z > 0 else {
            print("Bounds are empty, likely no children with model components.")
            // Optionally remove the collision component if the entity should no longer be interactive
            self.components.remove(CollisionComponent.self)
            return
        }
        
        // Generate a new box shape resource from the calculated extents (size)
        let newShape = ShapeResource.generateBox(size: bounds.extents)
        // Offset the shape so its center matches the calculated center of the bounds
            .offsetBy(translation: bounds.center)
        
        // Create a new CollisionComponent with the single, updated shape
        let newCollisionComponent = CollisionComponent(shapes: [newShape])
        
        // Update the entity's component (this replaces the old one)
        self.components.set(newCollisionComponent)
        
        // If you are using the ManipulationComponent helper, you might want to call it again
        // to ensure all settings (like InputTargetComponent) are correct,
        // but updating the CollisionComponent directly is the primary fix.
    }
}
