//
//  UIView+ext.m
//  01
//
//  Created by Macx on 15/12/11.
//  Copyright © 2015年 Arthur. All rights reserved.
//

#import "UIView+ext.h"

@implementation UIView (ext)
-(void)setWidth:(CGFloat)width{
    CGRect fream = self.frame;
    fream.size.width = width;
    self.frame = fream;
}
-(CGFloat)width{

    return self.frame.size.width;
}

-(void)setHeight:(CGFloat)height{
    CGRect fream = self.frame;
    fream.size.height = height;
    self.frame = fream;
}
-(CGFloat)height{
    return self.frame.size.height;
}

-(void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
-(CGPoint)origin{
    return self.frame.origin;
}

-(void)setLeft:(CGFloat)left{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}
-(CGFloat)left{
    return self.frame.origin.x;
}

-(void)setRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.x = right + frame.size.width;
    self.frame = frame;
}
-(CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setTop:(CGFloat)top{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}
-(CGFloat)top{
    return self.frame.origin.y;
}

-(void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}
-(CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}
@end
