//
//  Finance.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014”N Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Finance : NSObject
/****************************************************************/
+ (CGFloat) pmt_rate:(CGFloat)rate                              period:(NSInteger)period value:(CGFloat)value;
+ (CGFloat) ppmt_rate:(CGFloat)rate     term:(NSInteger)term    period:(NSInteger)period value:(CGFloat)value;
+ (CGFloat) ipmt_rate:(CGFloat)rate     term:(NSInteger)term    period:(NSInteger)period value:(CGFloat)value;
/****************************************************************/
+ (CGFloat) pmtP_rate:(CGFloat)rate     term:(NSInteger)term    period:(NSInteger)period value:(CGFloat)value;
+ (CGFloat) ppmtP_rate:(CGFloat)rate                            period:(NSInteger)period value:(CGFloat)value;
+ (CGFloat) ispmt_rate:(CGFloat)rate    term:(NSInteger)term    period:(NSInteger)period value:(CGFloat)value;
/****************************************************************/
+ (CGFloat) cumprinc_rate:(CGFloat)rate term:(NSInteger)term    period:(NSInteger)period value:(CGFloat)value;
+ (CGFloat) cumipmt_rate:(CGFloat)rate  term:(NSInteger)term    period:(NSInteger)period value:(CGFloat)value;
/****************************************************************/
+ (CGFloat) npv_rate:(CGFloat)rate array:(NSArray*)array;
+ (CGFloat) irr_array:(NSArray*)array;
/****************************************************************/
@end
/****************************************************************/
