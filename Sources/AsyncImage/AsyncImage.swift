
#if canImport(SwiftUI) && canImport(Combine) && canImport(UIKit)
import Foundation
import SwiftUI
import Combine
import UIKit


public struct AsyncImage<Placeholder: View>: View {
  @ObservedObject private var loader: ImageLoader //needs to be inverted
  private let placeholder: Placeholder?
  
  private let configuration: (Image) -> Image
  
  public init(url: URL, placeholder: Placeholder? = nil, cache: ImageCacheable? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
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
        configuration(Image(uiImage: loader.image!))
      } else {
        placeholder
      }
    }
  }
}



#endif
