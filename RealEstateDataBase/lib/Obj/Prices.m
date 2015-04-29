//
//  Prices.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Prices.h"
/****************************************************************/
@implementation Prices
/****************************************************************/
@synthesize price       = _price;
@synthesize gpi         = _gpi;
@synthesize interest    = _interest;
/****************************************************************
 *
 ****************************************************************/
- (id) initWithPrice:(NSInteger)price gpi:(NSInteger)gpi;
{
    self = [super init];
    if ( self != nil){
        _price          = price;
        _gpi            = gpi;
        if ( _price != 0 ){
            _interest       = (CGFloat)gpi/price;
        } else {
            _interest       = 0;
        }
    }
    return self;
}
/****************************************************************
 *
 ****************************************************************/
- (void)setPrice:(NSInteger)price
{
    _price      = price;
    if ( _price != 0 && _gpi != 0 ){
        _interest   = (CGFloat)_gpi / _price;
    }
}
/****************************************************************
 *
 ****************************************************************/
- (void)setGpi:(NSInteger)gpi
{
    _gpi        = gpi;
    if ( _price != 0 && _gpi != 0 ){
        _interest   = (CGFloat)_gpi / _price;
    }
}
@end
