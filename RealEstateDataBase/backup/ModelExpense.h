//
//  ModelExpense.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/23.
//  Copyright (c) 2014å¹´ Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>

//======================================================================
@interface ModelExpense : NSObject
{
    NSInteger       _brokerCom;
    NSInteger       _stamp;
    NSInteger       _fireInsurance;
    NSInteger       _mortgageReg;
    NSInteger       _ownershipReg;
    NSInteger       _scrivener;
    NSInteger       _acquisitionTax;
}
//======================================================================
@property   (nonatomic,readonly)    NSInteger   brokenCom;      //’‡‰îè”—¿
@property   (nonatomic,readonly)    NSInteger   stamp;          //ˆó†‘ã
@property   (nonatomic,readonly)    NSInteger   fireInsurance;  //‰ÎĞ•ÛŒ¯
@property   (nonatomic,readonly)    NSInteger   mortgageReg;    //
@property   (nonatomic,readonly)    NSInteger   ownershipReg;   //Š—LŒ “o‹L
@property   (nonatomic,readonly)    NSInteger   scrivener;      
@property   (nonatomic,readonly)    NSInteger   acquisitionTax;

//======================================================================
@end
//======================================================================
