//
//  Sale.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/17.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "Sale.h"
#import "UIUtil.h"
@implementation Sale
//======================================================================
@synthesize price               = _price;
@synthesize expense             = _expense;
@synthesize loanBorrow          = _loanBorrow;
@synthesize btcf                = _btcf;
@synthesize amCosts             = _amCosts;
@synthesize transferIncome      = _transferIncome;
@synthesize transferTax         = _transferTax;
@synthesize atcf                = _atcf;
@synthesize sellYear            = _sellYear;
//======================================================================
-(void) calcSale:(Investment*)investment holdingPeriod:(NSInteger)holdingPeriodYear estate:(Estate*)estate
{
    /*--------------------------------------*/
    _loanBorrow         = [investment.loan getLbYear:holdingPeriodYear];
    _btcf               = _price - _expense - _loanBorrow;
    _sellYear           = [UIUtil getYear_term:estate.house.acquisitionTerm+holdingPeriodYear*12 ];
    /*--------------------------------------*/
    //減価償却費の集計
    _amCosts = [estate.house getAmortizationCostsSum_period:holdingPeriodYear*12];

    //取得価格
    NSInteger priceAquisition;
    priceAquisition        = investment.price + investment.expense + estate.house.improvementCosts - _amCosts;

    //譲渡所得の算出
    _transferIncome         = _price - priceAquisition -_expense;
    
    //売却時の譲渡税の算出
    NSInteger incomeTax;
    NSInteger regidentTax;
    NSInteger incomeTaxSp;
    if ( _transferIncome > 0 ){
        if ( holdingPeriodYear > 5 ){
            //5年以上保有の場合の譲渡税(個人)
            incomeTax       = _transferIncome * 0.15;
            regidentTax     = _transferIncome * 0.05;
            incomeTaxSp     = incomeTax * 0.021;
        } else {
            //5年未満保有の場合の譲渡税(個人)
            incomeTax       = _transferIncome * 0.30;
            regidentTax     = _transferIncome * 0.09;
            incomeTaxSp     = incomeTax * 0.021;
        }
    } else {
        incomeTax           = 0;
        regidentTax         = 0;
        incomeTaxSp         = 0;
    }
    _transferTax    = incomeTax + regidentTax + incomeTaxSp;
    _atcf           = _btcf  - _transferTax;
    
}

//======================================================================
@end
//======================================================================
