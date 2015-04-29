//
//  Land.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
/****************************************************************/
@interface Land : Item
{
    NSString    *_address;
    CGFloat     _assessment;
    NSInteger   _valuation;
}
/****************************************************************/
/****************************************************************/
@property   (nonatomic,readwrite) NSString    *address;
@property   (nonatomic,readwrite) CGFloat     assessment;
@property   (nonatomic,readwrite) NSInteger   price;
@property   (nonatomic,readonly)  NSInteger   valuation;
/****************************************************************/
@end
/****************************************************************/
