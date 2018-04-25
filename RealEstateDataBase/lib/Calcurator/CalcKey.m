//
//  CalcKey.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/29.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "CalcKey.h"

//======================================================================
@implementation CalcKey
{
    BOOL    _keyDown;
}
@synthesize text    = _text;

//======================================================================
//
//======================================================================
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//======================================================================
//
//======================================================================
-(void)setText:(NSString *)text
{
    _text   = text;
    [self setNeedsDisplay];
}

//======================================================================
//
//======================================================================
-(void)keyDown
{
    _keyDown = true;
    [self setNeedsDisplay];

}
//======================================================================
//
//======================================================================
-(void)keyUp
{
    _keyDown = false;
    [self setNeedsDisplay];
    
}
//======================================================================
//
//======================================================================
-(void)drawRect:(CGRect)rect
{
    // Drawing code
    [self setContext:UIGraphicsGetCurrentContext()];
    
    /* 背景 */
    CGFloat mergin = 1;
    if  ( _keyDown == true ){
        [self setColor_r:200 g:200 b:200];
    } else {
        [self setColor_r:240 g:240 b:240];
    }
    [self fillRect_x:mergin y:mergin w:self.frame.size.width-mergin*2 h:self.frame.size.height-mergin*2];

    NSDictionary *NSDicFont = [NSDictionary dictionaryWithObjectsAndKeys:
                               [UIFont fontWithName:@"HelveticaNeue-Light" size:30],
                               NSFontAttributeName,[UIColor blackColor],
                               NSForegroundColorAttributeName,nil];
    CGFloat x_pos;
    CGFloat y_pos;
    CGSize size = [_text sizeWithAttributes:NSDicFont];
    
    x_pos = (self.frame.size.width  - size.width ) /2;
    y_pos = (self.frame.size.height - size.height) /2;
    [_text drawAtPoint:CGPointMake(x_pos, y_pos) withAttributes:NSDicFont];
    
}


//======================================================================
@end
//======================================================================
