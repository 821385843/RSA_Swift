# RSA_Swift

[RSA_Swift](https://github.com/821385843/RSA_Swift) 是一款轻量级的 `Swift` 版本的框架，框架功能包括：`RSA` 加密/解密字符串、`RSA` 加密/解密 `Data`、字符串的 `MD5`、文件的 `MD5` 值的获取。

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 为什么要写 RSA_Swift ？
`github` 上 `Swift` 版本的 `RSA` 加密/解密框架也有，但大部分不维护了，所以就写了这个框架，附带的加上比较常见的功能：字符串的 `MD5`、文件的 `MD5` 值的获取。
对于文件的 `MD5` 值的获取，是将文件分块读出并且计算md5值的方法，有别于文件一次性读出并且计算md5值的方法。

## Installation

RSA_Swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RSA_Swift'
```

## 使用姿势

### `rsa` 加密字符串和解密字符串

```
/// rsa 加密字符串和解密字符串
/// 注：rsa 加密 Data 和解密 Data方法使用与“rsa 加密字符串和解密字符串”类似，这里就不写示例代码了
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
```

## License

RSA_Swift is available under the MIT license. See the LICENSE file for more info.

## Author
如果你有什么建议，可以关注我的公众号：iOS开发者进阶，直接留言，留言必回。

![输入图片说明](https://github.com/821385843/MGJRouter_Swift/blob/master/QR.png "在这里输入图片标题")
