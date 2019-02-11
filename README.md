# RSA_Swift

[RSA_Swift](https://github.com/821385843/RSA_Swift) 是一款轻量级的 `Swift` 版本的框架，框架功能包括：`RSA` 加密/解密字符串、`RSA` 加密/解密 `Data`、字符串的 `MD5`、文件的 `MD5` 值的获取。

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## 为什么要写 RSA_Swift ？
`github` 上 `Swift` 版本的 `RSA` 加密/解密框架也有，但大部分不维护了，所以就写了这个框架，附带的加上比较常见的功能：字符串的 `MD5`、文件的 `MD5` 值的获取。
对于文件的 `MD5` 值的获取，是将文件分块读出并且计算md5值的方法，有别于文件一次性读出并且计算md5值的方法。

## 安装

```
pod 'RSA_Swift'
```

## 使用姿势

### 最基本的使用

```
MGJRouter.registerWithHandler("mgj://foo/bar") { (routerParameters) in
   print("routerParameters:\(routerParameters ?? [:])")
}
        
MGJRouter.open("mgj://foo/bar")
```

当匹配到 URL 后，`routerParameters` 会自带几个 key

```
public let MGJRouterParameterURL = "MGJRouterParameterURL"
public let MGJRouterParameterCompletion = "MGJRouterParameterCompletion"
public let MGJRouterParameterUserInfo = "MGJRouterParameterUserInfo"
```

### 处理中文也没有问题

```
MGJRouter.registerWithHandler("mgj://category/家居") { (routerParameters) in
   print("routerParameters:\(routerParameters ?? [:])")
}
        
MGJRouter.open("mgj://category/家居")
```

### Open 时，可以传一些 userinfo 过去

```
MGJRouter.registerWithHandler("mgj://category/travel") { (routerParameters) in
    print("routerParameters:\(routerParameters ?? [:])")
}
        
MGJRouter.open("mgj://category/travel", ["user_id": "1900"], nil)
```

### 如果有可变参数（包括 URL Query Parameter）会被自动解析

```
MGJRouter.registerWithHandler("mgj://search/:query") { (routerParameters) in
    print("routerParameters:\(routerParameters ?? [:])")
}
        
MGJRouter.open("mgj://search/bicycle?color=red")
```

### 定义一个全局的 URL Pattern 作为 Fallback

```
MGJRouter.registerWithHandler("mgj://") { (routerParameters) in
    print("没有人处理该 URL，就只能 fallback 到这里了")
}
        
MGJRouter.open("mgj://search/travel/china?has_travelled=0")
```

### 当 Open 结束时，执行 Completion Block

```
MGJRouter.registerWithHandler("mgj://detail") { [weak self] (routerParameters) in
    print("匹配到了 url, 一会会执行 Completion 闭包")
            
    // 模拟 push 一个 VC
    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
       let completion = routerParameters?[MGJRouterParameterCompletion] as? ((Any?)->())
       completion?(nil)
    })
}
        
MGJRouter.open("mgj://detail", nil) { [weak self] (obj) in
    self?.appendLog("Open 结束，我是 Completion Block")
}
```

### 生成 URL

URL 的处理一不小心，就容易散落在项目的各个角落，不容易管理。比如注册时的 pattern 是 `mgj://beauty/:id`，然后 open 时就是 `mgj://beauty/123`，这样到时候 url 有改动，处理起来就会很麻烦，不好统一管理。

所以 MGJRouter_Swift 提供了一个类方法来处理这个问题。

```
class func generateURL(_ pattern: String, _ parameters: [String]) -> String?
```

使用方式

```
let TEMPLATE_URL = "mgj://search/:keyword"

MGJRouter.registerWithHandler(TEMPLATE_URL) { (routerParameters) in
   print("routerParameters[keyword]:\(routerParameters?["keyword"] as? String ?? "")") // Hangzhou
}
        
MGJRouter.open(MGJRouter.generateURL(TEMPLATE_URL, ["Hangzhou"]) ?? "")
```

这样就可以在一个地方定义所有的 URL Pattern，使用时，用这个方法生成 URL 就行了。


## 协议

MGJRouter_Swift 被许可在 MIT 协议下使用。查阅 LICENSE 文件来获得更多信息。

## 作者有话说
如果你有什么建议，可以关注我的公众号：iOS开发者进阶，直接留言，留言必回。

![输入图片说明](https://github.com/821385843/MGJRouter_Swift/blob/master/QR.png "在这里输入图片标题")


# RSA_Swift
## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RSA_Swift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'RSA_Swift'
```

## Author

821385843@qq.com, 821385843@qq.com

## License

RSA_Swift is available under the MIT license. See the LICENSE file for more info.
