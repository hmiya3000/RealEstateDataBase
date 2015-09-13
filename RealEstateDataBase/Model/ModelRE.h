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
#import "Sale.h"
#import "Operation.h"

@interface ModelRE : NSObject
{
    Investment          *_investment;
    Estate              *_estate;
    Sale                *_sale;
    
    NSString            *_loanName;
    Operation           *_ope1;
    Operation           *_opeLast;
    
    CGFloat             _declineRate;
    CGFloat             _discountRate;
    NSInteger           _holdingPeriod;
    NSInteger           _npv;
    CGFloat             _irr;
    CGFloat             _btIrr;
    CGFloat             _atIrr;
    
    NSInteger           _btcfOpeAll;
    NSInteger           _atcfOpeAll;
    NSInteger           _btcfTotal;
    NSInteger           _atcfTotal;
    
    NSInteger           _btcfAccumMin;
    NSInteger           _btcfAccumMax;
    NSInteger           _atcfAccumMin;
    NSInteger           _atcfAccumMax;
    
}
/****************************************************************/
+ (ModelRE*)sharedManager;
+ (id)allocWithZone:(NSZone *)zone;
- (id)copyWithZone:(NSZone *)zone;
- (void) autoInput;
- (void) valToFile;
- (void) fileToVal:(NSString*)serial name:(NSString*)name;
- (void) deleteItem:(NSString*)serial;
- (NSString*) getString:(NSString*)key;
- (void) setPrice:(NSInteger)price;
- (void) adjustEquity;
- (void) adjustLoanBorrow;

- (NSArray*) getOperationArray;
- (NSArray*) getBTCashFlowAccum:(NSInteger)period;
- (NSArray*) getATCashFlowAccum:(NSInteger)period;
- (void) calcAll;
- (NSArray*) getNpvArray;
- (NSArray*) getIrrArray;
- (NSArray*) getDebtRepaymentPeriodArray;

- (NSString*) titleString;
- (NSString*) valToString:(NSString*)serial name:(NSString*)name;
- (void) stringToVal:(NSString*)dataStr keyString:(NSString*)keyStr;

/****************************************************************/
@property   (nonatomic,readwrite)   Investment  *investment;
@property   (nonatomic,readwrite)   Estate      *estate;
@property   (nonatomic,readwrite)   NSString    *loanName;
@property   (nonatomic,readwrite)   Sale        *sale;
@property   (nonatomic,readonly)    Operation   *ope1;
@property   (nonatomic,readonly)    Operation   *opeLast;

@property   (nonatomic,readwrite)   CGFloat     declineRate;
@property   (nonatomic,readwrite)   CGFloat     discountRate;
@property   (nonatomic,readwrite)   NSInteger   holdingPeriod;
@property   (nonatomic,readonly)    NSInteger   npv;
@property   (nonatomic,readonly)    CGFloat     btIrr;
@property   (nonatomic,readonly)    CGFloat     atIrr;
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
