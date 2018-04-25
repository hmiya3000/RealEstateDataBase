//
//  Estate.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Estate.h"
#import "Expense.h"

@implementation Estate
/****************************************************************/
/****************************************************************/
@synthesize house           = _house;
@synthesize land            = _land;
@synthesize name            = _name;
@synthesize isBrokerageFee  = _isBrokerageFee;
/****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
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
        result.house    = _house;
        result.land     = _land;
    }
    
    return result;
}
/****************************************************************/
- (void)setLandPrice:(NSInteger)price
{
    NSInteger price_all = _land.price + _house.price;
    _land.price     = price;
    _house.price    = price_all - _land.price;
    [self calcBookPrice];
}
/****************************************************************/
- (void)setHousePrice:(NSInteger)price
{
    NSInteger price_all = _land.price + _house.price;
    _house.price    = price;
    _land.price     = price_all - _house.price;
    [self calcBookPrice];
}
//================================================================
- (void)setIsBrokerageFee:(bool)isBrokerageFee
{
    _isBrokerageFee = isBrokerageFee;
    [self calcBookPrice];
    
}
//================================================================
//
//================================================================
- (void)calcBookPrice
{
    if (_isBrokerageFee == true && (_land.price + _house.price) > 0 ){
        CGFloat tax = 1.08;
        /****************************************/
        NSInteger   brokerCom;
        NSInteger   priceNoTax = _land.price + (_house.price / tax );
        if ( priceNoTax <= 200*10000){
            brokerCom  = priceNoTax * 0.05*tax;
        } else if ( priceNoTax <= 400*10000){
            brokerCom  =  (priceNoTax * 0.04 + 20000) *tax;
        } else {
            brokerCom  =  (priceNoTax * 0.03 + 60000) *tax;
        }
        NSInteger landPriceAdd = brokerCom * _land.price / (_land.price + _house.price);
        NSInteger housePriceAdd = brokerCom - landPriceAdd;
        _land.priceBook  = _land.price + landPriceAdd;
        _house.priceBook = _house.price + housePriceAdd;
    } else {
        _land.priceBook  = _land.price;
        _house.priceBook = _house.price;
    }
}

/****************************************************************
 *
 ****************************************************************/
- (void) adjustHousePrice
{
    NSInteger price_all = _land.price + _house.price;
    _house.price = price_all - _land.price;
    return;
}
//================================================================
//  固定資産税・都市計画税
//================================================================
- (NSInteger)getPropTax_term:(NSInteger)term
{
    return [_land getPropTax_houseArea:_house.area houseRooms:_house.rooms ] + [_house getPropTax_term:term];
}
//================================================================
//  不動産取得税
//================================================================
- (NSInteger)getAcquTax
{
    return [_house getAcquTax] + [_land getAcquTax_acquTerm:_house.acquisitionTerm];
}
//================================================================
//  建物価格、仲介手数料分の加算分
//================================================================
- (NSInteger) getAddPriceLand
{
    Expense *expense = [[Expense alloc]initWithPrice:(_land.price + _house.price) loanBorrow:0 acquTax:0];
    return expense.brokenCom * _house.price / ( _land.price + _house.price);
}
/****************************************************************/
@end
/****************************************************************/
