//
//  Prices.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/****************************************************************/
@interface Prices : NSObject
{
    NSInteger   _price;
    NSInteger   _gpi;
    CGFloat     _interest;
}
/****************************************************************/
- (id) initWithPrice:(NSInteger)price gpi:(NSInteger)gpi;
/****************************************************************/
@property   (nonatomic,readwrite)   NSInteger       price;
@property   (nonatomic,readwrite)   NSInteger       gpi;
@property   (nonatomic,readonly)    CGFloat         interest;
/****************************************************************/
@end
/****************************************************************/