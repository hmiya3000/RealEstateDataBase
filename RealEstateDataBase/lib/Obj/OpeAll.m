//
//  OpeAll.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/16.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "OpeAll.h"

@implementation OpeAll

/****************************************************************/
@synthesize opeArr          = _opeArr;
@synthesize btcf            = _btcf;
@synthesize atcf            = _atcf;
/****************************************************************
 *
 ****************************************************************/
- (void) calcOpeAll:(NSInteger)holdingPeriod investment:(Investment*)investment house:(House*)house declineRate:(CGFloat)declineRate
{
    NSInteger tmpGpi = investment.prices.gpi;
    NSMutableArray  *opeAll = [NSMutableArray array];
    NSInteger   btcf = 0;
    NSInteger   atcf = 0;
    
    for(int i=0; i< holdingPeriod; i++){
        Operation *ope = [investment getOperation:i+1
                                               gpi:tmpGpi
                                              loan:investment.loan
                                 amortizationCosts:[house getAmortizationCosts_term:i+1]];
        tmpGpi = tmpGpi * (1 - declineRate);
        [opeAll addObject:ope];
        btcf = btcf + ope.btcf;
        atcf = atcf + ope.atcf;
    }
    
    _btcf   = btcf;
    _atcf   = atcf;
    _opeArr = opeAll;

    return;
}

/****************************************************************/
@end
/****************************************************************/
