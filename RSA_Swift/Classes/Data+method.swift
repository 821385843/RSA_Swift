//
//  Data+method.swift
//  ForcedUpdating
//
//  Created by 谢伟 on 2019/2/1.
//  Copyright © 2019 谢伟. All rights reserved.
//

import UIKit

extension Data {
    
    /// Data to base64 String
    public var base64String: String {
        return base64EncodedString(options: NSData.Base64EncodingOptions())
    }
    
    /// Array of UInt8
    public func arrayOfBytes() -> [UInt8] {
        let count = self.count / MemoryLayout<UInt8>.size
        var bytesArray = [UInt8](repeating: 0, count: count)
        (self as NSData).getBytes(&bytesArray, length:count * MemoryLayout<UInt8>.size)
        return bytesArray
    }
}
