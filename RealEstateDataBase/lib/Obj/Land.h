//
//  Land.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
//======================================================================
@interface Land : NSObject
{
    NSInteger   _price;
    NSInteger   _priceBook;
    CGFloat     _area;
    NSString    *_address;
    CGFloat     _assessment;
    NSInteger   _assessValue;
    NSInteger   _marketValue;
    NSInteger   _propValue;
    double      _latitude;
    double      _longitude;
}

//======================================================================
-(NSInteger)getAcquTax_acquTerm:(NSInteger)acquTerm;
-(NSInteger)getPropTax_houseArea:(CGFloat)houseArea houseRooms:(NSInteger)houseRooms;
//======================================================================
@property   (nonatomic,readwrite) NSInteger   price;
@property   (nonatomic,readwrite) NSInteger   priceBook;
@property   (nonatomic,readwrite) CGFloat     area;
@property   (nonatomic,readwrite) NSString    *address;
@property   (nonatomic,readwrite) CGFloat     assessment;
@property   (nonatomic,readonly)  NSInteger   assessValue;
@property   (nonatomic,readonly)  NSInteger   marketValue;
@property   (nonatomic,readonly)  NSInteger   propValue;
@property   (nonatomic,readwrite) double      latitude;
@property   (nonatomic,readwrite) double      longitude;
//======================================================================
@end
//======================================================================
