# UIView+Drop 分类

一个专为 macOS Catalyst 环境设计的简单文件拖拽功能分类。

## 功能特性

- 🎯 **极简设计**: 一行代码即可启用拖拽功能
- 📁 **文件支持**: 支持拖拽文件、文件夹、图片、文本等
- 🔧 **简单回调**: 只需一个完成回调即可处理所有拖拽

## 使用方法

### 基本用法

```objc
#import "UIView+Drop.h"

// 创建视图
UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
dropView.backgroundColor = [UIColor lightGrayColor];

// 启用拖拽，设置完成回调
[dropView enableDropWithCompletion:^(UIView *view, NSArray<NSURL *> *fileURLs) {
    NSLog(@"拖拽完成，接收到 %lu 个文件", (unsigned long)fileURLs.count);
    
    // 处理拖拽的文件
    for (NSURL *fileURL in fileURLs) {
        NSLog(@"接收到文件: %@", fileURL.path);
        
        // 检查文件是否存在
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:fileURL.path]) {
            NSDictionary *attributes = [fileManager attributesOfItemAtPath:fileURL.path error:nil];
            NSLog(@"文件大小: %lld bytes", [attributes fileSize]);
        }
    }
}];
```

### 禁用拖拽

```objc
[dropView disableDrop];
```

## API 参考

### 方法

| 方法 | 说明 |
|------|------|
| `enableDropWithCompletion:` | 启用拖拽功能并设置完成回调 |
| `disableDrop` | 禁用拖拽功能 |

### 回调 Block

```objc
typedef void(^PPDropCompletionBlock)(UIView *view, NSArray<NSURL *> *fileURLs);
```

- `view`: 接收拖拽的视图
- `fileURLs`: 拖拽的文件URL数组

## 支持的文件类型

该分类接受所有类型的拖拽，包括但不限于：

- 文件和文件夹
- 图片 (JPEG, PNG, GIF, TIFF, HEIC)
- 文本 (纯文本, RTF, HTML)
- PDF 文档
- 音频和视频文件
- 压缩包

## 注意事项

1. **平台限制**: 此功能仅在 macOS Catalyst 环境下有效
2. **权限要求**: 某些文件类型可能需要相应的权限
3. **线程安全**: 回调可能在非主线程执行，更新UI时请切换到主线程

## 示例代码

完整的使用示例请参考 `UIView+DropExample.h` 和 `UIView+DropExample.m` 文件。 