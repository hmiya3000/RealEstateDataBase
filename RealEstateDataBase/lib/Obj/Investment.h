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
    Prices          *_prices;           //価格
    Loan            *_loan;             //ローン

    CGFloat         _emptyRate;         //空室率
    CGFloat         _mngRate;           //運営費率
    CGFloat         _propTaxRate;       //固定資産税率
    CGFloat         _incomeTaxRate;     //所得税率
    NSInteger       _equity;            //自己資金
    NSInteger       _expense;           //諸経費

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
