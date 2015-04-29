//
//  House.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "House.h"
#import "UIUtil.h"

/****************************************************************/
@implementation House
/****************************************************************/
@synthesize name        = _name;
@synthesize construct   = _construct;
@synthesize rooms       = _rooms;
@synthesize buildYear   = _buildYear;
@synthesize valuation   = _valuation;
/****************************************************************/
+ (NSString*)constructStr:(NSInteger)constructNo
{
    NSString   *str;
    switch (constructNo) {
    case CONST_WOOD:
        str = @"木造";
        break;
    case CONST_LSTEEL:
        str = @"軽量鉄骨造";
        break;
    case CONST_STEEL:
        str = @"鉄骨造";
        break;
    case CONST_RC:
        str = @"RC造";
        break;
    case CONST_SRC:
        str = @"SRC造";
        break;
    case CONST_NONE:
    default:
        str = @"不明";
        break;
    }
    return str;
}
/****************************************************************/
+ (NSInteger)amortizationPeriod:(NSInteger)constructNo
{
    NSInteger   period;
    switch (constructNo) {
        case CONST_WOOD:
            period = 22;
            break;
        case CONST_LSTEEL:
            period = 27;
            break;
        case CONST_STEEL:
            period = 34;
            break;
        case CONST_RC:
            period = 47;
            break;
        case CONST_SRC:
            period = 47;
            break;
        case CONST_NONE:
        default:
            period = 22;
            break;
    }
    return period;
}
/****************************************************************
 *
 ****************************************************************/
- (NSInteger) getAmortizationCosts_aquYear:(NSInteger)aquYear term:(NSInteger)term
{
    NSInteger amCosts;
    NSInteger amPeriod = [House amortizationPeriod:_construct];
    if ( _buildYear >= aquYear ){
        /* 新築 or 建築前 */
        /* 耐用年数そのまま */
    } else {
        /* 中古物件 */
        NSInteger elapsedYear = aquYear - _buildYear;
        if ( elapsedYear > amPeriod ){
            /* 耐用年数越え */
            amPeriod    = (int)( amPeriod * 0.2);
        } else {
            /* 耐用年数が一部経過 */
            amPeriod = (amPeriod - elapsedYear) + (int)elapsedYear*0.2;
        }
    }
    if ( 0 < term && term <= amPeriod ){
        /* 償却期間内 */
        amCosts     = _price / amPeriod;
    } else {
        /* 償却期間外 */
        amCosts     = 0;
    }
    return  amCosts;
}
/****************************************************************/
@end
/****************************************************************/
