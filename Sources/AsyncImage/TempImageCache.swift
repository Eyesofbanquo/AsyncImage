//
//  File.swift
//  
//
//  Created by Markim Shaw on 8/22/20.
//

import Foundation

#if canImport(SwiftUI) && canImport(UIKit)
import SwiftUI

public struct TemporaryImageCache: ImageCacheable {
  private let cache = NSCache<NSURL, UIImage>()
  
  public init() { }
  
  public subscript(_ key: URL) -> UIImage? {
    get { cache.object(forKey: key as NSURL) }
    set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL)}
  }
}
#endif
