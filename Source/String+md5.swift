//
//  String+md5.swift
//  RSA_Swift
//
//  Created by 谢伟 on 2019/2/11.
//  Copyright © 2019 谢伟. All rights reserved.
//

import UIKit
import CommonCrypto

public extension String {
    
    /// 给 md5 字符串加密
    ///
    /// - Returns: md5 加密后的字符串
     public func md5() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        free(result)
        return String(format: hash as String)
    }
    
    /// 获取文件的 md5 值
    ///
    /// - Returns: 返回文件的 md5 值
    public func md5_File() -> String? {
        let handle = FileHandle(forReadingAtPath: self)
        
        if handle == nil {
            return nil
        }
        
        let ctx = UnsafeMutablePointer<CC_MD5_CTX>.allocate(capacity: MemoryLayout<CC_MD5_CTX>.size)
        
        CC_MD5_Init(ctx)
        
        var done = false
        
        while !done {
            let fileData = handle?.readData(ofLength: 256)
            
            fileData?.withUnsafeBytes {(bytes: UnsafePointer<CChar>)->Void in
                /// Use `bytes` inside this closure
                /// ...
                CC_MD5_Update(ctx, bytes, CC_LONG(fileData!.count))
            }
            
            if fileData?.count == 0 {
                done = true
            }
        }
        
        /// unsigned char digest[CC_MD5_DIGEST_LENGTH];
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let digest = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5_Final(digest, ctx);
        
        var hash = ""
        for i in 0..<digestLen {
            hash +=  String(format: "%02x", (digest[i]))
        }
        
        free(digest)
        free(ctx)
        
        return hash;
    }
}
