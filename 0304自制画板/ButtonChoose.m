//
//  ButtonChoose.m
//  0304自制画板
//
//  Created by Macx on 15/12/23.
//  Copyright © 2015年 Arthur. All rights reserved.
//

#import "ButtonChoose.h"
#import "PaintView.h"

/**
留出20高度状态栏,40高度button,5高度button显示栏.95高度view用来现实调色板,
 buttonAction构造思路:前面三个button都是需要paintview点击来触发,否则不会有作用,所以写入数组block传递值就行了,后两个button是直接生效的,故需要调用paintview中的接口方法
*/

@interface ButtonChoose ()
{
    NSMutableArray *_datas; //存放总数据
    NSArray *_arrColor; //存放九种颜色
    NSArray *_arrWidth; //存放7个线宽
}
@end

@implementation ButtonChoose

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _datas = [NSMutableArray arrayWithObjects:[UIColor blackColor], [NSNumber numberWithFloat:8],nil];
        
        _arrColor = @[[UIColor darkGrayColor],[UIColor redColor],[UIColor greenColor],[UIColor blueColor],[UIColor yellowColor],[UIColor orangeColor],[UIColor purpleColor],[UIColor brownColor],[UIColor blackColor]];
        
        _arrWidth = @[@"1点",@"3点",@"5点",@"8点",@"10点",@"15点",@"20点"];
        
        [self _createButtons];
        
        [self _createRedView];
        
        [self _createSubButton];
        
    }
    return self;
}

#pragma mark -create
- (void)_createButtons{//5个总button,tag = 100~104;

    CGFloat buttonWidth = kScreenWidth / 6;
    CGFloat buttonHeight = 40;
    
    NSArray *arr = @[@"颜色",@"线宽",@"橡皮",@"撤销",@"清屏",@"保存"];
    
    for (int i = 0; i < 6; i++) {
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(buttonWidth * i, 20, kScreenWidth / 6, buttonHeight)];
        
        [button setTitle:arr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        button.tag = 100 + i;
        
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:button];
    }
}

- (void)_createRedView{//按钮标示红色底图tag= 200;
    
    CGFloat buttonWidth = kScreenWidth / 6;
    CGFloat buttonHeight = 40;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, buttonHeight + 20, buttonWidth, 5)];
    view.backgroundColor = [UIColor redColor];
    view.tag = 200;
    [self addSubview:view];

}

- (void)_createSubButton{//创建子buttons

    //创建颜色子button.tag = 300~308
    CGFloat width1 = kScreenWidth / 9;
    
    for (int i = 0; i < 9; i++) {
        UIButton *buttonColor = [[UIButton alloc]initWithFrame:CGRectMake(width1 * i, 70, width1 - 5, 85)];
        
        buttonColor.backgroundColor = _arrColor[i];
        
        buttonColor.tag = 300 + i;
        
        buttonColor.hidden = YES;
        
        [buttonColor addTarget:self action:@selector(colorButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:buttonColor];
    }

    //创建线宽子button.tag = 350~356
    CGFloat width2 = kScreenWidth / 7;
    
    for (int i = 0; i < 7; i++) {
        UIButton *buttonWidth = [[UIButton alloc]initWithFrame:CGRectMake(width2 * i, 70, width2, 85)];
        
        buttonWidth.tag = 350 + i;
        
        buttonWidth.hidden = YES;
        
        [buttonWidth setTitle:_arrWidth[i] forState:UIControlStateNormal];
        [buttonWidth setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [buttonWidth addTarget:self action:@selector(widthButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:buttonWidth];
    }
}
#pragma mark - set方法复写
-(void)setPaintView:(PaintView *)paintView{
    //保证一定会有block的定义
    _paintView = paintView;
    
    __weak ButtonChoose *weakSelf = self;
    
    weakSelf.paintView.dataBlock = ^(){
        
        return _datas;
        
    };
}

#pragma mark - action
- (void)buttonAction:(UIButton *)button{
    
    //红色选中视图移动
    UIView *view = [self.superview viewWithTag:200];
    [UIView animateWithDuration:0.3 animations:^{
        
        view.center = CGPointMake(button.center.x, view.center.y);
    }];
    
    //每次点击5大button中任意一个时隐藏所有子button
    for (int i = 300; i < 309; i++) {
        UIButton *button = [self viewWithTag:i];
        button.hidden = YES;
    }
    for (int i = 350; i < 357; i++) {
        UIButton *button = [self viewWithTag:i];
        button.hidden = YES;
    }

    //进入每个对应button
    if (button.tag == 100) {//颜色button.tag = 300~308;
        for (int i = 300; i < 309; i++) {
            UIButton *button = [self viewWithTag:i];
            button.hidden = NO;
        }
    }
    
    else if (button.tag == 101){//线宽button.tag = 350~356;
        for (int i = 350; i < 357; i++) {
            UIButton *button = [self viewWithTag:i];
            button.hidden = NO;
        }
    }
    
    else if (button.tag == 102){//橡皮button
    
        [_datas replaceObjectAtIndex:0 withObject:[UIColor whiteColor]];
        
        __weak ButtonChoose *weakSelf = self;

        weakSelf.paintView.dataBlock = ^(){
            
            return _datas;
        };
        
    }
    
    else if (button.tag == 103){//撤销button
       
        [self.paintView cancel];
    
    }
    
    else if (button.tag == 104){//清屏button
       
        [self.paintView clear];
    }
    else if (button.tag == 105) {//保存button
    

        [self.paintView saveImage];
    }
}
//颜色按钮子按钮的响应
- (void)colorButtonAction:(UIButton *)button{
    //首先更改_datas中的对应值
    [_datas replaceObjectAtIndex:0 withObject:_arrColor[button.tag - 300]];
    
    __weak ButtonChoose *weakSelf = self;
    
    weakSelf.paintView.dataBlock = ^(){

        return _datas;
    };
}

//线宽按钮子按钮的响应
- (void)widthButtonAction:(UIButton *)button{
    
    CGFloat width = (CGFloat)[_arrWidth[button.tag - 350] floatValue];
    
    [_datas replaceObjectAtIndex:1 withObject:[NSNumber numberWithFloat:width]];
    
    __weak ButtonChoose *weakSelf = self;
    
    weakSelf.paintView.dataBlock = ^(){
        
        return _datas;
        
    };
    
}

@end
