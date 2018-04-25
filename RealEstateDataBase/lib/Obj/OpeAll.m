//
//  OpeAll.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/16.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "OpeAll.h"
#import "UIUtil.h"
@implementation OpeAll

//======================================================================
@synthesize opeArr              = _opeArr;
@synthesize ope1                = _ope1;
@synthesize opeLast             = _opeLast;
@synthesize btcf                = _btcf;
@synthesize atcf                = _atcf;
//======================================================================
//
//======================================================================
-(void) calcOpeAll:(NSInteger)holdingTerm
         investment:(Investment*)investment
             estate:(Estate*)estate
        declineRate:(CGFloat)declineRate
{
    [estate calcBookPrice];
    //--------------------------------------------
    // OpeAll
    NSInteger tmpGpi1       = investment.gpi;
    NSInteger tmpGpi2       = tmpGpi1 * (1 - declineRate);
    NSInteger start_term    = 0;
    NSInteger propTax       = 0;
    NSInteger acquTax       = [estate getAcquTax];
    NSInteger end_term      = 12 - [UIUtil getMonth_term:estate.house.acquisitionTerm];
    NSInteger last_term     = holdingTerm -1;
    if ( last_term < end_term ){
        //保有期間が短く、初年度以内に売却してしまう場合
        end_term = last_term;
    }
    NSInteger new_gpi_term  = start_term + 12;
    
    NSMutableArray  *opeAll = [NSMutableArray array];
    NSInteger   btcf = 0;
    NSInteger   atcf = 0;

    while (1) {
        NSInteger amCost = 0;
        for(NSInteger term=start_term; term<=end_term; term++){
            amCost = amCost + [estate.house getAmortizationCosts_term:term];
        }
        
        Operation *ope = [investment getOperation_start_term:start_term
                                                new_gpi_term:new_gpi_term
                                                    end_term:end_term
                                                aqu_tax_term:6              //６ヶ月後
                                                    prop_tax:propTax
                                                    acqu_tax:acquTax
                                                         gpi1:tmpGpi1
                                                         gpi2:tmpGpi2
                                                        loan:investment.loan
                                           amortizationCosts:amCost];
        [opeAll addObject:ope];
        btcf = btcf + ope.btcf;
        atcf = atcf + ope.atcf;
        if ( end_term >= last_term ){
            break;
        }
        //次の年(ループ)の設定
        start_term      = end_term + 1;
        end_term        = start_term + 11;
        if ( end_term > last_term ){
            end_term = last_term;
        }
        if ( end_term < new_gpi_term ){
            //前回のGPI更新Termに到達していない場合
            //前回のループ時のGPIを継続
            //基本的に1年目だけここに入る
        } else {
            if ( new_gpi_term < start_term ){
                new_gpi_term    = new_gpi_term + 12;
            }
            tmpGpi1 = tmpGpi2;
            tmpGpi2 = tmpGpi1 * (1 - declineRate);
        }
        
        propTax        = [estate getPropTax_term:start_term];
    }
    _btcf   = btcf;
    _atcf   = atcf;
    _opeArr = opeAll;

    //--------------------------------------------
    // Ope1
    propTax        = [estate getPropTax_term:1];
    
    NSInteger amCost1 = 0;
    for(NSInteger term=0;term<12; term++){
        amCost1 = amCost1 + [estate.house getAmortizationCosts_term:term];
    }
    _ope1 = [investment getOperation_year:1
                                      gpi:investment.gpi
                                     loan:investment.loan
                                 propTax:propTax
                        amortizationCosts:amCost1
                               house_area:estate.house.area];
    return;
}
//======================================================================
@end
//======================================================================
