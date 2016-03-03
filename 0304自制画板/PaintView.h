//
//  PaintView.h
//  0304自制画板
//
//  Created by Macx on 15/12/23.
//  Copyright © 2015年 Arthur. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray *(^DataBlock)(void);
typedef void(^IsCancleBlock)(void);
@interface PaintView : UIView

//@property (nonatomic,strong)NSMutableArray *arr;
@property (nonatomic,strong)DataBlock dataBlock;
@property (nonatomic,strong)IsCancleBlock isCancleBlock;

- (void)cancel;
- (void)clear;
- (void)saveImage;
@end
