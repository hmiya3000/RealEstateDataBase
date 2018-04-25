//
//  Operation.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/06.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//======================================================================
@interface Operation : NSObject
{
    NSInteger   _gpi;
    NSInteger   _emptyLoss;
    NSInteger   _egi;
    NSInteger   _opex;
    NSInteger   _opex_tax;
    NSInteger   _opex_mng;
    NSInteger   _opex_etc;
    NSInteger   _noi;
    NSInteger   _ads;
    NSInteger   _btcf;
    NSInteger   _initCost;
    NSInteger   _taxIncome;
    NSInteger   _amCost;
    NSInteger   _tax;
    NSInteger   _atcf;

    CGFloat     _fcr;
    CGFloat     _loanConst;
    CGFloat     _ccr;
    CGFloat     _pb;
    CGFloat     _dcr;
    CGFloat     _ber;
    CGFloat     _ltv;
    CGFloat     _capRate;

    NSInteger   _rentUnitPrice;
    CGFloat     _yieldNfc;
    CGFloat     _yieldAmo;
}


//======================================================================
@property   (nonatomic,readwrite)   NSInteger   gpi;
@property   (nonatomic,readwrite)   NSInteger   emptyLoss;
@property   (nonatomic,readwrite)   NSInteger   egi;
@property   (nonatomic,readwrite)   NSInteger   opex;
@property   (nonatomic,readwrite)   NSInteger   opex_tax;
@property   (nonatomic,readwrite)   NSInteger   opex_mng;
@property   (nonatomic,readwrite)   NSInteger   opex_etc;
@property   (nonatomic,readwrite)   NSInteger   noi;
@property   (nonatomic,readwrite)   NSInteger   ads;
@property   (nonatomic,readwrite)   NSInteger   btcf;
@property   (nonatomic,readwrite)   NSInteger   initCost;
@property   (nonatomic,readwrite)   NSInteger   taxIncome;
@property   (nonatomic,readwrite)   NSInteger   amCost;
@property   (nonatomic,readwrite)   NSInteger   tax;
@property   (nonatomic,readwrite)   NSInteger   atcf;

@property   (nonatomic,readwrite)   CGFloat     fcr;
@property   (nonatomic,readwrite)   CGFloat     loanConst;
@property   (nonatomic,readwrite)   CGFloat     ccr;
@property   (nonatomic,readwrite)   CGFloat     pb;
@property   (nonatomic,readwrite)   CGFloat     dcr;
@property   (nonatomic,readwrite)   CGFloat     ber;
@property   (nonatomic,readwrite)   CGFloat     ltv;
@property   (nonatomic,readwrite)   CGFloat     capRate;

@property   (nonatomic,readwrite)   NSInteger   rentUnitPrice;
@property   (nonatomic,readwrite)   CGFloat     yieldNfc;
@property   (nonatomic,readwrite)   CGFloat     yieldAmo;

//======================================================================
@end
//======================================================================
