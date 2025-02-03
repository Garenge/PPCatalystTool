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

    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        
    }];
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

@end
