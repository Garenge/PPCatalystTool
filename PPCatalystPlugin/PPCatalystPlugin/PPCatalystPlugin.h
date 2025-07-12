//
//  PPCatalystPlugin.h
//  PPCatalystPlugin
//
//  Created by 鹏鹏 on 2021/3/11.
//

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PPCatalystPlugin : NSObject

- (NSNumber *)openFileOrDirWithPath:(NSString *)path;
+ (NSNumber *)openFileOrDirWithPath:(NSString *)path;
+ (nullable NSURL *)selectSingleFileWithFolderPath:(NSString *)folderPath;
+ (nullable NSURL *)selectFolderWithPath:(NSString *)folderPath;

+ (void)saveToUserDirectoryWithFilePath:(NSString *)filePath completeHandler:(void(^)(NSURL * _Nullable saveURL, NSError  * _Nullable error))completeHandler;

@end

NS_ASSUME_NONNULL_END
