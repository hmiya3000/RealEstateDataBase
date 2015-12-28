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
@synthesize name                = _name;
@synthesize construct           = _construct;
@synthesize rooms               = _rooms;
@synthesize buildYear           = _buildYear;
@synthesize yearAquisition      = _yearAquisition;
@synthesize improvementCosts    = _improvementCosts;
@synthesize valuation           = _valuation;
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
/****************************************************************
 * 耐用年数
 ****************************************************************/
+ (NSInteger)usefulLife:(NSInteger)constructNo
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
 * 再調達原価
 ****************************************************************/
+ (NSInteger)getReplacementCost:(NSInteger)constructNo
{
    NSInteger replacementCost;
    switch (constructNo) {
        case CONST_WOOD:
            replacementCost = 13;
            break;
        case CONST_LSTEEL:
            replacementCost = 14;
            break;
        case CONST_STEEL:
            replacementCost = 15;
            break;
        case CONST_RC:
        case CONST_SRC:
            replacementCost = 20;
            break;
        case CONST_NONE:
        default:
            replacementCost = 13;
            break;
    }
    return replacementCost  * 10000;
    
}
/****************************************************************
 *
 ****************************************************************/
- (void)setConstruct:(NSInteger)construct
{
    _construct = construct;
    [self calcValuation];
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)setBuildYear:(NSInteger)buildYear
{
    _buildYear  = buildYear;
    [self calcValuation];
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)setYearAquisition:(NSInteger)yearAquisition
{
    _yearAquisition = yearAquisition;
    [self calcValuation];
    return;
}


/****************************************************************
 * 指定した期の減価償却費(定額法)
 ****************************************************************/
- (NSInteger) getAmortizationCosts_term:(NSInteger)term
{
    //償却期間の計算
    NSInteger amPeriod;
    NSInteger usefulLife = [House usefulLife:_construct];
    if ( _buildYear >= _yearAquisition ){
        /* 新築 or 建築前 */
        /* 耐用年数そのまま */
        amPeriod = usefulLife;
    } else {
        /* 中古物件 */
        NSInteger elapsedYear = _yearAquisition - _buildYear;
        if ( elapsedYear > usefulLife ){
            /* 耐用年数越え */
            amPeriod    = (int)( usefulLife * 0.2);
        } else {
            /* 耐用年数が一部経過 */
            amPeriod = (usefulLife - elapsedYear) + (int)elapsedYear*0.2;
        }
    }

    //減価償却費の計算
    NSInteger amCosts;
    if ( 0 < term && term <= amPeriod ){
        /* 償却期間内 */
        amCosts     = _price / amPeriod;
    } else {
        /* 償却期間外 */
        amCosts     = 0;
    }
    return  amCosts;
}

/****************************************************************
 * 購入から指定した時期までの期間の減価償却費の累計
 ****************************************************************/
- (NSInteger)getAmortizationCostsSum_period:(NSInteger)period
{
    NSInteger amCosts = 0;
    for(int i=0; i< period; i++){
        amCosts = amCosts + [self getAmortizationCosts_term:i+1];
    }
    return amCosts;
}
/****************************************************************
 * 評価額の計算
 ****************************************************************/
- (void)calcValuation
{
    NSInteger replacementCost = [House getReplacementCost:_construct];
    
    if ( _buildYear >= _yearAquisition ){
        _valuation = _area * replacementCost;
    } else {
        NSInteger usefulLife = [House usefulLife:_construct];   //耐用年数
        NSInteger elapsedYear = _yearAquisition - _buildYear;   //築年数年
        if ( usefulLife > elapsedYear ){
            _valuation = _area * replacementCost * ( usefulLife - elapsedYear ) / usefulLife;
        } else {
            _valuation = 0;
        }
    }
}


/****************************************************************/
@end
/****************************************************************/
