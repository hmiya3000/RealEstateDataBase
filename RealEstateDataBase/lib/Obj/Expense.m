//
//  Expense.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/23.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Expense.h"

@implementation Expense
{
    NSInteger       _price;
    NSInteger       _loanBorrow;
    NSInteger       _acquTax;
}
//======================================================================
@synthesize brokenCom       = _brokerCom;
@synthesize stamp           = _stamp;
@synthesize fireInsurance   = _fireInsurance;
@synthesize mortgageReg     = _mortgageReg;
@synthesize ownershipReg    = _ownershipReg;
@synthesize scrivener       = _scrivener;
@synthesize acquisitionTax  = _acquisitionTax;
@synthesize sum             = _sum;
//======================================================================
//======================================================================
//
//======================================================================
- (id)initWithPrice:(NSInteger)price loanBorrow:(NSInteger)loanBorrow acquTax:(NSInteger)acquTax
{
    self = [super init];
    if ( self != nil){
        _price          = price;
        _loanBorrow     = loanBorrow;
        _acquisitionTax = acquTax;
        [self calcAll];
    }
    return self;
}
//======================================================================
//
//======================================================================
-(void) calcAll
{
    CGFloat tax = 1.08;
    /****************************************/
    NSInteger   priceNoTax = _price / tax;
    if ( priceNoTax <= 200*10000){
        _brokerCom  = priceNoTax * 0.05*tax;
    } else if ( priceNoTax <= 400*10000){
        _brokerCom  = 200*10000*0.05*tax + (priceNoTax-200*10000)*0.04*tax;
    } else {
        _brokerCom  = 200*10000*0.05*tax + 200*10000*0.04*tax + (priceNoTax-400*10000)*0.03*tax;
    }

    /****************************************/
    _stamp = [self stampPrice:_price];
    
    /****************************************/
    //火災保険料
    _fireInsurance  = 30 *10000;

    /****************************************/
    //抵当権設定登記費用
    _mortgageReg    = _loanBorrow * 0.004;
    
    /****************************************/
    //所有権移転登記
    // https://www.nta.go.jp/taxanswer/inshi/7191.htm
    _ownershipReg   = 10*10000;
    
    /****************************************/
    // 司法書士報酬
    _scrivener      = 10*10000;
    
    /****************************************/

    /****************************************/
    _sum = _brokerCom + _stamp*2 + _fireInsurance + _mortgageReg + _ownershipReg + _scrivener + _acquisitionTax;
}

//======================================================================
//
//======================================================================
- (NSInteger) stampPrice:(NSInteger)price
{
    NSInteger stamp;
    
    if ( price < 1*10000){
        stamp      = 0;
    } else if ( price <= 10*10000){
        stamp      = 200;
    } else if ( price <= 50*10000){
        stamp      = 400;
    } else if ( price <= 100*10000){
        stamp      = 1000;
    } else if ( price <= 500*10000){
        stamp      = 2000;
    } else if ( price <= 1000*10000){
        stamp      = 10000;
    } else if ( price <= 5000*10000){
        stamp      = 15000;
    } else if ( price <= 10000*10000){
        stamp      = 45000;
    } else if ( price <= 50000*10000){
        stamp      = 80000;
    } else if ( price <= 100000*10000){
        stamp      = 18*10000;
    } else if ( price <= (long long)500000*10000){
        stamp      = 36*10000;
    } else {
        stamp      = 50*10000;
    }
    return stamp;

}
//======================================================================
@end
//======================================================================
