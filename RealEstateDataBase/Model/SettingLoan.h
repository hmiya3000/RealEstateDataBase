//
//  SettingLoan.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/15.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loan.h"
#import "UIUtil.h"

/****************************************************************/
@interface SettingLoan : NSObject
{
    Loan        *_loan0;
    Loan        *_loan1;
    Loan        *_loan2;
    
    NSString    *_name0;
    NSString    *_name1;
    NSString    *_name2;
    
    NSInteger   _startYear;
    NSInteger   _startMonth;
    
    SVSegmentedControl  *_sc;
}
/****************************************************************/
+ (SettingLoan*)sharedManager;
- (void)setLoanBorrows:(float)lb;
- (SVSegmentedControl*)makeSegmentedControl:(CGFloat)x y:(CGFloat)y length:(CGFloat)length;
- (NSInteger)getPeriodMax;
- (NSInteger)getPmtMax;
- (void)initData;
- (void)saveData;
- (void)loadData;
/****************************************************************/
@property   (nonatomic)     Loan                    *loan0;
@property   (nonatomic)     Loan                    *loan1;
@property   (nonatomic)     Loan                    *loan2;
@property   (nonatomic)     NSString                *name0;
@property   (nonatomic)     NSString                *name1;
@property   (nonatomic)     NSString                *name2;
@property   (nonatomic)     NSInteger               startYear;
@property   (nonatomic)     NSInteger               startMonth;
@property   (nonatomic)     SVSegmentedControl      *sc;
/****************************************************************/
@end
/****************************************************************/
