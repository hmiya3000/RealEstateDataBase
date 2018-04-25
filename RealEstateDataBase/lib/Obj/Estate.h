//
//  Estate.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "House.h"
#import "Land.h"

//======================================================================
@interface Estate : NSObject
{
    House           *_house;
    Land            *_land;
    NSString        *_name;
    bool            _isBrokerageFee;
}
//======================================================================
//-(void)setLandPrice:(NSInteger)price;
//-(void)setHousePrice:(NSInteger)price;
-(void) adjustHousePrice;
-(void)calcBookPrice;
- (NSInteger)getPropTax_term:(NSInteger)term;
- (NSInteger)getAcquTax;
//======================================================================
@property   (nonatomic)   House         *house;
@property   (nonatomic)   Land          *land;
@property   (nonatomic)   NSString      *name;
@property   (nonatomic)   bool          isBrokerageFee;
//======================================================================
@end
//======================================================================
