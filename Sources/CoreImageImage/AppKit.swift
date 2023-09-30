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

extension NSImage {
    func ciImage() -> CIImage? {
        guard let data = self.tiffRepresentation,
              let bitmap = NSBitmapImageRep(data: data) else {
            return nil
        }
        bitmap.hasAlpha = true
        let ci = CIImage(bitmapImageRep: bitmap)
        return ci
    }
}
#endif
