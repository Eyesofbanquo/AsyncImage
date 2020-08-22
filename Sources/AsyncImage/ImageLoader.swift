//
//  File.swift
//  
//
//  Created by Markim Shaw on 8/22/20.
//
#if canImport(SwiftUI) && canImport(Combine) && canImport(UIKit)

import Combine
import Foundation
import SwiftUI

public class ImageLoader: ObservableObject {
  
  private static let imageProcessingQueue = DispatchQueue(label: "image-loading")
  
  @Published var image: UIImage?
  
  private var cancellable: AnyCancellable?
  
  private let url: URL
  
  private var cache: ImageCacheable?
  
  private(set) var isLoading: Bool = false
  
  public init(url: URL, cache: ImageCacheable? = nil) {
    self.url = url
    self.cache = cache
  }
  
  deinit {
    cancellable?.cancel()
  }
  
  public func load() {
    guard isLoading == false else { return }
    
    if let image = cache?[url] {
      self.image = image
      return
    }
    
    cancellable = URLSession.shared.dataTaskPublisher(for: url)
      .subscribe(on: Self.imageProcessingQueue)
      .map { UIImage(data: $0.data) }
      .replaceError(with: nil)
      .handleEvents(
        receiveSubscription: { [weak self] _ in self?.onStart() },
        receiveOutput: { [weak self] in self?.cache($0)},
        receiveCompletion: { [weak self] _ in self?.onFinish() },
        receiveCancel: { [weak self] in self?.onFinish() }
    )
      .receive(on: DispatchQueue.main)
      .assign(to: \.image, on: self)
  }
  
  private func cache(_ image: UIImage?) {
    image.map { cache?[url] = $0 }
  }
  
  private func onStart() {
    isLoading = true
  }
  
  private func onFinish() {
    isLoading = false
  }
  
  public func cancel() {
    cancellable?.cancel()
  }
}

#endif
