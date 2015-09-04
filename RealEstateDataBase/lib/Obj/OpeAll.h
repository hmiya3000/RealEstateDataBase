//
//  OpeAll.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/16.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Operation.h"
#import "Investment.h"
#import "Estate.h"

/****************************************************************/
@interface OpeAll : NSObject
{
    NSArray         *_opeArr;
    NSInteger       _btcf;
    NSInteger       _atcf;
    
}
/****************************************************************/
- (void) calcOpeAll:(NSInteger)holdingPeriod investment:(Investment*)investment house:(House*)house declineRate:(CGFloat)declineRate;
/****************************************************************/
@property   (nonatomic,readonly)    NSArray     *opeArr;
@property   (nonatomic,readonly)    NSInteger   btcf;
@property   (nonatomic,readonly)    NSInteger   atcf;
/****************************************************************/
@end
/****************************************************************/
