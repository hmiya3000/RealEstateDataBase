//
//  Loan.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Loan.h"
#import "Finance.h"

/****************************************************************/
@implementation Loan
{
    NSMutableArray  *_pmtArr;
    NSMutableArray  *_ppmtArr;
    NSMutableArray  *_ipmtArr;
    NSMutableArray  *_lbArr;
}
/****************************************************************/
@synthesize     loanBorrow      = _loanBorrow;
@synthesize     rateYear        = _rateYear;
@synthesize     periodYear      = _periodYear;
@synthesize     levelPayment    = _levelPayment;
/****************************************************************
 *
 ****************************************************************/
- (id)copyWithZone:(NSZone*)zone
{
    // 複製を保存するためのインスタンスを生成します。
    Loan* result = [[[self class] allocWithZone:zone] init];
    
    if (result){
        result.loanBorrow   = _loanBorrow;
        result.periodYear   = _periodYear;
        result.rateYear     = _rateYear;
        result.levelPayment = _levelPayment;
    }
    
    return result;
}
/****************************************************************
 *
 ****************************************************************/
-(id)initWithLoanBorrow:(NSInteger)lb rateYear:(CGFloat)ry periodYear:(NSInteger)py levelPayment:(BOOL)lp
{
    self = [super init];
    if ( self != nil){
        [self setAllProperty_loannBorrow:lb rateYear:ry periodYear:py levelPayment:lp];
    }
    return self;
}

/****************************************************************
 *
 ****************************************************************/
- (void)setAllProperty_loannBorrow:(NSInteger)lb rateYear:(CGFloat)ry periodYear:(NSInteger)py levelPayment:(BOOL)lp
{
    _loanBorrow = lb;
    _rateYear   = ry;
    _periodYear = py;
    _levelPayment = lp;
    [self calcAll];
}

/****************************************************************
 *
 ****************************************************************/
- (void)setLoanBorrow:(NSInteger)loanBorrow
{
    if (  _loanBorrow != loanBorrow ){
        _loanBorrow = loanBorrow;
        [self calcAll];
    }
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (void)setRateYear:(CGFloat)rateYear
{
    if (  _rateYear != rateYear ){
        _rateYear = rateYear;
        [self calcAll];
    }
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (void)setPeriodYear:(NSInteger)periodYear
{
    if (  _periodYear != periodYear ){
        _periodYear = periodYear;
        [self calcAll];
    }
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (void)setLevelPayment:(BOOL)levelPayment
{
    if (  _levelPayment != levelPayment ){
        _levelPayment = levelPayment;
        [self calcAll];
    }
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)calcAll
{
    NSInteger lb_term   = 0;
    NSInteger pmt_term  = 0;
    NSInteger ipmt_term = 0;
    NSInteger ppmt_term = 0;

    _pmtArr     = [NSMutableArray array];
    _ppmtArr    = [NSMutableArray array];
    _ipmtArr    = [NSMutableArray array];
    _lbArr    = [NSMutableArray array];
    NSNumber *tmpNum;

    if ( _levelPayment == true ){
        /* 元利均等方式 */
        pmt_term = -(NSInteger)[Finance pmt_rate:_rateYear/12
                                          period:_periodYear*12
                                           value:_loanBorrow];
        lb_term = (long)_loanBorrow;
        for ( NSInteger term=0; term < _periodYear*12; term++){
            /*---------------*/
            ipmt_term   = (NSInteger)(lb_term * _rateYear/12);
            if ( term < _periodYear*12 -1){
                ppmt_term   = pmt_term - ipmt_term;
                lb_term     = lb_term - ppmt_term;
            } else if ( term == _periodYear*12 -1 ){
                /* 最終回は端数処理 */
                ppmt_term   = lb_term;
                pmt_term    = ppmt_term + ipmt_term;
                lb_term     = 0;
            }
            /*---------------*/
            tmpNum = [[NSNumber alloc]initWithInteger:pmt_term];
            [_pmtArr addObject:tmpNum];
            tmpNum = [[NSNumber alloc]initWithInteger:ppmt_term];
            [_ppmtArr addObject:tmpNum];
            tmpNum = [[NSNumber alloc]initWithInteger:ipmt_term];
            [_ipmtArr addObject:tmpNum];
            tmpNum = [[NSNumber alloc]initWithInteger:lb_term];
            [_lbArr addObject:tmpNum];
        }
    } else {
        /* 元金均等方式 */
        ppmt_term  = -(NSInteger)[Finance ppmtP_rate:_rateYear/12
                                              period:_periodYear*12
                                               value:_loanBorrow];
        lb_term = (NSInteger)_loanBorrow;
        for ( NSInteger term=0; term < _periodYear*12; term++){
            /*---------------*/
            ipmt_term = (NSInteger)(lb_term * _rateYear/12);
            if ( term < _periodYear*12 -1){
                lb_term     = lb_term - ppmt_term;
            } else if ( term == _periodYear*12 -1){
                /* 最終回は端数処理 */
                ppmt_term   = lb_term;
                lb_term     = 0;
            }
            pmt_term    = ppmt_term + ipmt_term;
            /*---------------*/
            tmpNum = [[NSNumber alloc]initWithInteger:pmt_term];
            [_pmtArr addObject:tmpNum];
            tmpNum = [[NSNumber alloc]initWithInteger:ppmt_term];
            [_ppmtArr addObject:tmpNum];
            tmpNum = [[NSNumber alloc]initWithInteger:ipmt_term];
            [_ipmtArr addObject:tmpNum];
            tmpNum = [[NSNumber alloc]initWithInteger:lb_term];
            [_lbArr addObject:tmpNum];
        }
    }
    
    return;
}

/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getLb:(NSInteger)tgtTerm
{
    if ( tgtTerm > 0 && tgtTerm <= _periodYear*12 ){
        NSNumber *tmpNum = [_lbArr objectAtIndex:tgtTerm-1];
        return [tmpNum integerValue];
    } else {
        return 0;
    }
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getLbYear:(NSInteger)tgtYear
{
    NSInteger tgtTerm = tgtYear * 12;
    return [self getLb:tgtTerm];
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getPmt:(NSInteger)tgtTerm
{
    if ( tgtTerm > 0 && tgtTerm <= _periodYear*12 ){
        NSNumber *tmpNum = [_pmtArr objectAtIndex:tgtTerm-1];
        return [tmpNum integerValue];
    } else {
        return 0;
    }
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getPmtYear:(NSInteger)tgtYear
{
    NSInteger tgtTerm = (tgtYear-1) * 12 +1;
    NSInteger sum = 0;
    for( int i=0; i<12; i++){
        sum += [self getPmt:tgtTerm+i];
    }
    return sum;
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getPpmt:(NSInteger)tgtTerm
{
    if ( tgtTerm > 0 && tgtTerm <= _periodYear*12 ){
        NSNumber *tmpNum = [_ppmtArr objectAtIndex:tgtTerm-1];
        return [tmpNum integerValue];
    } else {
        return 0;
    }
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getPpmtYear:(NSInteger)tgtYear
{
    NSInteger tgtTerm = (tgtYear-1) * 12 +1;
    NSInteger sum = 0;
    for( int i=0; i<12; i++){
        sum += [self getPpmt:tgtTerm+i];
    }
    return sum;
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getIpmt:(NSInteger)tgtTerm
{
    if ( tgtTerm > 0 && tgtTerm <= _periodYear*12 ){
        NSNumber *tmpNum = [_ipmtArr objectAtIndex:tgtTerm-1];
        return [tmpNum integerValue];
    } else {
        return 0;
    }
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getIpmtYear:(NSInteger)tgtYear
{
    NSInteger tgtTerm = (tgtYear-1) * 12 +1;
    NSInteger sum = 0;
    for( int i=0; i<12; i++){
        sum += [self getIpmt:tgtTerm+i];
    }
    return sum;
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getIpmtAll
{
    NSInteger sum = 0;
    NSInteger lb = _loanBorrow;
    NSInteger ipmt;
    for(int i=0; i< _periodYear*12; i++){
        ipmt = (NSInteger)(lb * _rateYear/12);
        sum = sum + ipmt;
        lb  = lb - ([self getPmt:i+1] - ipmt);
        //            NSLog(@"pmt %d ipmt %d i %d",[self getPmt:i+1],ipmt,i);
    }
    return sum;
}
/****************************************************************
 *
 ****************************************************************/
-(NSArray*)getPmtArrayYear
{
    NSMutableArray *arr = [NSMutableArray array];
    
    CGPoint tmpRect;
    for( int i=1; i<= _periodYear; i ++){
        tmpRect = CGPointMake( i,[self getPmtYear:i] );
        [arr addObject:[NSValue valueWithCGPoint:tmpRect]];
    }
    return arr;
    
}
/****************************************************************
 *
 ****************************************************************/
-(NSArray*)getPpmtArrayYear
{
    NSMutableArray *arr = [NSMutableArray array];
    
    CGPoint tmpRect;
    for( int i=1; i<= _periodYear; i ++){
        tmpRect = CGPointMake( i,[self getPpmtYear:i] );
        [arr addObject:[NSValue valueWithCGPoint:tmpRect]];
    }
    return arr;
    
}
/****************************************************************
 *
 ****************************************************************/
-(NSArray*)getIpmtArrayYear
{
    NSMutableArray *arr = [NSMutableArray array];
    
    CGPoint tmpRect;
    for( int i=1; i<= _periodYear; i ++){
        tmpRect = CGPointMake( i,[self getIpmtYear:i] );
        [arr addObject:[NSValue valueWithCGPoint:tmpRect]];
    }
    return arr;
}
/****************************************************************
 *
 ****************************************************************/
-(NSArray*)getLbArrayYear
{
    NSMutableArray *arr = [NSMutableArray array];
    
    CGPoint tmpRect;
    for( int i=1; i<= _periodYear; i ++){
        tmpRect = CGPointMake( i,[self getLbYear:i] );
        [arr addObject:[NSValue valueWithCGPoint:tmpRect]];
    }
    return arr;
}
/****************************************************************/
@end
/****************************************************************/
