//
//  ViewController.m
//  HWLAlertView
//
//  Created by 侯卫磊 on 16/8/17.
//  Copyright © 2016年 侯卫磊. All rights reserved.
//

#import "ViewController.h"
#import "HWLAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)clickButton:(UIButton *)sender {
    HWLAlertView * alertView = [[HWLAlertView alloc] initWithFrame:CGRectMake(0, 0, 100, 200)];
    alertView.alertTitle = @"alert title";
    alertView.alertMessage  = @"alert message";
    alertView.buttonTitles = @[@"取消",@"确认"];
    [alertView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
