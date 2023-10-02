#if os(macOS)
import AppKit
import Foundation

public func LoadFromURL(url: URL) -> Result<CIImage, Error> {
    
    guard let im = NSImage(byReferencingFile:url.path) else {
        return .failure(Errors.invalidImage)
    }
    
    guard let ciImage = im.ciImage() else {
        return .failure(Errors.ciImage)
    }
    
    return .success(ciImage)
}

public func AsPNGData(image: CIImage) -> Result<Data, Error> {
    
    let ns_im = NSImage.fromCIImage(image)
    
    guard let png_data = ns_im.pngData else {
        return .failure(Errors.pngData)
    }
    
    return .success(png_data)
}

extension NSImage {
    
    var pngData: Data? {
        
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else {
            return nil
        }
        
        return bitmapImage.representation(using: .png, properties: [:])
    }
    
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            return false
        }
    }
    
    func ciImage() -> CIImage? {
        guard let data = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: data) else {
            return nil
        }
        bitmap.hasAlpha = true
        let ci = CIImage(bitmapImageRep: bitmap)
        return ci
    }
    static func fromCIImage(_ ciImage: CIImage) -> NSImage {
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        return nsImage
    }
}
#endif
