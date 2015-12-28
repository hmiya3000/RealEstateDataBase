//
//  Land.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Land.h"

/****************************************************************/
@implementation Land
@synthesize address         = _address;
@synthesize assessment      = _assessment;
@synthesize valuation       = _valuation;
@synthesize latitude        = _latitude;
@synthesize longitude       = _longitude;
/****************************************************************/
- (void) setAssessment:(CGFloat)assessment
{
    _assessment = assessment;
    [self calcValuation];
    return;
}
/****************************************************************/
- (void)setAddress:(NSString *)address
{
    NSMutableString *text = [NSMutableString stringWithString:address];
    [text replaceOccurrencesOfString:@"\n"
                          withString:@""
                             options:0
                               range:NSMakeRange(0, [text length])];
    _address = text;
    return;
}
/****************************************************************/
- (void)setArea:(CGFloat)area
{
    _area = area;
    [self calcValuation];
    return;
}
/****************************************************************/
- (void)calcValuation
{
    _valuation  = _area * _assessment*1000;
    return;
}
/****************************************************************/
@end
/****************************************************************/
