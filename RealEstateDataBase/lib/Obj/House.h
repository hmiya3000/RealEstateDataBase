//
//  House.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"
/****************************************************************/
/****************************************************************/
@interface House : Item
{
    enum CONSTRUCT{
        CONST_NONE      = 0,   //未定義・不明
        CONST_WOOD      = 1,   //木造(22年)
        CONST_LSTEEL    = 2,   //軽量鉄骨造(27年)
        CONST_STEEL     = 3,   //重量鉄骨造(34年)
        CONST_RC        = 4,   //鉄筋コンクリート造(47年)
        CONST_SRC       = 5,  //鉄骨鉄筋コンクリート造(47年)
        CONST_MAX       = 6,
    };

    NSString        *_name;
    int             _construct;
    NSInteger       _rooms;
    NSInteger       _buildYear;
    NSInteger       _valutation;
}
/****************************************************************/
+ (NSString*) constructStr:(NSInteger)constructNo;
+ (NSInteger) amortizationPeriod:(NSInteger)constructNo;
- (NSInteger) getAmortizationCosts_aquYear:(NSInteger)aquYear term:(NSInteger)term;
/****************************************************************/
@property   (nonatomic) NSString        *name;
@property   (nonatomic) int             construct;
@property   (nonatomic) NSInteger       rooms;
@property   (nonatomic) NSInteger       buildYear;
@property   (nonatomic,readonly)    NSInteger   valuation;
/****************************************************************
 国税庁HP
 https://www.keisan.nta.go.jp/survey/publish/34255/faq/34311/faq_34354.php
 ****************************************************************/
/****************************************************************/
@end
/****************************************************************/
