//
//  Investment.h
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Loan.h"
#import "Operation.h"

//======================================================================
@interface Investment : NSObject
{
    NSInteger       _price;
    NSInteger       _gpi;
    CGFloat         _interest;
    Loan            *_loan;             //ローン

    CGFloat         _emptyRate;         //空室率
    CGFloat         _mngRate;           //運営費率
    CGFloat         _propTaxRate;       //固定資産税率
    CGFloat         _incomeTaxRate;     //所得税率
    NSInteger       _equity;            //自己資金
    NSInteger       _expense;           //諸経費
    NSInteger       _opexEtc;           //その他の運営費
    NSInteger       _bootMonth;         //立ち上げ期間
    NSArray         *_bootEmpty;
    BOOL            _isCompany;         //法人
}
//======================================================================
-(id) initWithPrice:(NSInteger)price gpi:(NSInteger)gpi;
-(Operation*) getOperation_year:(NSInteger)year
                             gpi:(NSInteger)gpi
                            loan:(Loan*)loan
                         propTax:(NSInteger)propTax
               amortizationCosts:(NSInteger)amortizationCosts
                      house_area:(CGFloat)houseArea;

-(Operation*) getOperation_start_term:(NSInteger)start_term
                          new_gpi_term:(NSInteger)new_gpi_term
                              end_term:(NSInteger)end_term
                          aqu_tax_term:(NSInteger)aqu_tax_term
                              prop_tax:(NSInteger)propTax
                               acqu_tax:(NSInteger)acquTax
                                  gpi1:(NSInteger)gpi1
                                  gpi2:(NSInteger)gpi2
                                  loan:(Loan*)loan
                     amortizationCosts:(NSInteger)amortizationCosts;

-(void) adjustEquity;
-(void) adjustLoanBorrow;
//======================================================================
@property   (nonatomic,readwrite)   NSInteger       price;
@property   (nonatomic,readwrite)   NSInteger       gpi;
@property   (nonatomic,readonly)    CGFloat         interest;
@property   (nonatomic)             Loan            *loan;
@property   (nonatomic)             CGFloat         mngRate;
@property   (nonatomic)             CGFloat         propTaxRate;
@property   (nonatomic)             CGFloat         incomeTaxRate;
@property   (nonatomic)             NSInteger       equity;
@property   (nonatomic)             NSInteger       expense;
@property   (nonatomic)             CGFloat         emptyRate;
@property   (nonatomic)             NSInteger       opexEtc;
@property   (nonatomic)             NSInteger       bootMonth;
@property   (nonatomic)             NSArray         *bootEmpty;
@property   (nonatomic)             BOOL            isCompany;

//======================================================================
@end
//======================================================================
