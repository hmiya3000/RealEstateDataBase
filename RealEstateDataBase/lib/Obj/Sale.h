//
//  Sale.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/17.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Investment.h"
#import "House.h"

/****************************************************************/
@interface Sale : NSObject
{
    /*--------------------------------------*/
    NSInteger               _price;             //売却価格
    NSInteger               _expense;           //譲渡費用
    NSInteger               _loanBorrow;        //残債
    NSInteger               _btcf;              //税引前利益
    /*--------------------------------------*/
    NSInteger               _amCosts;           //減価償却費
    NSInteger               _transferIncome;    //譲渡所得
    NSInteger               _transferTax;       //譲渡税
    NSInteger               _atcf;              //税引後利益
    NSInteger               _sellYear;          //売却年
}
/****************************************************************/
- (void) calcSale:(Investment*)investment holdingPeriod:(NSInteger)holdingPeriod house:(House*)house;
/****************************************************************/
@property   (nonatomic,readwrite)   NSInteger   price;
@property   (nonatomic,readwrite)   NSInteger   expense;
/*--------------------------------------*/
@property   (nonatomic,readonly)    NSInteger   loanBorrow;
@property   (nonatomic,readonly)    NSInteger   btcf;
@property   (nonatomic,readonly)    NSInteger   amCosts;
@property   (nonatomic,readonly)    NSInteger   transferIncome;
@property   (nonatomic,readonly)    NSInteger   transferTax;
@property   (nonatomic,readonly)    NSInteger   atcf;
@property   (nonatomic,readonly)    NSInteger   sellYear;
/****************************************************************/
@end
/****************************************************************/
