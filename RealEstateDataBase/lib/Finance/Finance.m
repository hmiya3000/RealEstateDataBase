//
//  Finance.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Finance.h"

//======================================================================
@implementation Finance

//======================================================================
// PMT:支払い額(元利均等方式)
//======================================================================
+(CGFloat)pmt_rate:(CGFloat)rate period:(NSInteger)period value:(CGFloat)value
{

    CGFloat tmp = 1.0;
    for(int i=0; i< period; i++){
        tmp = tmp * ( 1 + rate);
    }
    
    CGFloat pmt_tmp = ( value * rate * tmp )/ ( tmp -1 );
    return  - pmt_tmp;
}

//======================================================================
// PPMT:その期の支払い元金(元利均等方式)
//======================================================================
+(CGFloat)ppmt_rate:(CGFloat)rate term:(NSInteger)term period:(NSInteger)period value:(CGFloat)value
{
    if ( term <= 0 ){
        return 0;
    } else if ( term > period ){
        return 0;
    }
    
    NSInteger pmt,ipmt;
    pmt     = [self pmt_rate:rate               period:period value:value];
    ipmt    = [self ipmt_rate:rate term:term    period:period value:value];
    return pmt - ipmt;
}

//======================================================================
// IPMT:その期の支払い利息(元利均等方式)
//======================================================================
+(CGFloat)ipmt_rate:(CGFloat)rate term:(NSInteger)term period:(NSInteger)period value:(CGFloat)value
{
    if ( term <= 0 ){
        return 0;
    } else if ( term > period ){
        return 0;
    }
    
    CGFloat pmt;
    pmt = (CGFloat)[self pmt_rate:rate period:period value:value];
    
    float tmp =1.0;
    for(int i=0; i<= (term-1); i++){
        tmp = tmp * ( 1.0 + rate);
    }

    CGFloat ipmt_tmp;
    ipmt_tmp =  - pmt - ( - pmt - value * rate ) * tmp;
    return - ipmt_tmp;
}
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
// その期時点の支払い元金合計(元利均等方式)
//======================================================================
+(CGFloat)cumprinc_rate:(CGFloat)rate term:(NSInteger)term period:(NSInteger)period value:(CGFloat)value
{
    CGFloat sum =0;
    for( int i=0; i<period; i++){
        sum += [self ppmt_rate:rate term:(i+1) period:period value:value];
    }
    return sum;
}
//======================================================================
// その期時点の支払い利息合計(元利均等方式)
//======================================================================
+(CGFloat)cumipmt_rate:(CGFloat)rate term:(NSInteger)term period:(NSInteger)period value:(CGFloat)value
{
    CGFloat sum =0;
    for( int i=0; i<period; i++){
        sum += [self ipmt_rate:rate term:(i+1) period:period value:value];
    }
    return sum;
}

//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
// PMT:その期の支払い額(元金均等方式)
//======================================================================
+(CGFloat)pmtP_rate:(CGFloat)rate term:(NSInteger)term period:(NSInteger)period value:(CGFloat)value
{
    return  [self ppmtP_rate:rate           period:period value:value]
          + [self ispmt_rate:rate term:term period:period value:value];
}

//======================================================================
// PPMT:支払い元金(元金均等方式)
//======================================================================
+(CGFloat)ppmtP_rate:(CGFloat)rate period:(NSInteger)period value:(CGFloat)value
{
    return - value / period;
}

//======================================================================
// ISPMT:その期の支払い利息(元金均等方式)
//======================================================================
+(CGFloat)ispmt_rate:(CGFloat)rate term:(NSInteger)term period:(NSInteger)period value:(CGFloat)value
{
    if ( term <= 0 ){
        return 0;
    } else if ( term > period ){
        return 0;
    }
    
    CGFloat lpmt;
    lpmt = - value * (term - 1) / period;
    return lpmt*rate;
}

//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
// NPV:正味現在価値
//======================================================================
+(CGFloat) npv_rate:(CGFloat)rate array:(NSArray*)array;
{
    if ( [array count] < 1 ){
        return 0;
    }

    NSNumber *val;
    CGFloat npv;
    npv = 0;
    for ( int i=0; i< [array count]; i++){
        val =  [array objectAtIndex:([array count]-i-1)];
        npv = (npv + [val floatValue]) / (1 + rate);
    }
    return npv;
}

//======================================================================
// IRR:内部収益率
//======================================================================
+(CGFloat) irr_array:(NSArray*)array
{
    if ( [array count] < 2 ){
        return 0;
    }
    
    CGFloat x,x_pre;

    x_pre = x = 1.0;
    CGFloat epsiron = 0.0000001;
    for(int i=0; i<10;i++){
        x = [self newton:array x:x];
        CGFloat diff = x - x_pre;
        if ( - epsiron < diff &&  diff < epsiron ){
            break;
        }
        x_pre = x;
    }

    CGFloat retVal = x-1;
    if ( retVal > 0 ){
        return retVal;
    } else {
        return 0;
    }
}
//======================================================================
// ニュートン法
//======================================================================
+(CGFloat) newton:(NSArray*)a x:(CGFloat)x
{
    NSInteger n;
    CGFloat fx,dfx;
    NSNumber *val;
    
    fx  = 0;
    n = [a count];

    for( int i=0; i<n-1; i++){
        val = [a objectAtIndex:i];
        fx = (fx + [val floatValue]) * x;
    }
    val = [a objectAtIndex:n-1];
    fx  = fx + [val floatValue];
    

    dfx = 0;
    for( int i=0; i<n-2; i++){
        val = [a objectAtIndex:i];
        dfx = (dfx + (n-1-i)*[val floatValue]) * x;
    }
    val = [a objectAtIndex:n-2];
    dfx  = dfx + [val floatValue];

    return x - fx/dfx;
}

//======================================================================
@end
//======================================================================
