//
//  Expense.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/23.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//======================================================================
@interface Expense : NSObject
{
    NSInteger       _brokerCom;
    NSInteger       _stamp;
    NSInteger       _fireInsurance;
    NSInteger       _mortgageReg;
    NSInteger       _ownershipReg;
    NSInteger       _scrivener;
    NSInteger       _acquisitionTax;
    NSInteger       _sum;
}
- (id)initWithPrice:(NSInteger)price loanBorrow:(NSInteger)loanBorrow acquTax:(NSInteger)acquTax;

//======================================================================
@property   (nonatomic,readonly)    NSInteger   brokenCom;          //仲介手数料
@property   (nonatomic,readonly)    NSInteger   stamp;              //印紙税
@property   (nonatomic,readonly)    NSInteger   fireInsurance;      //火災保険料
@property   (nonatomic,readonly)    NSInteger   mortgageReg;        //登記
@property   (nonatomic,readonly)    NSInteger   ownershipReg;       //所有権
@property   (nonatomic,readonly)    NSInteger   scrivener;          //司法書士報酬
@property   (nonatomic,readonly)    NSInteger   acquisitionTax;     //不動産取得税
@property   (nonatomic,readonly)    NSInteger   sum;                //合計
//======================================================================
@end
//======================================================================
