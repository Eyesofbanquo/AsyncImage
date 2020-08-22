
#if canImport(SwiftUI) && canImport(Combine) && canImport(UIKit)
import Foundation
import SwiftUI
import Combine
import UIKit


public struct AsyncImage<Placeholder: View>: View {
  @ObservedObject private var loader: ImageLoader //needs to be inverted
  private let placeholder: Placeholder?
  
  public init(url: URL, placeholder: Placeholder? = nil, cache: ImageCacheable? = nil) {
    loader = ImageLoader(url: url, cache: cache) // needs to be inverted
    self.placeholder = placeholder
  }
  
  public var body: some View {
    image
      .onAppear(perform: loader.load)
      .onDisappear(perform: loader.cancel)
  }
  
  private var image: some View {
    Group {
      if loader.image != nil {
        Image(uiImage: loader.image!)
          .resizable()
      } else {
        placeholder
      }
    }
  }
}



#endif
