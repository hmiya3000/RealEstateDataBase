//
//  GridTable.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/06.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawTool.h"

//======================================================================
@interface GridTable : DrawTool
{
    NSArray         *_table;
    CGFloat         _widthTitle;
    CGFloat         _widthSum;
    CGFloat         _widthLastCol;
    CGFloat         _heightSum;
}
//======================================================================
+ (UIView*) makeGridTable;
+ (void)setRectScroll:(UIView*)view rect:(CGRect)frame;
+ (void)setScroll:(UIView*)view table:(NSArray*)allArr;
//======================================================================
@property   (nonatomic,readwrite)   NSArray     *table;
@property   (nonatomic,readonly)    CGFloat     widthTitle;
@property   (nonatomic,readonly)    CGFloat     widthSum;
@property   (nonatomic,readonly)    CGFloat     widthLastCol;
@property   (nonatomic,readonly)    CGFloat     heightSum;

//======================================================================
@end
//======================================================================
