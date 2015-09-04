//
//  DrawTool.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/26.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>

/****************************************************************/
@interface DrawTool : UIView
/****************************************************************/
-(void) setContext:(CGContextRef)context;
-(void) setLineWidth:(CGFloat)width;
-(void) setColor_r:(NSInteger)r g:(NSInteger)g b:(NSInteger)b;
-(void) drawLine_x0:(CGFloat)x0 y0:(CGFloat)y0 x1:(CGFloat)x1 y1:(CGFloat)y1;
-(void) fillRect_x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h;
-(void) drawRect_x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h;
-(void) drawCircle_x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h;
-(void) fillCircle_x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h;
/****************************************************************/
@end
/****************************************************************/