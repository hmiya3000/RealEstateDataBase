//
//  GridTable.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/06.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "GridTable.h"

@implementation GridTable
{
}
@synthesize table           = _table;
@synthesize widthTitle      = _widthTitle;
@synthesize widthSum        = _widthSum;
@synthesize widthLastCol    = _widthLastCol;
@synthesize heightSum       = _heightSum;

#define FONTSIZE        15

//======================================================================
//
//======================================================================
+ (UIView*) makeGridTable
{
    UIView          *view   = [[UIView alloc]init];
    view.backgroundColor    = [UIColor whiteColor];
    
    GridTable       *title  = [[GridTable alloc]init];
    [title setFrame:CGRectMake(0, 0, 100, 100)];
    [view addSubview:title];
    
    UIScrollView    *scroll = [[UIScrollView alloc]init];
    GridTable       *data   = [[GridTable alloc]init];
    [data setFrame:CGRectMake(0, 0, 100, 100)];
    [scroll addSubview:data];
    scroll.bounces          = YES;
    
    [view addSubview:scroll];
    return view;
}
//======================================================================
//
//======================================================================
+ (void)setRectScroll:(UIView*)view rect:(CGRect)frame;
{

    GridTable *title        = [view.subviews objectAtIndex:0];
    UIScrollView *scroll    = [view.subviews objectAtIndex:1];
    GridTable *data         = [scroll.subviews objectAtIndex:0];
    /*--------------------------------------*/
    [view setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, title.heightSum)];
    /*--------------------------------------*/
    [title setFrame:CGRectMake(0, 0, title.widthSum+1, title.heightSum)];
    [title setNeedsDisplay];
    /*--------------------------------------*/
    scroll.contentSize = CGSizeMake(data.widthSum+(frame.size.width-title.widthSum-data.widthLastCol), data.heightSum);
    [scroll setFrame:CGRectMake(title.widthSum, 0, frame.size.width-title.widthSum, data.heightSum)];
    /*--------------------------------------*/
    [data setFrame:CGRectMake(0, 0, data.widthSum, data.heightSum)];
    [data setNeedsDisplay];
    /*--------------------------------------*/
    return;
    
}
//======================================================================
//
//======================================================================
+ (void)setScroll:(UIView*)view table:(NSArray*)allArr
{
    GridTable *title        = [view.subviews objectAtIndex:0];
    UIScrollView *scroll    = [view.subviews objectAtIndex:1];
    GridTable *data         = [scroll.subviews objectAtIndex:0];

    NSArray         *titleArr   = [NSArray arrayWithObjects:[allArr objectAtIndex:0], nil];
    NSMutableArray  *dataArr    = [allArr mutableCopy];
    [dataArr removeObjectAtIndex:0];
    title.table = titleArr;
    data.table  = dataArr;
    return;
}

//======================================================================
//
//======================================================================
-(void) setTable:(NSArray *)table
{
    _table = table;

    NSString *str;
    _widthSum   = 0;
    for(int i=0; i<[table count]; i++){
        NSArray *col = [table objectAtIndex:i];
        CGFloat widthMax = 0;
        for(int j=0; j<[col count]; j++){
            str = [col objectAtIndex:j];
            CGSize sizeTmp = [str sizeWithAttributes:[self tableFontBlack]];
            if ( widthMax < sizeTmp.width ){
                widthMax = sizeTmp.width;
            }
        }
        _widthLastCol   = widthMax +7;
        _widthSum       = _widthSum + widthMax +7;
        if ( i==0 ){
            _widthTitle = widthMax +7;
            _heightSum  = FONTSIZE*1.2 * [col count];
        }
    }
    return;
}

//======================================================================
//
//======================================================================
- (NSDictionary*)tableFontBlack
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIFont fontWithName:@"HelveticaNeue-Light" size:FONTSIZE],
            NSFontAttributeName,[UIColor blackColor],
            NSForegroundColorAttributeName,nil];
    
}
//======================================================================
//
//======================================================================
- (NSDictionary*)tableFontRed
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIFont fontWithName:@"HelveticaNeue-Light" size:FONTSIZE],
            NSFontAttributeName,[UIColor redColor],
            NSForegroundColorAttributeName,nil];
    
}

//======================================================================
//
//======================================================================
- (CGFloat) getWidhMax
{
    NSString *str;
    CGFloat widthMax = 0;
    for(int i=1; i<[_table count]; i++){
        NSArray *col = [_table objectAtIndex:i];
        for(int j=0; j<[col count]; j++){
            str = [col objectAtIndex:j];
            CGSize sizeTmp = [str sizeWithAttributes:[self tableFontBlack]];
            if ( widthMax < sizeTmp.width ){
                widthMax = sizeTmp.width;
            }
        }
    }
    return widthMax;
}
//======================================================================
//
//======================================================================
-(void)drawRect:(CGRect)rect
{
    // Drawing code
    [self setContext:UIGraphicsGetCurrentContext()];
    
    /*--------------------------------------*/
    /* 背景 */
    CGFloat mergin = 1;
    [self setColor_r:255 g:255 b:255];
    [self fillRect_x:mergin y:mergin w:self.frame.size.width-mergin*2 h:self.frame.size.height-mergin*2];
    
    /*--------------------------------------*/
    NSString *str;
    CGFloat rowWidth;
    CGFloat rowWidthSum = 0;
    CGFloat colHeight   = FONTSIZE*1.2;

    [self setLineWidth:1 ];
    for(int i=0;i<[_table count]; i++){
        /* 文字列幅を調べる */
        NSArray *col = [_table objectAtIndex:i];
        CGFloat widthMax = 0;
        for(int j=0; j<[col count]; j++){
            str = [col objectAtIndex:j];
            CGSize sizeTmp = [str sizeWithAttributes:[self tableFontBlack]];
            if ( widthMax < sizeTmp.width ){
                widthMax = sizeTmp.width;
            }
        }
        rowWidth    = widthMax +7;
        /* 文字列の描画 */
        for(int j=0; j<[col count]; j++){
            str = [col objectAtIndex:j];
            /* 左寄せのためのオフセット計算 */
            CGSize sizeTmp = [str sizeWithAttributes:[self tableFontBlack]];
            CGFloat offset = rowWidth - sizeTmp.width-2;
            /* 文字列の描画 */
            [self drawStr:str point:CGPointMake(0+rowWidthSum+offset, colHeight*j)];
            if ( i==0 ){
                /* 最初に横線の描画 */
                [self setColor_r:200 g:200 b:200 ];
                [self drawLine_x0:mergin    y0:mergin+colHeight*(j+1)  x1:self.frame.size.width-mergin*2    y1:mergin+colHeight*(j+1)];        //横グリッド
            }
        }
        rowWidthSum = rowWidthSum + rowWidth;
        /* 縦線描画 */
        [self setColor_r:200 g:200 b:200 ];
        [self drawLine_x0:mergin+rowWidthSum  y0:mergin   x1:mergin+rowWidthSum   y1:self.frame.size.height-mergin*2]; //縦グリッド
    }


#if 0
    for(int i=0;i<[_table count]; i++){
        NSArray *row = [_table objectAtIndex:i];
        for(int j=0; j<[row count]; j++){
            str = [row objectAtIndex:j];
            [str drawAtPoint:CGPointMake(0+j*rowWidth, colHeight*i) withAttributes:[self graphFont]];
            if ( i==0 ){
                [self setColor_r:200 g:200 b:200 ];
                [self setLineWidth:1 ];
                [self drawLine_x0:mergin+(j+1)*rowWidth  y0:mergin   x1:mergin+(j+1)*rowWidth   y1:self.frame.size.height-mergin*2]; //縦グリッド
            }
        }
        [self setColor_r:200 g:200 b:200 ];
        [self setLineWidth:1 ];
        [self drawLine_x0:mergin    y0:mergin+colHeight*(i+1)  x1:self.frame.size.width-mergin*2    y1:mergin+colHeight*(i+1)];        //横グリッド
    }
#endif
}
//======================================================================
//
//======================================================================
-(void)drawStr:(NSString*)str point:(CGPoint)point
{
    if ( [str hasPrefix:@"-"] == true ){
        [str drawAtPoint:point withAttributes:[self tableFontRed]];
    } else {
        [str drawAtPoint:point withAttributes:[self tableFontBlack]];
    }
}

//======================================================================
@end
//======================================================================
