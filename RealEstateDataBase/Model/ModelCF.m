//
//  ModelCF.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/04/04.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "ModelCF.h"
#import "GraphData.h"
#import "AddonMgr.h"

@interface ModelCF ()

@end
//======================================================================
@implementation ModelCF
//======================================================================
//
//======================================================================
+(void)setGraphData:(Graph*)gData ModelRE:(ModelRE*)modelRE
{
    AddonMgr *addonMgr = [AddonMgr sharedManager];
    
    CGFloat graphMin;
    CGFloat graphMax;

    Loan *loan = modelRE.investment.loan;
    
    NSInteger cfYear    = modelRE.holdingPeriodTermForOpe/12;
    NSInteger graphYear = cfYear+1;

    NSArray *arr_btcf       = [modelRE getBTCashFlowAccum:cfYear];
    NSArray *arr_atcf       = [modelRE getATCashFlowAccum:cfYear];
    NSArray *arr_loanTmp    = [loan getLbArrayYear];
    NSMutableArray *arr_loan = [[NSMutableArray alloc]init];

    
    for( int i=0; i<= graphYear; i++){
        if ( i == 0 ){
            [arr_loan addObject:[NSValue valueWithCGPoint:CGPointMake(0,loan.loanBorrow)]];
        } else {
            if ( addonMgr.saleAnalysys == true ){
                //保有期間の運営と最後は売却
                if ( i <= graphYear-1 ){
                    if ( i < [arr_loanTmp count] ){
                        [arr_loan addObject:[arr_loanTmp objectAtIndex:i-1]];
                    } else {
                        [arr_loan addObject:[NSValue valueWithCGPoint:CGPointMake(i,0)]];
                    }
                } else {
                    [arr_loan addObject:[NSValue valueWithCGPoint:CGPointMake(i,0)]];
                }
            } else {
                //保有期間の運営
                if ( i < [arr_loanTmp count] ){
                    [arr_loan addObject:[arr_loanTmp objectAtIndex:i-1]];
                } else {
                    [arr_loan addObject:[NSValue valueWithCGPoint:CGPointMake(i,0)]];
                }
            }
        }
    }
    
    GraphData *gd_btcf = [[GraphData alloc]initWithData:arr_btcf];
    gd_btcf.precedent   = @"累積CF(税引前)";
    gd_btcf.type        = LINE_GRAPH;
    
    GraphData *gd_atcf = [[GraphData alloc]initWithData:arr_atcf];
    gd_atcf.precedent   = @"累積CF(税引後)";
    gd_atcf.type        = LINE_GRAPH;
    
    GraphData *gd_loan = [[GraphData alloc]initWithData:arr_loan];
    gd_loan.precedent   = @"借入残高";
    gd_loan.type        = BAR_GPAPH;
    
    gData.GraphDataAll  = [[NSArray alloc]initWithObjects:gd_btcf,gd_atcf,gd_loan,nil];
    /*--------------------------------------*/
    if ( modelRE.btcfAccumMin < 0 ){
        graphMin = modelRE.btcfAccumMin*2;
    } else {
        graphMin = 0;
    }
    if ( modelRE.btcfAccumMax > loan.loanBorrow ){
        graphMax = modelRE.btcfAccumMax;
    } else {
        graphMax = loan.loanBorrow;
    }
    /*--------------------------------------*/
    [gData setGraphtMinMax_xmin:-1 ymin:graphMin xmax:graphYear+0.5 ymax:(graphMax)];
    return;
}

//======================================================================
@end
//======================================================================
