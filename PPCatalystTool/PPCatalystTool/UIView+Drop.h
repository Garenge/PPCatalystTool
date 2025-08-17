//
//  UIView+Drop.h
//  PPCatalystTool
//
//  Created by Garenge on 2025/8/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 拖拽完成回调block
typedef void(^PPDropCompletionBlock)(UIView *view, NSArray<NSURL *> *fileURLs);

@interface UIView (Drop) <UIDropInteractionDelegate>

// 设置拖拽支持
- (void)enableDropWithCompletion:(nullable PPDropCompletionBlock)completion;

// 禁用拖拽
- (void)disableDrop;

@end

NS_ASSUME_NONNULL_END
