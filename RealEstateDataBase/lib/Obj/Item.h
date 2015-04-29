//
//  Item.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/21.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/****************************************************************/
@interface Item : NSObject
{
    NSInteger   _price;
    CGFloat     _area;
}
/****************************************************************/
/****************************************************************/
@property   (nonatomic) NSInteger   price;
@property   (nonatomic) CGFloat     area;
/****************************************************************/
@end
/****************************************************************/