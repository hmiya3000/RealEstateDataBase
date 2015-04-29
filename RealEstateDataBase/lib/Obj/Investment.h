//
//  Investment.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Prices.h"
#import "Loan.h"
#import "Operation.h"

/****************************************************************/
@interface Investment : NSObject
{
    Prices      *_prices;
    Loan        *_loan;

    CGFloat     _emptyRate;
    CGFloat     _mngRate;
    CGFloat     _propTaxRate;
    CGFloat     _incomeTaxRate;
    NSInteger   _equity;
    NSInteger   _expense;
    

}
/****************************************************************/
- (Operation*) calcAll;
- (Operation*) getOperation:(NSInteger)year gpi:(NSInteger)gpi loan:(Loan*)loan amortizationCosts:(NSInteger)amortizationCosts;
- (void) adjustEquity;
- (void) adjustLoanBorrow;
/****************************************************************/
@property   (nonatomic)             Prices      *prices;
@property   (nonatomic)             Loan        *loan;
@property   (nonatomic)             CGFloat     mngRate;
@property   (nonatomic)             CGFloat     propTaxRate;
@property   (nonatomic)             CGFloat     incomeTaxRate;
@property   (nonatomic)             NSInteger   equity;
@property   (nonatomic)             NSInteger   expense;
@property   (nonatomic)             CGFloat     emptyRate;

/****************************************************************/
@end
/****************************************************************/
