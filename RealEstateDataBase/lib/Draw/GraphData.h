//
//  GraphData.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/04/25.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Graph.h"

//======================================================================
@interface GraphData : NSObject
{
    NSArray*        _data;
    UIColor*        _color;
    NSString*       _precedent;
    NSNumber*       _type;
    CGFloat         _xmin;
    CGFloat         _xmax;
    CGFloat         _ymin;
    CGFloat         _ymax;
}
//======================================================================
- (id)initWithData:(NSArray*)data;
//======================================================================
@property   (nonatomic,readwrite)   NSArray*        data;
@property   (nonatomic,readwrite)   UIColor*        color;
@property   (nonatomic,readwrite)   NSString*       precedent;
@property   (nonatomic,readwrite)   NSNumber*       type;
@property   (nonatomic,readonly)    CGFloat         xmin;
@property   (nonatomic,readonly)    CGFloat         xmax;
@property   (nonatomic,readonly)    CGFloat         ymin;
@property   (nonatomic,readonly)    CGFloat         ymax;

//======================================================================
@end
//======================================================================
