//
//  Investment.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Investment.h"

@implementation Investment
{
}
/****************************************************************/
@synthesize prices              = _prices;
@synthesize loan                = _loan;
@synthesize emptyRate           = _emptyRate;
@synthesize mngRate             = _mngRate;
@synthesize propTaxRate         = _propTaxRate;
@synthesize incomeTaxRate       = _incomeTaxRate;
@synthesize expense             = _expense;
@synthesize equity              = _equity;

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        _loan           = [[Loan alloc]init];
        _prices         = [[Prices alloc]init];
        _equity         = 0;
    }
    return self;
    
}
/****************************************************************
 *
 ****************************************************************/
- (id)copyWithZone:(NSZone*)zone
{
    // 複製を保存するためのインスタンスを生成します。
    Investment* result = [[[self class] allocWithZone:zone] init];
    
    if (result){
        result.prices   = _prices;
        result.loan     = _loan;
    }
    
    return result;
}/****************************************************************
 *
 ****************************************************************/
-(void)setPrices:(Prices *)prices
{
    _prices = prices;
    [self calcAll];
}

/****************************************************************
 *
 ****************************************************************/
- (Operation*) calcAll
{
    return [self getOperation:1 gpi:_prices.gpi loan:_loan amortizationCosts:0];
    /*--------------------------------------*/
}

/****************************************************************
 *
 ****************************************************************/
- (void) adjustEquity
{
    _equity = _prices.price + _expense - _loan.loanBorrow;
}
/****************************************************************
 *
 ****************************************************************/
- (void) adjustLoanBorrow
{
    _loan.loanBorrow = _prices.price + _expense - _equity;
}
/****************************************************************
 *
 ****************************************************************/
- (Operation*) getOperation:(NSInteger)year gpi:(NSInteger)gpi loan:(Loan*)loan amortizationCosts:(NSInteger)amortizationCosts
{
    Operation *ope = [[Operation alloc]init];
    
    ope.gpi         = gpi;
    ope.emptyLoss   = gpi * _emptyRate;
    ope.egi         = gpi - ope.emptyLoss;
    NSInteger   propTax = _prices.price*0.25*_propTaxRate;
    ope.opex        = ope.egi  * _mngRate + propTax;
    ope.noi         = ope.egi - ope.opex;
    ope.ads         = [loan getPmtYear:year];
    ope.btcf        = ope.noi - ope.ads;
    
    /*--------------------------------------*/
    NSInteger taxIncome = ope.noi - [_loan getIpmtYear:year] - amortizationCosts;
    if ( taxIncome > 0){
        ope.tax    = taxIncome * _incomeTaxRate;
    } else {
        ope.tax    = 0;
    }
    ope.atcf   = ope.btcf - ope.tax;
    
    if ( _prices.price == 0 ){
        /* 未設定の場合には計算しない */
        ope.fcr            = 0;
        ope.loanConst      = 0;
        ope.ccr            = 0;
        ope.pb             = 0;
        ope.dcr            = 0;
        ope.ber            = 0;
        ope.ltv            = 0;
        ope.capRate        = 0;
    } else {
        ope.fcr        = (CGFloat)ope.noi / ( _prices.price + _expense);
        if ( _loan.loanBorrow != 0 ){
            ope.loanConst  = (CGFloat)ope.ads / _loan.loanBorrow;
        } else {
            ope.loanConst  = 0;
        }
        if ( _equity != 0 ){
            ope.ccr        = (CGFloat)ope.btcf / _equity;
        } else {
            ope.ccr        = 0;
        }
        if ( ope.btcf != 0 ){
            ope.pb         = (CGFloat)_equity / ope.btcf;
        } else {
            ope.pb         = 0;
        }
        if ( ope.ads != 0 ){
            ope.dcr        = (CGFloat)ope.noi / ope.ads;
        } else {
            ope.dcr        = 0;
        }
        if ( gpi != 0 ){
            ope.ber        = (CGFloat)(ope.opex + ope.ads ) / gpi;
        } else {
            ope.ber        = 0;
        }
        ope.ltv        = (CGFloat)loan.loanBorrow / _prices.price;
        ope.capRate    = (CGFloat)ope.noi / _prices.price;
    }
    
    
    return ope;
}

/****************************************************************/
@end
/****************************************************************/
