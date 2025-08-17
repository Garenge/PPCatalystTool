//
//  UIView+Drop.m
//  PPCatalystTool
//
//  Created by Garenge on 2025/8/17.
//

#import "UIView+Drop.h"
#import <objc/runtime.h>

// 关联对象的key
static char kDropCompletionBlockKey;
static char kDropInteractionKey;

@implementation UIView (Drop)

#pragma mark - Properties

- (PPDropCompletionBlock)dropCompletionBlock {
    return objc_getAssociatedObject(self, &kDropCompletionBlockKey);
}

- (void)setDropCompletionBlock:(PPDropCompletionBlock)dropCompletionBlock {
    objc_setAssociatedObject(self, &kDropCompletionBlockKey, dropCompletionBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIDropInteraction *)dropInteraction {
    return objc_getAssociatedObject(self, &kDropInteractionKey);
}

- (void)setDropInteraction:(UIDropInteraction *)dropInteraction {
    objc_setAssociatedObject(self, &kDropInteractionKey, dropInteraction, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Private Methods

- (void)setupDropInteraction {
    if (self.dropInteraction) {
        return;
    }
    
    UIDropInteraction *dropInteraction = [[UIDropInteraction alloc] initWithDelegate:self];
    [self addInteraction:dropInteraction];
    self.dropInteraction = dropInteraction;
}

- (void)removeDropInteraction {
    if (self.dropInteraction) {
        [self removeInteraction:self.dropInteraction];
        self.dropInteraction = nil;
    }
}

#pragma mark - UIDropInteractionDelegate

- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session {
    return YES; // 接受所有类型的拖拽
}

- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session {
    return [[UIDropProposal alloc] initWithDropOperation:UIDropOperationCopy];
}

- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    NSMutableArray<NSURL *> *URLs = [NSMutableArray array];
    dispatch_group_t group = dispatch_group_create();
    NSInteger totalCount = session.items.count;
    
    // 如果没有拖拽项目，直接调用回调
    if (totalCount == 0) {
        if (self.dropCompletionBlock) {
            self.dropCompletionBlock(self, [URLs copy]);
        }
        return;
    }
    
    // 处理每个拖拽项目
    for (UIDragItem *item in session.items) {
        dispatch_group_enter(group);
        
        [item.itemProvider loadItemForTypeIdentifier:@"com.apple.finder.node" options:nil completionHandler:^(id<NSSecureCoding>  _Nullable data, NSError * _Nullable error) {
            if ([(NSObject *)data isKindOfClass:[NSData class]]) {
                NSURL *url = [NSURL URLWithDataRepresentation:(NSData *)data relativeToURL:nil];
                if (url) {
                    [URLs addObject:url];
                }
            }
            
            dispatch_group_leave(group);
        }];
    }
    
    // 等待所有任务完成
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (self.dropCompletionBlock) {
            self.dropCompletionBlock(self, [URLs copy]);
        }
    });
}

#pragma mark - Public Methods

- (void)enableDropWithCompletion:(PPDropCompletionBlock)completion {
    self.dropCompletionBlock = completion;
    [self setupDropInteraction];
}

- (void)disableDrop {
    [self removeDropInteraction];
    self.dropCompletionBlock = nil;
}

@end
