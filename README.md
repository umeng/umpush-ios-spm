# UMPush iOS SDK · Swift Package Manager

友盟+ 消息推送组件 UMPush（UMessage）的 Swift Package Manager 分发仓库。

UMPush 依赖友盟基础组件 UMCommon，本包已在 `Package.swift` 中通过
[`umcommon-ios-spm`](https://github.com/umeng/umcommon-ios-spm) 声明该依赖，
集成方**无需**再单独添加 UMCommon 包。

## 版本对应关系

| SwiftPM tag | UMPush | UMCommon | UMDevice |
| --- | --- | --- | --- |
| `4.1.4` | `4.1.4` | `7.7.0` | `3.6.0` |

## 环境要求

- iOS 12.0 及以上。
- Xcode 14.0 及以上（Package.swift 使用 Swift tools 5.7）。
- 支持 arm64 真机，以及 arm64 / x86_64 iOS 模拟器。
- 需在 App 中链接系统框架 `UserNotifications`（Xcode 通常会自动链接）。

## Xcode 集成

1. 打开工程，选择 **File → Add Package Dependencies**。
2. 输入仓库地址：

   ```text
   https://github.com/umeng/umpush-ios-spm.git
   ```

3. 依赖规则选择 **Exact Version**，填写 `4.1.4`。
4. 点击 **Add Package**，将 `UMPush` product 添加到 App Target。

引入 `UMPush` product 后，UMPush 二进制组件、`UMPushResource.bundle` 资源，
以及依赖的 UMCommon / UMDevice 会一起参与链接与打包。

> `UMPush.framework` 为静态库，广告/插屏等图片资源通过 `[NSBundle bundleForClass:]`
> 回落到 App 主 Bundle 加载，因此 `UMPushResource.bundle` 由 `UMPushResources`
> 这个 SwiftPM target 以 `.copy` 方式拷贝进 App Bundle，集成方无需手动拖入资源。

## Package.swift 集成

在现有包的 `dependencies` 中添加：

```swift
.package(url: "https://github.com/umeng/umpush-ios-spm.git", exact: "4.1.4")
```

在使用 SDK 的 target 的 `dependencies` 中添加：

```swift
.product(name: "UMPush", package: "umpush-ios-spm")
```

## 使用示例

Objective-C：

```objc
@import UMCommon;   // 或 #import <UMCommon/UMCommon.h>
@import UMPush;     // 或 #import <UMPush/UMessage.h>

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [UMConfigure setLogEnabled:YES];
    [UMConfigure initWithAppkey:@"<你的AppKey>" channel:@"App Store"];

    UMessageRegisterEntity *entity = [[UMessageRegisterEntity alloc] init];
    entity.types = UMessageAuthorizationOptionAlert | UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionSound;
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions
                                                       Entity:entity
                                            completionHandler:^(BOOL granted, NSError *error) {
        // 注册结果
    }];
    return YES;
}

- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo
          fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [UMessage didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
```

Swift：

```swift
import UMCommon
import UMPush
```

SDK 初始化及接口使用请参考 [友盟官方文档](https://devs.umeng.com/docs/67966/detail/66734)。

## Demo 示例

纯 SwiftPM 集成的完整示例工程见 Demo 仓库 [iOS_SPM_dependency_sample](https://github.com/umeng/iOS_SPM_dependency_sample)，其中推送示例位于 [`UPushSample_iOS`](https://github.com/umeng/iOS_SPM_dependency_sample/tree/main/UPushSample_iOS) 目录，克隆后用 Xcode 打开即可编译运行。

## 许可

SDK 为友盟版权所有的闭源二进制组件，使用须遵循友盟 SDK 相关协议。
