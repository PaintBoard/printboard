//
//  PaintView.m
//  0304自制画板
//
//  Created by Macx on 15/12/23.
//  Copyright © 2015年 Arthur. All rights reserved.
//

#import "PaintView.h"

@interface PaintView ()
{
    CGMutablePathRef path;
    
    NSMutableArray *_data;//存放画笔数据
    NSMutableArray *_paths;//存放路径数据
}
@end

@implementation PaintView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _data = [NSMutableArray array];
        
        _paths = [NSMutableArray array];
        
//        _arr = [NSMutableArray array];
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //这里每次传递过来的是指针,如果不把arr解开分别存储,每次改变原位置的数据,指针数组全部数据改变
    
//    _arr = _dataBlock();
    NSArray *arr = _dataBlock();
    UIColor *color = (UIColor *)arr[0];
    float width = [arr[1] floatValue];
    NSArray *brr = @[color,[NSNumber numberWithFloat:width]];
    [_data addObject:brr];

    //path的构建,会在touchesEnd中释放并置空
    path = CGPathCreateMutable();

    //获取开始接触点
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];

    CGPathMoveToPoint(path, NULL, p.x, p.y);
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];

    CGPathAddLineToPoint(path, NULL, p.x, p.y);

    [self setNeedsDisplay];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_paths addObject:(__bridge id _Nonnull)(path)];
    CGPathRelease(path);
    path = nil;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //for循环中画前面的path,for循环下面做当前的path绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < _paths.count; i++) {
        CGMutablePathRef path1 = (__bridge CGMutablePathRef)(_paths[i]);
        CGContextAddPath(context, path1);
        
        NSArray *arr = _data[i];
        
        CGContextSetStrokeColorWithColor(context, ((UIColor *)arr[0]).CGColor);
        CGContextSetLineWidth(context, [arr[1] floatValue]);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    CGContextAddPath(context, path);
    
    NSArray *arr = [_data lastObject];
    
    CGContextSetStrokeColorWithColor(context, ((UIColor *)arr[0]).CGColor);
    CGContextSetLineWidth(context, [arr[1] floatValue]);
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)saveImage {

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i < _paths.count; i++) {
        CGMutablePathRef path1 = (__bridge CGMutablePathRef)(_paths[i]);
        CGContextAddPath(context, path1);
        
        NSArray *arr = _data[i];
        
        CGContextSetStrokeColorWithColor(context, ((UIColor *)arr[0]).CGColor);
        CGContextSetLineWidth(context, [arr[1] floatValue]);
        CGContextDrawPath(context, kCGPathStroke);
    }
    
    CGContextAddPath(context, path);
    
    NSArray *arr = [_data lastObject];
    
    CGContextSetStrokeColorWithColor(context, ((UIColor *)arr[0]).CGColor);
    CGContextSetLineWidth(context, [arr[1] floatValue]);
    CGContextDrawPath(context, kCGPathStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    if (error == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIView *success = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 100) / 2.0, (kScreenHeight - 50) / 2.0, 100, 50)];
            
            success.tag = 18;
            success.backgroundColor = [UIColor grayColor];
            [[UIApplication sharedApplication].keyWindow addSubview:success];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
            label.text = @"保存成功";
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            [success addSubview:label];
            
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
        });
        
    }
}

- (void)timerAction:(NSTimer *)timer {
    
    [[[UIApplication sharedApplication].keyWindow viewWithTag:18] removeFromSuperview];
    [timer invalidate];
}

- (void)cancel{
    if (_paths.count != 0) {
        [_paths removeLastObject];
        [_data removeLastObject];
    }
    else if (_paths.count == 0){
        _isCancleBlock();
    }
    [self setNeedsDisplay];
}
-(void)clear{
    [_paths removeAllObjects];
    [_data removeAllObjects];
    [self setNeedsDisplay];
}
@end
