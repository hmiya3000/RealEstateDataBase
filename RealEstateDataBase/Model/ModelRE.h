//
//  ModelRE.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/18.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Investment.h"
#import "Estate.h"
#import "Operation.h"
@interface ModelRE : NSObject
{
    Investment      *_investment;
    Estate          *_estate;
    NSString        *_loanName;
    Operation       *_ope1;
    Operation       *_opeLast;
    
    NSInteger       _yearAquisition;
    CGFloat         _declineRate;
    CGFloat         _discountRate;
    NSInteger       _holdingPeriod;
    NSInteger       _npv;
    CGFloat         _irr;
    
    NSInteger       _improvementCosts;
    NSInteger       _priceSales;
    NSInteger       _transferExpense;
    NSInteger       _transferIncome;
    NSInteger       _lbSales;
    NSInteger       _btcfSales;
    NSInteger       _amCosts;
    NSInteger       _transferTax;
    NSInteger       _atcfSales;
    
    NSInteger       _btcfOpeAll;
    NSInteger       _atcfOpeAll;
    NSInteger       _btcfTotal;
    NSInteger       _atcfTotal;
    
    NSInteger       _btcfAccumMin;
    NSInteger       _btcfAccumMax;
    NSInteger       _atcfAccumMin;
    NSInteger       _atcfAccumMax;
    
}
/****************************************************************/
+ (ModelRE*)sharedManager;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (void) valToFile;
- (void) fileToVal:(NSString*)serial name:(NSString*)name;
- (void) deleteItem:(NSString*)serial;
- (NSString*) getString:(NSString*)key;
- (void) setPrice:(NSInteger)price;
- (void) adjustEquity;
- (void) adjustLoanBorrow;

- (NSArray*) getOperationArray;
- (NSArray*) getBTCashFlowAccum;
- (NSArray*) getATCashFlowAccum;
- (void) calcAll;
- (NSArray*) getNpvArray;
- (NSArray*) getIrrArray;
- (NSString*) titleString;
- (NSString*) valToString:(NSString*)serial name:(NSString*)name;
- (void) stringToVal:(NSString*)dataStr keyString:(NSString*)keyStr;

/****************************************************************/
@property   (nonatomic) Investment  *investment;
@property   (nonatomic) Estate      *estate;
@property   (nonatomic) NSString    *loanName;
@property   (nonatomic) Operation   *ope1;
@property   (nonatomic) Operation   *opeLast;

@property   (nonatomic,readwrite)   NSInteger   yearAquisition;
@property   (nonatomic,readwrite)   CGFloat     declineRate;
@property   (nonatomic,readwrite)   CGFloat     discountRate;
@property   (nonatomic,readwrite)   NSInteger   holdingPeriod;
@property   (nonatomic,readonly)    NSInteger   npv;
@property   (nonatomic,readonly)    CGFloat     irr;

@property   (nonatomic,readwrite)   NSInteger   improvementCosts;
@property   (nonatomic,readwrite)   NSInteger   priceSales;
@property   (nonatomic,readwrite)   NSInteger   transferExpense;
@property   (nonatomic,readwrite)   NSInteger   transferIncome;
@property   (nonatomic,readonly)    NSInteger   lbSales;
@property   (nonatomic,readonly)    NSInteger   btcfSales;
@property   (nonatomic,readonly)    NSInteger   amCosts;
@property   (nonatomic,readonly)    NSInteger   transferTax;
@property   (nonatomic,readonly)    NSInteger   atcfSales;

@property   (nonatomic,readonly)    NSInteger   btcfOpeAll;
@property   (nonatomic,readonly)    NSInteger   atcfOpeAll;
@property   (nonatomic,readonly)    NSInteger   btcfTotal;
@property   (nonatomic,readonly)    NSInteger   atcfTotal;

@property   (nonatomic,readonly)    NSInteger   btcfAccumMin;
@property   (nonatomic,readonly)    NSInteger   btcfAccumMax;
@property   (nonatomic,readonly)    NSInteger   atcfAccumMin;
@property   (nonatomic,readonly)    NSInteger   atcfAccumMax;
/****************************************************************/
@end
/****************************************************************/
