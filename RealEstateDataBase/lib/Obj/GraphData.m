//
//  GraphData.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/04/25.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "GraphData.h"

@implementation GraphData
/****************************************************************/
@synthesize data        = _data;
@synthesize color       = _color;
@synthesize precedent   = _precedent;
@synthesize type        = _type;
@synthesize xmin        = _xmin;
@synthesize xmax        = _xmax;
@synthesize ymin        = _ymin;
@synthesize ymax        = _ymax;
/****************************************************************
 *
 ****************************************************************/
- (id)initWithData:(NSArray*)data
{
    self = [super init];
    if ( self != nil){
        _data       = data;
        _color      = [UIColor blackColor];
        _precedent  = @"graph";
        _type       = LINE_GRAPH;
        [self calcMinMax];
    }
    return self;
}
/****************************************************************
 * データの最大値・最小値を計算
 ****************************************************************/
- (void) calcMinMax
{
    CGFloat xmin = CGFLOAT_MAX;
    CGFloat xmax = CGFLOAT_MIN;
    CGFloat ymin = CGFLOAT_MAX;
    CGFloat ymax = CGFLOAT_MIN;
    NSValue *tmp = [[NSValue alloc]init];
    CGPoint tmpPoint;
    for( int i=0; i< [_data count]; i++ ){
        tmp = [_data objectAtIndex:i];
        tmpPoint = [tmp CGPointValue];
        if ( xmin > tmpPoint.x ){
            xmin = tmpPoint.x;
        }
        if ( ymin > tmpPoint.y ){
            ymin = tmpPoint.y;
        }
        if ( xmax < tmpPoint.x ){
            xmax = tmpPoint.x;
        }
        if ( ymax > tmpPoint.y ){
            ymax = tmpPoint.y;
        }
    }
    _xmin = xmin;
    _xmax = xmax;
    _ymin = ymin;
    _ymax = ymax;
    
    return;
}


/****************************************************************/
@end
/****************************************************************/
