//
//  PlatformImage.swift
//  CocciWallet
//
//  Created by Michael on 4/11/24.
//

import Foundation

import SwiftUI
#if canImport(UIKit)
import UIKit
public typealias PlatformImage = UIImage
#elseif canImport(AppKit)
import AppKit
public typealias PlatformImage = NSImage
#endif
