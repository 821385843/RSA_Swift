//
//  XWRSAEncryptor.swift
//  ForcedUpdating
//
//  Created by 谢伟 on 2019/2/1.
//  Copyright © 2019 谢伟. All rights reserved.
//

import UIKit
import CoreFoundation
import CommonCrypto

let kTypeOfWrapPadding = SecPadding.PKCS1

public class RSA: NSObject {
    
    /// 公钥引用
    static var publicKeyRef: SecKey?
    
    /// 私钥引用
    static var privateKeyRef: SecKey?
    
    /// rsa 加密字符串
    ///
    /// - Parameter string: 要加密的字符串
    /// - Returns: 加密后的 BASE64 编码字符串
    public class func rsaEncrypt(_ publicKeyPath: String?, _ string: String, _ completion: ((_ encryptedString: String?) -> ())?) {
        guard let encryptData = string.data(using: String.Encoding.utf8) else {
                print("String to be encrypted is nil")
                completion?(nil)
                return
        }
        
        rsaEncrypt(publicKeyPath, encryptData) { (data) in
            guard let encryptedData = data else {
                completion?(nil)
                return
            }
            
            completion?(encryptedData.base64String)
        }
    }
    
    /// rsa 加密二进制数据
    ///
    /// - Parameter data: 要加密的二进制数据
    /// - Returns: 加密后的二进制数据
    public class func rsaEncrypt(_ publicKeyPath: String?, _ data: Data?, _ completion: ((_ encryptedData: Data?) -> ())?) {
        guard let pkPath = publicKeyPath,
              let pkRef = loadPublicKey(pkPath),
              let dt = data else {
            print("path of public key is nil.")
            completion?(nil)
            return
        }
        
        guard dt.count > 0 && dt.count < SecKeyGetBlockSize(pkRef) - 11
            else {
                print("The content encrypted is too large")
                completion?(nil)
                return
        }
        
        let cipherBufferSize = SecKeyGetBlockSize(pkRef)
        var encryptBytes = [UInt8](repeating: 0, count: cipherBufferSize)
        var outputSize: Int = cipherBufferSize
        let secKeyEncrypt = SecKeyEncrypt(pkRef, SecPadding.PKCS1, dt.arrayOfBytes(), dt.count, &encryptBytes, &outputSize)
        if errSecSuccess != secKeyEncrypt {
            print("decrypt unsuccessfully")
            completion?(nil)
            return
        }
        
        completion?(Data(bytes: UnsafePointer<UInt8>(encryptBytes), count: outputSize))
    }
    
    /// rsa 解密字符串
    ///
    /// - Parameters:
    ///   - privateKeyPath: 私钥路径
    ///   - password: 私钥密码
    ///   - string: 要解密的 base64 编码字符串
    /// - Returns: 解密后的字符串
    public class func rsaDecrypt(_ privateKeyPath: String?, _ password: String, _ string: String?, _ completion: ((_ encryptedString: String?) -> ())?) {
        guard let str = string,
            let decryptData = Data(base64Encoded: str) else {
                print("String to be decrypted is nil")
                completion?(nil)
                return
        }
        
        rsaDecrypt(privateKeyPath, password, decryptData) { (data) in
            guard let decryptedData = data else {
                completion?(nil)
                return
            }
            
            completion?(String(data: decryptedData, encoding: String.Encoding.utf8))
        }
    }
    
    /// rsa 解密二进制数据
    ///
    /// - Parameters:
    ///   - privateKeyPath: 私钥路径
    ///   - password: 私钥密码
    ///   - data: 要解密的二进制数据
    /// - Returns: 解密后的二进制数据
    public class func rsaDecrypt(_ privateKeyPath: String?, _ password: String, _ data: Data?, _ completion: ((_ encryptedData: Data?) -> ())?) {
        guard let pkPath = privateKeyPath,
            let pkRef = loadPrivateKey(pkPath, password),
            let dt = data else {
                print("path of private key is nil.")
                completion?(nil)
                return
        }
        
        let cipherBufferSize = SecKeyGetBlockSize(pkRef)
        let keyBufferSize = dt.count
        if keyBufferSize > cipherBufferSize {
            print("The content decrypted is too large")
            completion?(nil)
            return
        }
        
        var decryptBytes = [UInt8](repeating: 0, count: cipherBufferSize)
        var outputSize = cipherBufferSize
        let status = SecKeyDecrypt(pkRef, SecPadding.PKCS1, dt.arrayOfBytes(), dt.count, &decryptBytes, &outputSize)
        if errSecSuccess != status {
            print("decrypt unsuccessfully")
            completion?(nil)
            return
        }
        
        completion?(Data(bytes: UnsafePointer<UInt8>(decryptBytes), count: outputSize))
    }
}

extension RSA {
    
    /// 加载公钥
    ///
    /// - Parameter filePath: .der公钥文件路径
    class func loadPublicKey(_ filePath: String) -> SecKey? {
        if publicKeyRef != nil {
            publicKeyRef = nil
        }
        
        var certificateRef: SecCertificate?
        
        do {
            // 用一个.der格式证书创建一个证书对象
            let certificateData = try Data(contentsOf: URL(fileURLWithPath: filePath))
            certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, certificateData as CFData)
        } catch {
            print("file of public key is error.")
            return nil
        }
        
        // 返回一个默认 X509 策略的公钥对象
        let policyRef = SecPolicyCreateBasicX509()
        // 包含信任管理信息的结构体
        var trustRef: SecTrust?
        
        // 基于证书和策略创建一个信任管理对象
        var status = SecTrustCreateWithCertificates(certificateRef!, policyRef, &trustRef)
        if status != errSecSuccess {
            print("trust create With Certificates unsuccessfully")
            return nil
        }
        
        // 信任结果
        var trustResult = SecTrustResultType.invalid
        // 评估指定证书和策略的信任管理是否有效
        status = SecTrustEvaluate(trustRef!, &trustResult)
        
        if status != errSecSuccess {
            print("trust evaluate unsuccessfully")
            return nil
        }
        
        // 评估之后返回公钥子证书
        publicKeyRef = SecTrustCopyPublicKey(trustRef!)
        if publicKeyRef == nil {
            print("public Key create unsuccessfully")
            return nil
        }
        
        return publicKeyRef
    }
    
    /// 加载私钥
    ///
    /// - Parameters:
    ///   - filePath: .p12私钥文件路径
    ///   - password: 私钥密码
    class func loadPrivateKey(_ filePath: String, _ password: String) -> SecKey? {
        if filePath.count <= 0  {
            print("path of public key is nil.")
            return nil
        }
        
        if privateKeyRef != nil {
            privateKeyRef = nil
        }
        
        var pkcs12Data: Data?
        do {
            pkcs12Data = try Data(contentsOf: URL(fileURLWithPath: filePath))
        } catch {
            print(error)
            return nil
        }
        
        let kSecImportExportPassphraseString = kSecImportExportPassphrase as String
        let options = [kSecImportExportPassphraseString: password]
        var items : CFArray?
        let status = SecPKCS12Import(pkcs12Data! as CFData, options as CFDictionary, &items)
        if status != errSecSuccess {
            print("Imports the contents of a PKCS12 formatted blob unsuccessfully")
            return nil
        }
        
        if CFArrayGetCount(items) <= 0 {
            print("the number of values currently in the array <= 0")
            return nil
        }
        
        let kSecImportItemIdentityString = kSecImportItemIdentity
        
        let dict = unsafeBitCast(CFArrayGetValueAtIndex(items, 0),to: CFDictionary.self)
        let key = Unmanaged.passUnretained(kSecImportItemIdentityString).toOpaque()
        let value = CFDictionaryGetValue(dict, key)
        let secIdentity = unsafeBitCast(value, to: SecIdentity.self)
        
        let secIdentityCopyPrivateKey = SecIdentityCopyPrivateKey(secIdentity, &privateKeyRef)
        if secIdentityCopyPrivateKey != errSecSuccess {
            print("return the private key associated with an identity unsuccessfully")
            return nil
        }
        return privateKeyRef
    }
}
