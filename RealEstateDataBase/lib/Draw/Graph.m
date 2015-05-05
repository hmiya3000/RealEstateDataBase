//
//  Graph.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/15.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Graph.h"
#import "UIUtil.h"
#import "GraphData.h"

@implementation Graph
{
    CGFloat     _xmin;
    CGFloat     _xmax;
    CGFloat     _ymin;
    CGFloat     _ymax;
    CGRect      _GraphArea;     // Graphの描画エリア
    CGRect      _GradArea;      // 目盛り含むエリア
    CGRect      _ValidArea;     // 有効エリア
    NSArray     *_xscales;
    NSArray     *_yscales;
    
}
@synthesize title           = _title;
@synthesize GraphDataAll    = _GraphDataAll;
/****************************************************************
 * XY座標系でグラフ領域の設定をする
 ****************************************************************/
-(void)setGraphtMinMax_xmin:(CGFloat)xmin ymin:(CGFloat)ymin xmax:(CGFloat)xmax ymax:(CGFloat)ymax
{
    _xscales    = [self calcScale_min:xmin max:xmax];
    _yscales    = [self calcScale_min:ymin max:ymax];
    _xmin       = xmin;
    _ymin       = ymin;
    _xmax       = xmax;
    _ymax        = [[_yscales objectAtIndex:[_yscales count]-1] intValue];

}

/****************************************************************
 *
 ****************************************************************/
-(NSArray*)calcScale_min:(CGFloat)min max:(CGFloat)max
{
//    NSLog(@"min:%f,max:%f",min,max);
    
    float diff;

    //diff:グラフの表示幅を計算
    diff = max - min;
    //divnum:桁を算出(ex. diff=120 -> divnum=100)
    int divnum=1;
    while (1) {
        if ( diff / divnum < 10 ){
            break;
        }
        divnum = divnum *10;
    }

    float scale;
//    NSLog(@"divnum %d",divnum);

    int num = (int)(diff/divnum);       //目盛りの個数
//    NSLog(@"num %d",num);
    if ( num <= 2 ){
        /* 5単位ごとに目盛り 1-2 -> 2-4 */
        scale = divnum/2;
    } else if ( num <= 6 ){
        /* 1単位ごとに目盛り 3-6 -> 3-6 */
        scale = divnum;
    } else {
        /* 2単位ごとに目盛り 7-9 -> 3-5 */
        scale = divnum*2;
    }
    
    
//    NSLog(@"scale %g",scale);


    int tmp;
    tmp = (int)(min/scale)*scale;
    
//    NSLog(@"tmp:%d",tmp);

    NSMutableArray *arr = [[NSMutableArray alloc]init];
    while( 1 ){
        [arr addObject:[NSNumber numberWithFloat:tmp]];
        if( tmp >= max ){
            break;
        }
        tmp = tmp + scale;
    }
    return    arr;
}


/****************************************************************
 * XY座標系のp0,p1を指定して線を引く
 ****************************************************************/
-(void)drawLine_p0:(CGPoint)p0 p1:(CGPoint)p1
{
    CGPoint p0_tmp;
    CGPoint p1_tmp;
    
    p0_tmp = [self xy2GArea:p0];
    p1_tmp = [self xy2GArea:p1];
    
    [self drawLine_x0:p0_tmp.x y0:p0_tmp.y x1:p1_tmp.x y1:p1_tmp.y];
}
/****************************************************************
 * XY座標系のp00=(x0,y0)とp11=(x1,y1)を指定して矩形を描画する
 ****************************************************************/
-(void)fillRect_p00:(CGPoint)p00 p11:(CGPoint)p11
{
    CGFloat x;
    CGFloat y;
    CGFloat w;
    CGFloat h;
    
    CGPoint p00_tmp = [self xy2GArea:p00];
    CGPoint p11_tmp = [self xy2GArea:p11];
    
    
    x = p00_tmp.x;
    y = p11_tmp.y;
    w = p11_tmp.x - p00_tmp.x;
    h = p00_tmp.y - p11_tmp.y;
    
    [self fillRect_x:x y:y w:w h:h];
    return;
}

/****************************************************************
 * XY座標系の位置をグラフ座標系の位置に変換
 ****************************************************************/
-(CGPoint)xy2GArea:(CGPoint)point
{
    CGPoint GArea;
    
    /* X座標 */
    if ( point.x < _xmin ){
        GArea.x = _GraphArea.origin.x;
    } else if ( point.x > _xmax){
        GArea.x = _GraphArea.origin.x + _GraphArea.size.width;
    } else {
        if ( _xmax == _xmin ){
            GArea.x = 0;
        } else {
            GArea.x =  ( point.x - _xmin) / ( _xmax - _xmin ) * _GraphArea.size.width  + _GraphArea.origin.x;
        }
    }
    /* Y座標 */
    if ( point.y < _ymin ){
        GArea.y = _GraphArea.origin.y + _GraphArea.size.height;
    } else if ( point.y > _ymax ){
        GArea.y = _GraphArea.origin.y;
    } else {
        if ( _ymax == _ymin ){
            GArea.y = 0;
        } else {
            GArea.y =  ( _ymax - point.y ) / ( _ymax - _ymin ) * _GraphArea.size.height + _GraphArea.origin.y;
        }
    }
//    NSLog(@"%f,%f",point.x, point.y);
    return GArea;
}
/****************************************************************
 * Indexに従った色指定をする
 ****************************************************************/
-(void)setColor_index:(NSInteger)idx
{
#define COLOR_IDX_MAX 4
    
    idx = idx % COLOR_IDX_MAX;
    float listRGB[COLOR_IDX_MAX][3] = {
        /* R    G       B   */
        {191,   30,     51},
        {0,     103,    192 },
        {47,    181,    106 },
        {162,   96,     191 }
    };
    [self setColor_r:listRGB[idx][0]
                   g:listRGB[idx][1]
                   b:listRGB[idx][2]];
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (NSDictionary*)graphFont
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIFont fontWithName:@"HelveticaNeue-Light" size:10],
            NSFontAttributeName,[UIColor blackColor],
            NSForegroundColorAttributeName,nil];
    
}

/****************************************************************
 *
 ****************************************************************/
- (NSDictionary*)titleFont
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [UIFont fontWithName:@"HelveticaNeue-Light" size:12],
            NSFontAttributeName,[UIColor blackColor],
            NSForegroundColorAttributeName,nil];
}
/****************************************************************
 *
 ****************************************************************/
- (void)drawPrecedent:(CGRect)rect
{
    GraphData   *tmpGD;
    NSString    *str;
    CGSize      strSize;
    CGFloat     preAreaLen;

    preAreaLen = 0;
    if ( [_GraphDataAll count ] > 0 ){
        for(int i=0; i < [_GraphDataAll count]; i++){
            tmpGD = [_GraphDataAll objectAtIndex:i];
            str = tmpGD.precedent;
            if ( str != nil ){
                strSize = [str sizeWithAttributes:[self graphFont]];
                preAreaLen = preAreaLen + strSize.width + 20;
            }
        }
        /*---------------------------*/
        CGFloat preHeight = strSize.height *1.1;
        CGFloat pos_x = rect.origin.x + ( rect.size.width - preAreaLen)/2;
        CGFloat pos_y = rect.origin.y + rect.size.height - preHeight;
        
        [self setColor_r:255 g:255 b:255];
        [self fillRect_x:pos_x y:pos_y w:preAreaLen h:preHeight];
        [self setLineWidth:1 ];
        for(int i=0; i < [_GraphDataAll count]; i++){
            tmpGD = [_GraphDataAll objectAtIndex:i];
            str = tmpGD.precedent;
            if ( str != nil ){
                strSize = [str sizeWithAttributes:[self graphFont]];
                [self setColor_index:i ];
                [self drawLine_x0:pos_x+1 y0:pos_y+strSize.height/2 x1:pos_x+16 y1:pos_y+strSize.height/2];
                pos_x = pos_x + 18;
                [str drawAtPoint:CGPointMake(pos_x, pos_y) withAttributes:[self graphFont]];
                pos_x = pos_x + strSize.width +2;
            }
        }
    }
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (void)drawPrecedent2:(CGRect)rect
{    
    NSString *str;
    [self setColor_r:255 g:255 b:255];
    float x_precedent,y_precedent,w_precedent,h_precedent;
    w_precedent = rect.size.width * 1 / 3.5;
    h_precedent = [_GraphDataAll count] * 13;

    x_precedent = rect.origin.x + rect.size.width   - w_precedent -5;
    y_precedent = rect.origin.y + rect.size.height  - h_precedent -5;
    [self fillRect_x:x_precedent y:y_precedent w:w_precedent h:h_precedent];
    
    float x2_precedent = x_precedent + w_precedent /4;
    float dy;
    
    [self setLineWidth:1 ];
    /*--------------------------------------*/
    GraphData *tmpGD;
    if ( [_GraphDataAll count ] > 0 ){
        for(int i=0; i < [_GraphDataAll count]; i++){
            dy = i*12;
            tmpGD = [_GraphDataAll objectAtIndex:i];
            str = tmpGD.precedent;
            [str drawAtPoint:CGPointMake(x2_precedent+5, y_precedent+dy) withAttributes:[self graphFont]];
            [self setColor_index:i ];
            [self drawLine_x0:x_precedent+5 y0:y_precedent+dy+6 x1:x2_precedent y1:y_precedent+dy+6];
        }
    }
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)drawRect:(CGRect)rect
{
    if ( _GraphDataAll == nil ){
        return;
    }
    

    CGSize titleSize;
    if ( _title != nil ){
        titleSize = [_title sizeWithAttributes:[self titleFont]];
    } else {
        titleSize = CGSizeMake(0, 0);
    }
    // Drawing code
    [self setContext:UIGraphicsGetCurrentContext()];
    
    /*--------------------------------------*/
    /* 背景 */
    CGFloat mergin = 1;
    _ValidArea = [UIUtil mergin_rect:rect top:mergin bottom:mergin left:mergin right:mergin];

    CGFloat grad_mergin = 14;
    _GradArea   = [UIUtil mergin_rect:_ValidArea top:titleSize.height bottom:grad_mergin left:0 right:0];

    CGFloat ga_mergin = 5;
    _GraphArea  = [UIUtil mergin_rect:_GradArea top:ga_mergin bottom:12 left:ga_mergin right:ga_mergin];
    
    [self setColor_r:240 g:240 b:240];
    [self fillRect_x:_ValidArea.origin.x    y:_ValidArea.origin.y
                   w:_ValidArea.size.width  h:_ValidArea.size.height ];
    
    /*--------------------------------------*/
    /* 背景目盛り */
    float ys_tmp0,ys_tmp1;
    for(int i=0;i< [_yscales count] -1;i++){
        if ( i %2 == 0 ){
            [self setColor_r:220 g:220 b:220];
        }else {
            [self setColor_r:230 g:230 b:230];
        }
        ys_tmp0 = [[_yscales objectAtIndex:i] floatValue];
        ys_tmp1 = [[_yscales objectAtIndex:i+1] floatValue];
        [self fillRect_p00:CGPointMake(_xmin, ys_tmp0) p11:CGPointMake(_xmax, ys_tmp1)];
    }

    /*--------------------------------------*/
    /* グラフデータの描画 */
    [self paintGraph];
    
    
    /*--------------------------------------*/
    /* X軸目盛り */
    NSString *str;
    CGPoint  tmpP;
    float xs_tmp;
    for( int i=1; i<[_xscales count]-1 ;i++){
        xs_tmp = [[_xscales objectAtIndex:i] floatValue];
        str = [[NSString alloc]initWithFormat:@"%d",(int)xs_tmp];
        tmpP = [self xy2GArea:CGPointMake(xs_tmp+0.3,0)];
        tmpP.x = tmpP.x - 2*ga_mergin;
        tmpP.y = _GradArea.origin.y + _GradArea.size.height - 12;
        [str drawAtPoint:tmpP withAttributes:[self graphFont]];
    }
    /*--------------------------------------*/
    /* Y軸目盛り */
    for(int i=0;i< [_yscales count];i++){
        ys_tmp1 = [[_yscales objectAtIndex:i] floatValue];
        if ( ys_tmp1 != 0 ){
            /* X軸以外は目盛り表示する */
            str = [[NSString alloc]initWithString:[UIUtil yenValue:ys_tmp1]];
            tmpP = [self xy2GArea:CGPointMake(0,ys_tmp1)];
            tmpP.x = ga_mergin + ga_mergin;
            [str drawAtPoint:tmpP withAttributes:[self graphFont]];
        }
    }

    /*--------------------------------------*/
    /* XY軸 */
    [self setColor_r:0 g:0 b:0 ];
    [self setLineWidth:1 ];
    [self drawLine_p0:CGPointMake(_xmin, 0) p1:CGPointMake(_xmax, 0)];     /* X軸 */
    [self drawLine_p0:CGPointMake(0, _ymin) p1:CGPointMake(0, _ymax)];     /* Y軸 */

    /*--------------------------------------*/
    /* グラフタイトル */
    if ( _title != nil ){
        [_title drawAtPoint:CGPointMake(_ValidArea.origin.x + (_ValidArea.size.width - titleSize.width)/2,
                                        _ValidArea.origin.y) withAttributes:[self titleFont]];
    }
    
    /*--------------------------------------*/
    /* 凡例 */
    [self drawPrecedent:_ValidArea];
//    [self drawPrecedent2:_GraphArea];
    
    return;
}
/****************************************************************
 * グラフ描画
 ****************************************************************/
-(void)paintGraph
{
    GraphData *tmpGD;
    if ( [_GraphDataAll count ] > 0 ){
        for(int i=0; i < [_GraphDataAll count]; i++){
            /* グラフ種別を読み取り */
            tmpGD = [_GraphDataAll objectAtIndex:i];
            NSNumber *prop;
            prop = tmpGD.type;
            /* グラフの描画 */
            NSArray *graphData = tmpGD.data;
            if ( prop == (NSNumber*)LINE_GRAPH ){
                [self lineGraph:graphData no:i];
            } else {
                [self barGraph:graphData no:i];
            }
        }
    }
    return;
}
/****************************************************************
 * 折れ線グラフ
 ****************************************************************/
-(void)lineGraph:(NSArray*)graphData no:(NSInteger)i
{
    NSValue *tmp = [[NSValue alloc]init];
    if ( [graphData count] > 0 ){
        tmp = [graphData objectAtIndex:0];
        CGPoint prevPoint = [tmp CGPointValue];
        CGPoint nextPoint;
        [self setColor_index:i];
        for(int j=1; j< [graphData count];j++){
            tmp = [graphData objectAtIndex:j];
            nextPoint = [tmp CGPointValue];
            [self drawLine_p0:prevPoint p1:nextPoint];
            prevPoint = nextPoint;
        }
    }
    return;
}

/****************************************************************
 * 棒グラフ
 ****************************************************************/
-(void)barGraph:(NSArray*)graphData no:(NSInteger)i
{
    NSValue *tmp = [[NSValue alloc]init];
    if ( [graphData count] > 0 ){
        [self setColor_index:i];
        CGPoint tgtPoint;
        CGPoint p00;
        CGPoint p11;
        for(int j=0; j< [graphData count];j++){
            tmp = [graphData objectAtIndex:j];
            tgtPoint = [tmp CGPointValue];
            p00 = [self getP00:tgtPoint width:0.3];
            p11 = [self getP11:tgtPoint width:0.3];
            [self fillRect_p00:p00 p11:p11];
        }
    }
    return;
}
/****************************************************************
 *
 ****************************************************************/
-(CGPoint) getP00:(CGPoint)tgtPoint width:(CGFloat)width
{
    CGPoint p00;
    p00.x = tgtPoint.x - width /2;
    if ( tgtPoint.y >= 0 ){
        p00.y = 0;
    } else {
        p00.y = tgtPoint.y;
    }
    return p00;
}
/****************************************************************
 *
 ****************************************************************/
-(CGPoint) getP11:(CGPoint)tgtPoint width:(CGFloat)width
{
    CGPoint p11;
    p11.x = tgtPoint.x + width /2;
    if ( tgtPoint.y >= 0 ){
        p11.y = tgtPoint.y;
    } else {
        p11.y = 0;
    }
    return p11;
}



@end
