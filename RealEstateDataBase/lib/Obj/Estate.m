//
//  Estate.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Estate.h"

@implementation Estate
/****************************************************************/
/****************************************************************/
@synthesize prices  = _prices;
@synthesize house   = _house;
@synthesize land    = _land;
@synthesize name    = _name;
/****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        _prices = [[Prices alloc]init];
        _house  = [[House alloc]init];
        _land   = [[Land alloc]init];
    }
    return self;
   
}
/****************************************************************
 *
 ****************************************************************/
- (id)copyWithZone:(NSZone*)zone
{
    // 複製を保存するためのインスタンスを生成します。
    Estate* result = [[[self class] allocWithZone:zone] init];
    
    if (result){
        result.prices   = _prices;
        result.house    = _house;
        result.land     = _land;
    }
    
    return result;
}
/****************************************************************/
- (void)setPrices:(Prices *)prices
{
    _prices.price       = prices.price;
    _prices.gpi         = prices.gpi;
    [self setLandPrice:_land.price];
    return;
}
/****************************************************************/
- (void)setLandPrice:(NSInteger)price
{
    _land.price     = price;
    _house.price    = _prices.price - _land.price;
}
/****************************************************************/
- (void)setHousePrice:(NSInteger)price
{
    _house.price    = price;
    _land.price     = _prices.price - _house.price;
}
/****************************************************************
 *
 ****************************************************************/
- (void) adjustHousePrice
{
    _house.price = _prices.price - _land.price;
    return;
}
/****************************************************************/
@end
/****************************************************************/
