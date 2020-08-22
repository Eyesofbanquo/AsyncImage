//
//  File.swift
//  
//
//  Created by Markim Shaw on 8/22/20.
//

import Foundation

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI

public protocol ImageCacheable {
  subscript(_ url: URL) -> UIImage? { get set }
}

public struct ImageCacheKey: EnvironmentKey {
  public static let defaultValue: ImageCacheable = TemporaryImageCache()
}

extension EnvironmentValues {
  public var imageCache: ImageCacheable {
    get { self[ImageCacheKey.self] }
    set { self[ImageCacheKey.self] = newValue }
  }
}
#endif

