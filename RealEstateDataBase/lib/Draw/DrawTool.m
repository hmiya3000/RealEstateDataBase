//
//  DrawTool.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/26.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "DrawTool.h"

@implementation DrawTool
{
    CGContextRef    _context;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/****************************************************************
 *
 ****************************************************************/
-(void)setContext:(CGContextRef)context
{
    if ( _context != NULL){
        CGContextRelease(_context);
        _context = NULL;
    }
    _context=context;
    CGContextRetain(_context);
}
/****************************************************************
 *
 ****************************************************************/
-(void)setColor_r:(NSInteger)r g:(NSInteger)g b:(NSInteger)b
{
    CGContextSetRGBFillColor(_context,
                             r/255.0f,
                             g/255.0f,
                             b/255.0f,
                             1.0f);
    CGContextSetRGBStrokeColor(_context,
                               r/255.0f,
                               g/255.0f,
                               b/255.0f,
                               1.0f);
}
/****************************************************************
 *
 ****************************************************************/
-(void)setLineWidth:(CGFloat)width
{
    CGContextSetLineWidth(_context, width);
}

/****************************************************************
 *
 ****************************************************************/
-(void)drawLine_x0:(CGFloat)x0 y0:(CGFloat)y0 x1:(CGFloat)x1 y1:(CGFloat)y1
{
    CGContextSetLineCap(_context, kCGLineCapRound);
    CGContextMoveToPoint(_context, x0, y0);
    CGContextAddLineToPoint(_context, x1, y1);
    CGContextStrokePath(_context);
}
/****************************************************************
 *
 ****************************************************************/
-(void)fillRect_x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h
{
    CGContextFillRect( _context, CGRectMake(x, y, w, h));
}
/****************************************************************
 *
 ****************************************************************/
-(void)drawRect_x:(CGFloat)x y:(CGFloat)y w:(CGFloat)w h:(CGFloat)h
{
    CGContextMoveToPoint(   _context, x, y);
    CGContextAddLineToPoint(_context, x+w,  y   );
    CGContextAddLineToPoint(_context, x+w,  y+h );
    CGContextAddLineToPoint(_context, x,    y+h );
    CGContextAddLineToPoint(_context, x,    y);
    CGContextAddLineToPoint(_context, x+w, y);
    CGContextStrokePath(_context);
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
