//
//  House.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
//======================================================================
@interface House : NSObject
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

    NSString                *_name;             //建物名
    NSInteger               _price;
    NSInteger               _priceBook;         //帳簿上の価格
    CGFloat                 _area;
    NSInteger               _construct;         //建物構造
    NSInteger               _rooms;             //部屋数
    CGFloat                 _equipRatio;        //設備割合
    NSInteger               _buildTerm;         //建築ターム
    NSInteger               _acquisitionTerm;   //取得ターム
    NSInteger               _improvementCosts;  //改良費
    NSInteger               _valutation;        //評価額
    
    
}
//======================================================================
+ (NSString*)constructStr:(NSInteger)constructNo;
+ (NSInteger)usefulLifeYear:(NSInteger)constructNo;             //耐用年数取得
- (NSInteger)getAmortizationCosts_term:(NSInteger)term;         //減価償却費
- (NSInteger)getAmortizationCostsSum_period:(NSInteger)period;
- (NSInteger)getReplacementCostValue;                           //再調達原価
- (NSInteger)getAcquTax;                                        //不動産取得税
- (NSInteger)getPropTax_term:(NSInteger)term;                   //固都税
- (NSInteger)getValuation_term:(NSInteger)term;
//======================================================================
@property   (nonatomic)             NSString        *name;
@property   (nonatomic)             NSInteger       price;
@property   (nonatomic)             NSInteger       priceBook;
@property   (nonatomic)             CGFloat         area;
@property   (nonatomic)             NSInteger       construct;          //建物構造
@property   (nonatomic)             NSInteger       rooms;              //戸数
@property   (nonatomic)             CGFloat         equipRatio;         //設備割合
@property   (nonatomic,readwrite)   NSInteger       buildTerm;          //建築ターム
@property   (nonatomic,readwrite)   NSInteger       acquisitionTerm;
@property   (nonatomic,readwrite)   NSInteger       improvementCosts;
@property   (nonatomic,readonly)    NSInteger       valuation;          //固定資産税評価額

//-------------
// 国税庁HP
// https://www.keisan.nta.go.jp/survey/publish/34255/faq/34311/faq_34354.php
//-------------

//======================================================================
@end
//======================================================================

