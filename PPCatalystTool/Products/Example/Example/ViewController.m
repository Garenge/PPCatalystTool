//
//  ViewController.m
//  Example
//
//  Created by 鹏鹏 on 2022/10/15.
//

#import "ViewController.h"
#import <PPCatalystTool/PPCatalystTool.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[PPCatalystHandle sharedPPCatalystHandle] selectSingleFileWithFolderPath:@"~/Desktop"];
    NSURL *fileUrl = [[PPCatalystHandle sharedPPCatalystHandle] selectSingleFileWithFolderPath:@"~/Desktop"];
    NSString *filePath = fileUrl.absoluteString;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[PPCatalystHandle sharedPPCatalystHandle] openFileOrDirWithPath:filePath];
    });
}

@end
