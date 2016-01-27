//
//  ViewController.m
//  0304自制画板
//
//  Created by Macx on 15/12/23.
//  Copyright © 2015年 Arthur. All rights reserved.
//

#import "ViewController.h"
#import "ButtonChoose.h"
#import "PaintView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    ButtonChoose *buttons = [[ButtonChoose alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
    
    buttons.backgroundColor = [UIColor grayColor];
    
    [self.view addSubview:buttons];
    
    PaintView *view = [[PaintView alloc]initWithFrame:CGRectMake(0, 160, kScreenWidth, kScreenHeight - 160)];
    
    [self.view addSubview:view];
    
    buttons.paintView = view;
    
    view.isCancleBlock = ^(){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"别闹了" message:@"没东西给你撤销了" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"好吧,知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        
        [self presentViewController:alert animated:YES completion:nil];
    };
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
