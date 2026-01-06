import Foundation

#if SWIFT_PACKAGE
public let realityKitContentBundle = Bundle.module
#else
public let realityKitContentBundle = Bundle(for: RealityKitContent.self)
#endif
