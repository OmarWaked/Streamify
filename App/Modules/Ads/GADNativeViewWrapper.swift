//
//  GADNativeViewWrapper.swift
//  Streamify
//
//  Created by Omar Waked on 7/14/24.
//

import UIKit
import SwiftUI

struct GADNativeViewControllerWrapper : UIViewControllerRepresentable {

  func makeUIViewController(context: Context) -> UIViewController {
    let viewController = GADNativeViewController()
    return viewController
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }

}
