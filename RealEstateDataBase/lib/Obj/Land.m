//
//  Land.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Land.h"
#import "UIUtil.h"
//======================================================================
@implementation Land
@synthesize price               = _price;
@synthesize priceBook           = _priceBook;
@synthesize area                = _area;
@synthesize address             = _address;
@synthesize assessment          = _assessment;
@synthesize assessValue         = _assessValue;
@synthesize marketValue         = _marketValue;
@synthesize propValue           = _propValue;
@synthesize latitude            = _latitude;
@synthesize longitude           = _longitude;
//======================================================================
-(void) setAssessment:(CGFloat)assessment
{
    _assessment = assessment;
    [self calcValuation];
    return;
}
//======================================================================
-(void)setAddress:(NSString *)address
{
    NSMutableString *text = [NSMutableString stringWithString:address];
    [text replaceOccurrencesOfString:@"\n"
                          withString:@""
                             options:0
                               range:NSMakeRange(0, [text length])];
    _address = text;
    return;
}
//======================================================================
-(void)setArea:(CGFloat)area
{
    _area = area;
    [self calcValuation];
    return;
}
//======================================================================
-(void)calcValuation
{
    _assessValue    = _area * _assessment*1000;
    _marketValue    = _assessValue / 0.8;
    _propValue      = _marketValue * 0.7;
    return;
}
//======================================================================
// 不動産取得税の計算
//======================================================================
-(NSInteger)getAcquTax_acquTerm:(NSInteger)acquTerm;
{
    [self calcValuation];

    NSInteger acquTax;
    NSInteger taxRate;
    NSInteger taxTerm = [UIUtil getTerm_year:2018 month:4];
    
    if (acquTerm >= taxTerm){
        //2018年4月1日以降の取得は税率4%
        taxRate = 4;
        acquTax = _propValue * taxRate / 100;
    } else {
        //2018年3月31日までは減税で税率3%
        taxRate = 3;
        //宅地の場合は課税標準額の1/2
        acquTax = _propValue / 2 * taxRate / 100;
    }
    
    return acquTax;
}
//======================================================================
// 固定資産税・都市計画税の計算
//======================================================================
-(NSInteger)getPropTax_houseArea:(CGFloat)houseArea houseRooms:(NSInteger)houseRooms
{
    NSInteger propTax;
    NSInteger townTax;
    
    if ( (houseArea / houseRooms) <= 200 ){
        //小規模住宅用地の課税標準の特例
        propTax = _propValue /6 * 0.014;
        townTax = _propValue /3 * 0.003;
    } else {
        propTax = _propValue   /3 * 0.014;
        townTax = _propValue *2/3 * 0.003;
    }
    return propTax + townTax;
}
//======================================================================
@end
//======================================================================
