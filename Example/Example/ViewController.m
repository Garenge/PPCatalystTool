//
//  ViewController.m
//  Example
//
//  Created by 鹏鹏 on 2022/10/16.
//

#import "ViewController.h"
#import <PPCatalystTool/PPCatalystTool.h>

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
    [[PPCatalystHandle sharedPPCatalystHandle] openFileOrDirWithPath:path];
    //    [self openFileOrDirWithPath:@"~/Desktop"]; // 这种写法无法打开
}

- (void)doSaveFile {
    //    NSString *content = @"这是一个测试文件, 写入本地";
    //    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"test.txt"];
    //    [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString *filePath = @"/Volumes/T7/.12AC169F959B49C89E3EE409191E2EF1/Program Files (x86)/data.db";
    
    [[PPCatalystHandle sharedPPCatalystHandle] selectSingleFileWithFolderPath:filePath];
    NSLog(@"文件已保存到: %@", filePath);
    
    [[PPCatalystHandle sharedPPCatalystHandle] saveToUserDirectoryWithFilePath:filePath completeHandler:^(NSURL * _Nullable saveURL, NSError * _Nullable error) {
        
    }];
}



@end
