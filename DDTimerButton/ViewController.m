//
//  ViewController.m
//  DDTimerButton
//
//  Created by xiaomingsong on 11/8/15.
//  Copyright © 2015 xiaomingsong. All rights reserved.
//

#import "ViewController.h"
#import "DDTimerButton.h"

@interface ViewController ()

@property (strong, nonatomic)  DDTimerButton *b1;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _b1 = [[DDTimerButton alloc] initWithInterval:60 title:@"发送验证码" withIdentifier:@"code"];
    _b1.sendVerifyCodeBlock = ^{return YES;};
    
    __weak ViewController *weakSelf = self;
    _b1.finishVerifyBlock = ^{
        [weakSelf.b1 setTitle:@"重新发送" forState:UIControlStateNormal];
    };
    
    [_b1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_b1 sizeToFit];
    
    _b1.frame = CGRectMake(100, 200, 200, 32);
    
    [self.view addSubview:self.b1];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
