//
//  ViewController.swift
//  RSA_Swift
//
//  Created by 821385843@qq.com on 02/11/2019.
//  Copyright (c) 2019 821385843@qq.com. All rights reserved.
//

import UIKit
import RSA_Swift

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rsaEncryptOrDecryptForString()
        md5String()
        fileMD5()
    }
    
    /// rsa 加密字符串和解密字符串
    /// 注：rsa 加密 Data 和解密 Data方法使用与“rsa 加密字符串和解密字符串”类似，这里就不写示例代码了
    func rsaEncryptOrDecryptForString() {
        let filePath = Bundle.main.path(forResource: "public_key", ofType: "der")
        
        let encryptString = "abcdefg"
        print("\n要加密的字符串：\(encryptString)\n")
        
        /// Encrypt
        RSA.rsaEncrypt(filePath, encryptString) { (encryptedString) in
            print("\n加密后的字符串：\(encryptedString ?? "")\n")
            
            let filePath1 = Bundle.main.path(forResource: "private_key.p12", ofType: nil)
            /// Decrypt
            RSA.rsaDecrypt(filePath1, "ios", encryptedString, { (decryptedString) in
                print("\n解密后的字符串：\(decryptedString ?? "")\n")
            })
        }
    }
    
    /// 字符串的 MD5
    func md5String() {
        let str = "字符串的MD5"
        print("\n字符串的MD5：\(str.md5())\n")
    }
    
    /// 文件的 MD5 值
    func fileMD5() {
        guard let filePath = Bundle.main.path(forResource: "test_file_md5", ofType: "png")
            else {
                return
        }
        
        print("\n文件的 MD5 值：\(filePath.md5_File() ?? "")\n")
    }
}
