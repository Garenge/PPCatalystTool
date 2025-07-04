//
//  ViewController.m
//  Example
//
//  Created by 鹏鹏 on 2022/9/26.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIStackView *operationView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(200, 200, 200, 800)];
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.axis = UILayoutConstraintAxisVertical;
    [self.view addSubview:stackView];
    self.operationView = stackView;
    
    NSArray *buttons = @[
        [self createButton:@"打开文件夹" action:@selector(doOpenFolder)],
        [self createButton:@"保存文件到本地" action:@selector(doSaveFile)],
    ];
    for (UIButton *button in buttons) {
        [stackView addArrangedSubview:button];
    }
    
    stackView.frame = CGRectMake(200, 200, 200, 50 * buttons.count + 10 * (buttons.count - 1));
}

- (UIButton *)createButton:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 200, 50);
    return button;
}

- (void)doOpenFolder {
    NSString *path = @"/Users/garenge/Desktop";
    [self openFileOrDirWithPath:path];
//    [self openFileOrDirWithPath:@"~/Desktop"]; // 这种写法无法打开
}

- (void)doSaveFile {
    NSString *content = @"这是一个测试文件, 写入本地";
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"文件已保存到: %@", filePath);
    
    [self saveToUserDirectoryWithFilePath:filePath];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

#if TARGET_OS_MACCATALYST
//    NSString *filePath = @"/Users";
//
//    NSString *bundleFile = @"PPCatalystPlugin.bundle";
//    NSURL *bundleURL = [[[NSBundle mainBundle] builtInPlugInsURL] URLByAppendingPathComponent:bundleFile];
//    if (!bundleURL) {
//        return;
//    }
//    NSBundle *pluginBundle = [NSBundle bundleWithURL:bundleURL];
//    NSString *className = @"Plugin";
//    Class Plugin= [pluginBundle classNamed:className];
//    //    Plugin *obj = [[Plugin alloc] init];
////    SEL openSel = NSSelectorFromString(@"openFileOrDirWithPath:");
////    if ([Plugin respondsToSelector:openSel]) {
////        [Plugin performSelector:NSSelectorFromString(@"openFileOrDirWithPath:") withObject:filePath];
////    }
//
//    SEL openSel = NSSelectorFromString(@"selectSingleFileWithFolderPath:");
//    if ([Plugin respondsToSelector:openSel]) {
//        NSString *selectedFilePath = [Plugin performSelector:openSel withObject:@"/Users/pengpeng/Desktop/Example"];
//        NSLog(@"我选中了%@", selectedFilePath);
//        NSData *data = [NSData dataWithContentsOfFile:selectedFilePath];
//        NSLog(@"文件大小: %ld", data.length);
//    }

//    NSString *path = @"/Users/garenge/Desktop";
////    [self selectFolderWithPath:path];
//    [self openFileOrDirWithPath:@"~/Desktop"];
    
    
    
#endif
}

static NSString *bundleFileName = @"PPCatalystPlugin.bundle";
static NSString *bundlePluginClassName = @"PPCatalystPlugin";

- (Class)getBundleClassWithName:(NSString *)className {
    NSURL *bundleURL;
    bundleURL = [[[NSBundle mainBundle] builtInPlugInsURL] URLByAppendingPathComponent:bundleFileName];
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundleURL.path]) {
        bundleURL = [[[NSBundle mainBundle] resourceURL] URLByAppendingPathComponent:bundleFileName];
    }
    if (!bundleURL) {
        return nil;
    }
    NSLog(@"Get bundleURL: %@", bundleURL);
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    Class bundleClass= [bundle classNamed:className];
    return bundleClass;
}

- (BOOL)openFileOrDirWithPath:(NSString *)path {

    NSLog(@"======== openFileOrDirWithPath: %@", path);
    NSString *path1 = path;
    NSLog(@"======== openFileOrDirWithPath: %@", path);
#if TARGET_OS_MACCATALYST
    NSString *selectorString = @"openFileOrDirWithPath:";

    Class bundleClass= [self getBundleClassWithName:bundlePluginClassName];

    BOOL result = [self performSelfFuncWithString:selectorString target:bundleClass object:path1];

    return result;
#else
    return NO;
#endif
}

- (NSURL *)selectSingleFileWithFolderPath:(NSString *)folderPath {

#if TARGET_OS_MACCATALYST
    NSString *selectorString = @"selectSingleFileWithFolderPath:";

    Class bundleClass= [self getBundleClassWithName:bundlePluginClassName];

    NSURL *selectedFileURL = [self performSelfMethodWithString:selectorString target:bundleClass object:folderPath];
    NSLog(@"我选中了%@", selectedFileURL);
    // 获取文件大小 / 信息
    NSDictionary *fileInfo = [NSFileManager.defaultManager attributesOfItemAtPath:selectedFileURL.path error:nil];
    uint64 fileSize = [fileInfo fileSize];
    NSLog(@"文件大小: %llu", fileSize);

    return selectedFileURL;
#else
    return nil;
#endif
}

- (NSURL *)selectFolderWithPath:(NSString *)folderPath {

#if TARGET_OS_MACCATALYST
    NSString *selectorString = @"selectFolderWithPath:";

    Class bundleClass= [self getBundleClassWithName:bundlePluginClassName];

    NSURL *selectedFileURL = [self performSelfMethodWithString:selectorString target:bundleClass object:folderPath];
    NSLog(@"我选中了%@", selectedFileURL);

    return selectedFileURL;
#else
    return nil;
#endif
}


- (NSURL *)saveToUserDirectoryWithFilePath:(NSString *)folderPath {
    
#if TARGET_OS_MACCATALYST
    NSString *selectorString = @"saveToUserDirectoryWithFilePath:";
    
    Class bundleClass= [self getBundleClassWithName:bundlePluginClassName];
    
    id result = [self performSelfMethodWithString:selectorString target:bundleClass object:folderPath];
    NSLog(@"保存本地返回值: %@", result);
    
    return result;
#else
    return nil;
#endif
}

/// 执行自定义方法
- (id)performSelfMethodWithString:(NSString *)funcString target:(id)target object:(id)object {
    if (nil == funcString || funcString.length == 0) {
        return nil;
    }

    SEL selector = NSSelectorFromString(funcString);

    if ([target respondsToSelector:selector]) {

        IMP imp = [target methodForSelector:selector];
        id (*func)(id, SEL, id) = (void *)imp;
        return func(target, selector, object);
    } else {
        return nil;
    }
}

/// 执行自定义方法
- (id)performSelfFuncWithString:(NSString *)funcString target:(id)target object:(id)object {
    if (nil == funcString || funcString.length == 0) {
        return nil;
    }
    SEL selector = NSSelectorFromString(funcString);

    if ([target respondsToSelector:selector]) {

        return [target performSelector:selector withObject:object];
    } else {
        return nil;
    }
}


@end
