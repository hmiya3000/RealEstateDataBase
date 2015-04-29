//
//  Estate.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "Prices.h"
#import "House.h"
#import "Land.h"

/****************************************************************/
@interface Estate : NSObject
{
    Prices      *_prices;
    House       *_house;
    Land        *_land;
    NSString    *_name;
}
/****************************************************************/
- (void)setLandPrice:(NSInteger)price;
- (void)setHousePrice:(NSInteger)price;
- (void) adjustHousePrice;
/****************************************************************/
@property   (nonatomic)   Prices        *prices;
@property   (nonatomic)   House         *house;
@property   (nonatomic)   Land          *land;
@property   (nonatomic)   NSString      *name;
/****************************************************************/
@end
/****************************************************************/
