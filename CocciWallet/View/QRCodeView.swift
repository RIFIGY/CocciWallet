//
//  QRCodeView.swift
//  CocciWallet
//
//  Created by Michael Wilkowski on 3/18/24.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
#if canImport(UIKit)
import UIKit

struct QRCodeView: View {
    @Environment(\.colorScheme) private var colorScheme
    
    let string: String
    let background: Color?
    let foreground: Color?
    
    var backgroundColor: UIColor {
        let defaultColor = colorScheme == .light ? Color.white : .black
        return background?.uiColor() ?? defaultColor.uiColor()
    }
    
    var foregroundColor: UIColor {
        let defaultColor = colorScheme == .light ? Color.black : .white
        return foreground?.uiColor() ?? defaultColor.uiColor()
    }
    
    init(_ string: String, background: Color? = nil, foreground: Color? = nil) {
        self.string = string
        self.background = background
        self.foreground = foreground
    }
    
    @State private var image: UIImage?

    var body: some View {
        ZStack {
            Color(uiColor: backgroundColor)
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(contentMode: .fit)
            }
        }
        .onAppear {
            generateImage()
        }
    }

    private func generateImage() {
        guard image == nil else { return }

        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)

        guard let qrImage = filter.outputImage else { return }
        
        let colorFilter = CIFilter.falseColor()
        colorFilter.inputImage = qrImage
        colorFilter.color0 = CIColor(color: foregroundColor)
        colorFilter.color1 = CIColor(color: backgroundColor)

        guard
            let coloredImage = colorFilter.outputImage,
            let cgImage = context.createCGImage(coloredImage, from: coloredImage.extent)
        else { return }

        self.image = UIImage(cgImage: cgImage)
    }

}

extension Color {
    func uiColor() -> UIColor {
        if let components = self.cgColor?.components {
            return UIColor(displayP3Red: components[0], green: components[1], blue: components[2], alpha: components[3])
        } else {
            return UIColor(displayP3Red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
    }
}

#Preview {
    QRCodeView(Wallet.rifigy.address)
}
#endif
