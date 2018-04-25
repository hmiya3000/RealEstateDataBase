//
//  House.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "House.h"
#import "UIUtil.h"

//================================================================
@implementation House
{
    NSInteger               _priceHouseBook;
    NSInteger               _priceEquipBook;
}
//================================================================
@synthesize name                = _name;
@synthesize price               = _price;
@synthesize priceBook           = _priceBook;
@synthesize area                = _area;
@synthesize construct           = _construct;
@synthesize rooms               = _rooms;
@synthesize equipRatio          = _equipRatio;
@synthesize buildTerm           = _buildTerm;
@synthesize acquisitionTerm     = _acquisitionTerm;
@synthesize improvementCosts    = _improvementCosts;
@synthesize valuation           = _valuation;
//================================================================

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
+ (NSInteger)usefulLifeYear:(NSInteger)constructNo
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
- (void)setBuildTerm:(NSInteger)buildTerm
{
    _buildTerm = buildTerm;
    [self calcValuation];
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (void)setAcquisitionTerm:(NSInteger)acquisitionTerm
{
    _acquisitionTerm = acquisitionTerm;
    [self calcValuation];
    return;
}

/****************************************************************
 * 指定した期の減価償却費(定額法)
 ****************************************************************/
- (NSInteger) getAmortizationCosts_term:(NSInteger)term addPrice:(NSInteger)addPrice
{
    CGFloat amRate[] =
    {
        1,  //  2       3       4       5
        1,      0.5,    0.334,  0.250,  0.200,  //1-5
        0.167,  0.143,  0.125,  0.112,  0.100,  //6-10
        0.091,  0.084,  0.077,  0.072,  0.067,  //11-15
        0.063,  0.059,  0.056,  0.053,  0.050,  //16-20
        0.048,  0.046,  0.044,  0.042,  0.040,  //21-25
        0.039,  0.038,  0.036,  0.035,  0.034,  //26-30
        0.033,  0.032,  0.031,  0.030,  0.029,  //31-35
        0.028,  0.028,  0.027,  0.026,  0.025,  //36-40
        0.025,  0.024,  0.024,  0.023,  0.023,  //41-45
        0.022,  0.022,  0.021,  0.021,  0.020,  //46-50
    };
    NSInteger elapsedTerm       = _acquisitionTerm - _buildTerm;            //月換算の築年数
    NSInteger usefulLifeTerm    = [House usefulLifeYear:_construct]*12;     //耐用年数
    NSInteger amPeriodYear      = [House getAmortizationPeriod_elapsedTerm:elapsedTerm usefulLifeTerm:usefulLifeTerm];


    //減価償却費の計算
    NSInteger amCosts;
    if ( 0 <= term && term < amPeriodYear*12 ){
        // 償却期間が2年の場合、0〜23ヶ月目は償却期間内
        amCosts     = (_price+addPrice) * amRate[amPeriodYear];
    } else {
        // 償却期間外
        amCosts     = 0;
    }
    return  amCosts/12;
}
//================================================================
//償却期間の計算
//================================================================
+ (NSInteger)getAmortizationPeriod_elapsedTerm:(NSInteger)elapsedTerm usefulLifeTerm:(NSInteger)usefulLifeTerm
{
    NSInteger amPeriodYear;
    if ( elapsedTerm <= 0 ){
        /* 新築 or 建築前 */
        /* 耐用年数そのまま */
        amPeriodYear = usefulLifeTerm/12;
    } else {
        /* 中古物件 */
        if ( elapsedTerm > usefulLifeTerm ){
            /* 耐用年数越え:償却期間 = 耐用年数の20% */
            amPeriodYear = (int)(usefulLifeTerm * 0.2 / 12);
        } else {
            /* 耐用年数が一部経過:償却期間 = 残存年数 +  */
            amPeriodYear = (int)((usefulLifeTerm-elapsedTerm + (CGFloat)elapsedTerm*0.2)/12);
        }
    }
    return amPeriodYear;
}

/****************************************************************
 * 購入から指定した時期までの期間の減価償却費の累計
 ****************************************************************/
- (NSInteger)getAmortizationCostsSum_period:(NSInteger)period addPrice:(NSInteger)addPrice
{
    NSInteger amCosts = 0;
    for(int i=0; i< period; i++){
        amCosts = amCosts + [self getAmortizationCosts_term:i+1 addPrice:addPrice];
    }
    return amCosts;
}

/****************************************************************
 * 再調達価格
 ****************************************************************/
- (NSInteger)getReplacementCostValue
{
    return [House getReplacementCost:_construct] * _area;
}

/****************************************************************
 * 評価額の計算
 ****************************************************************/
- (NSInteger)getValuation_term:(NSInteger)term
{
    if (term < 1){
        term = 1;
    }
    NSInteger valuation = 0;
    NSInteger replacementCost = [House getReplacementCost:_construct];

    NSInteger usefulLifeMonth   = [House usefulLifeYear:_construct]*12;             //月換算の耐用年数
    NSInteger elapsedMonth      = _acquisitionTerm - _buildTerm + term;             //月換算の築年数
    if ( usefulLifeMonth > elapsedMonth ){
        valuation = _area * replacementCost * ( usefulLifeMonth - elapsedMonth ) / usefulLifeMonth;
    } else {
        valuation = 0;
    }
    return valuation;
}
/****************************************************************/
- (void)calcValuation
{
    _valuation = [self getValuation_term:1];
}

/****************************************************************
 * 不動産取得税の計算
 ****************************************************************/
- (NSInteger)getAcquTax
{
    NSInteger acquTax;
    CGFloat taxRate;
    NSInteger term_2018_04 = [UIUtil getTerm_year:2018 month:4];
    
    if ( _acquisitionTerm < term_2018_04 ){
            taxRate = 3;
    } else {
        //2018年4月1日以降の取得は税率4%
        taxRate = 4;
    }
    
    
    NSInteger valuation = [self getValuation_term:1];
    if ( _buildTerm >= _acquisitionTerm ){
        //新築
        if ( _area >= 50 && _area <= 240 ){
            //床面積50-240平米の新築は1200万の控除
            acquTax = (valuation - 1200*10000 ) * taxRate /100;
            if ( acquTax < 0 ){
                acquTax = 0;
            }
        } else {
            acquTax = valuation * taxRate /100;
        }
    } else {
        //中古
        //自己の居住の為でない場合は軽減措置はない
        acquTax = valuation * taxRate /100;
    }
    
    return acquTax;
}
/****************************************************************
 * 固定資産税・都市計画税の計算
 ****************************************************************/
- (NSInteger)getPropTax_term:(NSInteger)term
{
    NSInteger valuation = [self getValuation_term:term];
    NSInteger propTax =  valuation * 0.014;
    NSInteger townTax =  valuation * 0.003;
    
    return propTax + townTax;
}


/****************************************************************/
@end
/****************************************************************/
