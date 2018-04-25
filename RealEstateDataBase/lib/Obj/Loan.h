//
//  Loan.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//======================================================================
@interface Loan : NSObject<NSCopying>
{
    NSInteger   _loanBorrow;
    CGFloat     _rateYear;
    NSInteger   _periodTerm;
    BOOL        _levelPayment;
}
//======================================================================
-(id)initWithLoanBorrow:(NSInteger)lb rateYear:(CGFloat)ry periodTerm:(NSInteger)pt levelPayment:(BOOL)lp;
-(void)setAllProperty_loannBorrow:(NSInteger)lb rateYear:(CGFloat)ry periodTerm:(NSInteger)pt levelPayment:(BOOL)lp;
-(NSInteger)getLb:(NSInteger)tgtTerm;
-(NSInteger)getLbYear:(NSInteger)tgtYear;
-(NSInteger)getPmt:(NSInteger)tgtTerm;
-(NSInteger)getPmtYear:(NSInteger)tgtYear;
-(NSInteger)getPpmt:(NSInteger)tgtTerm;
-(NSInteger)getPpmtYear:(NSInteger)tgtYear;
-(NSInteger)getIpmt:(NSInteger)tgtTerm;
-(NSInteger)getIpmtYear:(NSInteger)tgtYear;
-(NSInteger)getIpmtAll;
-(NSArray*)getPmtArrayYear;
-(NSArray*)getPpmtArrayYear;
-(NSArray*)getLbArrayYear;
-(NSArray*)getLbArrayTerm;
//======================================================================
@property   (nonatomic) NSInteger   loanBorrow;
@property   (nonatomic) CGFloat     rateYear;
@property   (nonatomic) NSInteger   periodTerm;
@property   (nonatomic) BOOL        levelPayment;
//======================================================================
@end
//======================================================================
