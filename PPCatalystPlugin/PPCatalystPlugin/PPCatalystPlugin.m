//
//  PPCatalystPlugin.m
//  PPCatalystPlugin
//
//  Created by 鹏鹏 on 2021/3/11.
//

#import "PPCatalystPlugin.h"

@implementation PPCatalystPlugin

- (NSNumber *)openFileOrDirWithPath:(NSString *)path {
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[[NSURL fileURLWithPath:path]]];
    return @(YES);
}

+ (NSNumber *)openFileOrDirWithPath:(NSString *)path {
    return [[self new] openFileOrDirWithPath:path];
}

+ (NSURL *)selectSingleFileWithFolderPath:(NSString *)folderPath {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt: @"打开"];

    // openPanel.allowedFileTypes = [NSArray arrayWithObjects: @"jpg", @"png", @"jpeg", nil];
    NSString*bundel=[[NSBundle mainBundle] resourcePath];

    NSString *location;
    if (folderPath.length > 0) {
        location = folderPath;
    } else {
        location=[[bundel substringToIndex:[bundel rangeOfString:@"Library"].location] stringByAppendingFormat:@"Desktop"];

    }
    openPanel.directoryURL = [NSURL fileURLWithPath:location];
    NSLog(@"%@", location);
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)objectAtIndex:0]);


    [openPanel setCanChooseFiles:YES]; //是否能选择多文件file
    [openPanel setCanChooseDirectories:NO]; //是否能打开文件夹
    [openPanel setAllowsMultipleSelection:NO]; //是否允许多选file

    // 注释掉这句话, 不然卡进程
//    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
//        
//    }];
    NSInteger finded = [openPanel runModal]; //获取panel的响应

    if (finded == NSModalResponseOK) {
        // 选中确认键
        // 我们默认设置只有一个文件, 所以不用for循环
        NSURL *selectUrl = [openPanel URL];
        NSLog(@"文件路径--->%@, path = %@", selectUrl, selectUrl.path);
        return selectUrl;
    } else {
        return nil;
    }
}

+ (NSURL *)selectFolderWithPath:(NSString *)folderPath {
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setPrompt: @"打开"];

    // openPanel.allowedFileTypes = [NSArray arrayWithObjects: @"jpg", @"png", @"jpeg", nil];
    NSString*bundel=[[NSBundle mainBundle] resourcePath];

    NSString *location;
    if (folderPath.length > 0) {
        location = folderPath;
    } else {
        location=[[bundel substringToIndex:[bundel rangeOfString:@"Library"].location] stringByAppendingFormat:@"Desktop"];

    }
    openPanel.directoryURL = [NSURL fileURLWithPath:location];
    NSLog(@"%@", location);
    NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES)objectAtIndex:0]);


    [openPanel setCanChooseFiles:NO]; //是否能选择多文件file
    [openPanel setCanChooseDirectories:YES]; //是否能打开文件夹
    [openPanel setAllowsMultipleSelection:NO]; //是否允许多选file

    NSInteger finded = [openPanel runModal]; //获取panel的响应

    if (finded == NSModalResponseOK) {
        // 选中确认键
        // 我们默认设置只有一个文件, 所以不用for循环
        NSURL *selectUrl = [openPanel URL];
        NSLog(@"文件路径--->%@, path = %@", selectUrl, selectUrl.path);
        return selectUrl;
    } else {
        return nil;
    }
}

+ (void)saveToUserDirectoryWithFilePath:(NSString *)filePath completeHandler:(nonnull void (^)(NSURL * _Nullable, NSError * _Nullable))completeHandler {
    
    if (nil == completeHandler) {
        return;
    }
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.title = @"保存文件";
    
    NSString *fileName = filePath.lastPathComponent;
    NSString *pathExtension = fileName.pathExtension;
    if (pathExtension.length > 0) {
        panel.allowedFileTypes = @[pathExtension];
    } else {
        panel.allowedFileTypes = @[];
    }
    
    __block NSError *error;
    __block NSURL *saveURL;
    [panel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result != NSModalResponseOK) {
            NSLog(@"已取消");
            return;
        }
        saveURL = panel.URL;
        
        if (nil == saveURL) {
            completeHandler(nil, [NSError errorWithDomain:@"saveURL is nil" code:-1 userInfo:nil]);
            return;
        }
        
        if ([NSFileManager.defaultManager fileExistsAtPath:saveURL.path]) {
            NSLog(@"路径文件已存在, 即将删除");
            [NSFileManager.defaultManager removeItemAtURL:saveURL error:&error];
            if (error) {
                NSLog(@"移除旧文件失败");
                completeHandler(saveURL, error);
                return;
            } else {
                NSLog(@"移除旧文件成功");
            }
        }
        
        [NSFileManager.defaultManager copyItemAtPath:filePath toPath:saveURL.path error:&error];
        
        if (error) {
            NSLog(@"保存文件失败");
            completeHandler(saveURL, error);
            return;
        } else {
            NSLog(@"保存操作完成");
        }
        completeHandler(saveURL, error);
    }];
}

@end
