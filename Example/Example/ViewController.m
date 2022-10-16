//
//  ViewController.m
//  Example
//
//  Created by 鹏鹏 on 2022/10/16.
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

    [[PPCatalystHandle sharedPPCatalystHandle] selectSingleFileWithFolderPath:@""];
}


@end
