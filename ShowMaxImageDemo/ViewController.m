//
//  ViewController.m
//  ShowMaxImageDemo
//
//  Created by LCY on 16/5/13.
//  Copyright © 2016年 LCY. All rights reserved.
//

#import "ViewController.h"

//查看大图
#import "ShowMaxImage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIButton
- (IBAction)Show:(id)sender {
    
    UIButton *button = sender;
    
    [[ShowMaxImage showMaxImage] showImage:button.imageView];
}

@end
