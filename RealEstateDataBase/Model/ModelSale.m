//
//  ModelSale.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/17.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "ModelSale.h"
#import "GraphData.h"
#import "OpeAll.h"

@implementation ModelSale

#define GRAPH_PERIOD    40
//======================================================================
//
//======================================================================
+(void) setGraphDataPrice:(Graph*)gData ModelRE:(ModelRE*)modelRE
{
    NSInteger graphMin = NSIntegerMax;
    NSInteger graphMax =  NSIntegerMin;
    CGPoint   minmax;

    NSInteger   period = GRAPH_PERIOD;
    NSArray *priceArr;
    
    CGFloat capRate;

    /****************************************/
    capRate = modelRE.ope1.capRate + 0.5/100;
    priceArr = [self getSalePriceArray_capRate:capRate period:period*12 modelRE:modelRE];
    minmax = [self calcMinMax:priceArr minmax:CGPointMake(graphMin, graphMax)];
    graphMin = minmax.x;
    graphMax = minmax.y;
    /*--------------------------------------*/
    GraphData *gd_05up      = [[GraphData alloc]initWithData:priceArr];
    gd_05up.precedent       = [NSString stringWithFormat:@"%2.1f%%",capRate*100];
    gd_05up.type            = LINE_GRAPH;
    
    /****************************************/
    capRate = modelRE.ope1.capRate;
    priceArr = [self getSalePriceArray_capRate:capRate period:period*12 modelRE:modelRE];
    minmax = [self calcMinMax:priceArr minmax:CGPointMake(graphMin, graphMax)];
    graphMin = minmax.x;
    graphMax = minmax.y;
    /*--------------------------------------*/
    GraphData *gd_ope1      = [[GraphData alloc]initWithData:priceArr];
    gd_ope1.precedent       = [NSString stringWithFormat:@"%2.1f%%(=初年度CP)",capRate*100];
    gd_ope1.type            = LINE_GRAPH;

    /****************************************/
    capRate = modelRE.ope1.capRate - 0.5/100;
    priceArr = [self getSalePriceArray_capRate:capRate period:period*12 modelRE:modelRE];
    minmax = [self calcMinMax:priceArr minmax:CGPointMake(graphMin, graphMax)];
    graphMin = minmax.x;
    graphMax = minmax.y;
    /*--------------------------------------*/
    GraphData *gd_05dn      = [[GraphData alloc]initWithData:priceArr];
    gd_05dn.precedent       = [NSString stringWithFormat:@"%2.1f%%",capRate*100];
    gd_05dn.type            = LINE_GRAPH;
    
    /****************************************/
    NSArray *holdingArr     = @[[NSValue valueWithCGPoint:CGPointMake(modelRE.holdingPeriodTerm/12, modelRE.sale.price)]];
    minmax = [self calcMinMax:holdingArr minmax:CGPointMake(graphMin, graphMax)];
    graphMin = minmax.x;
    graphMax = minmax.y;
    /*--------------------------------------*/
    GraphData *gd_holding   = [[GraphData alloc]initWithData:holdingArr];
    gd_holding.precedent    = [NSString stringWithFormat:@"%ld年保有,CAP=%2.1f%%",
                               (long)modelRE.holdingPeriodTerm/12,
                               ((CGFloat)modelRE.opeLast.noi*100/modelRE.sale.price)];
    gd_holding.type         = POINT_GRAPH;
    /****************************************/
    gData.GraphDataAll  = [[NSArray alloc]initWithObjects:gd_05up,gd_ope1,gd_05dn,gd_holding,nil];

    /*--------------------------------------*/
    [gData setGraphtMinMax_xmin:0 ymin:graphMin xmax:period+1 ymax:graphMax];
    
    return;
}
//======================================================================
//
//======================================================================
+(void) setGraphDataCapGain:(Graph*)gData ModelRE:(ModelRE*)modelRE
{
    NSInteger graphMin = NSIntegerMax;
    NSInteger graphMax =  NSIntegerMin;
    CGPoint   minmax;
    
    NSInteger   period = GRAPH_PERIOD;
    NSArray *cgArr;
    
    CGFloat capRate;
    
    /****************************************/
    capRate = modelRE.ope1.capRate + 0.5/100;
    cgArr = [self getAtCapGainArray_capRate:capRate period:period*12 modelRE:modelRE ];
    minmax = [self calcMinMax:cgArr minmax:CGPointMake(graphMin, graphMax)];
    graphMin = minmax.x;
    graphMax = minmax.y;
    /*--------------------------------------*/
    GraphData *gd_05up      = [[GraphData alloc]initWithData:cgArr];
    gd_05up.precedent       = [NSString stringWithFormat:@"%2.1f%%",capRate*100];
    gd_05up.type            = LINE_GRAPH;
    
    /****************************************/
    capRate = modelRE.ope1.capRate;
    cgArr = [self getAtCapGainArray_capRate:capRate period:period*12 modelRE:modelRE ];
    minmax = [self calcMinMax:cgArr minmax:CGPointMake(graphMin, graphMax)];
    graphMin = minmax.x;
    graphMax = minmax.y;
    /*--------------------------------------*/
    GraphData *gd_ope1      = [[GraphData alloc]initWithData:cgArr];
    gd_ope1.precedent       = [NSString stringWithFormat:@"%2.1f%%(=初年度CP)",capRate*100];
    gd_ope1.type            = LINE_GRAPH;
    
    /****************************************/
    capRate = modelRE.ope1.capRate - 0.5/100;
    cgArr = [self getAtCapGainArray_capRate:capRate period:period*12 modelRE:modelRE ];
    minmax = [self calcMinMax:cgArr minmax:CGPointMake(graphMin, graphMax)];
    graphMin = minmax.x;
    graphMax = minmax.y;
    /*--------------------------------------*/
    GraphData *gd_05dn      = [[GraphData alloc]initWithData:cgArr];
    gd_05dn.precedent       = [NSString stringWithFormat:@"%2.1f%%",capRate*100];
    gd_05dn.type            = LINE_GRAPH;
    
    /****************************************/
    NSArray *holdingArr     = @[[NSValue valueWithCGPoint:CGPointMake(modelRE.holdingPeriodTerm/12, modelRE.sale.atcf-modelRE.investment.equity)]];
    minmax = [self calcMinMax:holdingArr minmax:CGPointMake(graphMin, graphMax)];
    graphMin = minmax.x;
    graphMax = minmax.y;
    /*--------------------------------------*/
    GraphData *gd_holding   = [[GraphData alloc]initWithData:holdingArr];
    gd_holding.precedent    = [NSString stringWithFormat:@"%ld年保有,CAP=%2.1f%%",
                               (long)modelRE.holdingPeriodTerm/12,
                               ((CGFloat)modelRE.opeLast.noi*100/modelRE.sale.price)];
    gd_holding.type         = POINT_GRAPH;
    /****************************************/
    gData.GraphDataAll  = [[NSArray alloc]initWithObjects:gd_05up,gd_ope1,gd_05dn,gd_holding,nil];
    
    /*--------------------------------------*/
    [gData setGraphtMinMax_xmin:0 ymin:graphMin xmax:period+1 ymax:graphMax];
    
    return;
}
//======================================================================
//
//======================================================================
+(CGPoint) calcMinMax:(NSArray*)arr minmax:(CGPoint)minmax
{
    CGFloat min = minmax.x;
    CGFloat max = minmax.y;
    
    CGPoint tmpPoint;
    for(int i=0; i< [arr count]; i++){
        tmpPoint = [[arr objectAtIndex:i] CGPointValue];
        if ( min > tmpPoint.y ){
            min = tmpPoint.y;
        }
        if ( max < tmpPoint.y ){
            max = tmpPoint.y;
        }
    }
    
    return CGPointMake(min, max);
}

//======================================================================
// 指定したキャップレートでの[年数,売却価格]配列の取得
//======================================================================
+(NSArray*) getSalePriceArray_capRate:(CGFloat)capRate period:(NSInteger)period modelRE:(ModelRE*)modelRE
{
    NSMutableArray *priceArr = [NSMutableArray array];
    
    OpeAll *tmpOpeAll = [[OpeAll alloc]init];
    [tmpOpeAll calcOpeAll:period
               investment:modelRE.investment
                   estate:modelRE.estate
              declineRate:modelRE.declineRate];
    
    Operation   *tmpOpe;
    CGPoint     tmpPoint;
    NSInteger   tmpPrice;
    for(int i=0; i<period/12; i++){
        tmpOpe = [tmpOpeAll.opeArr objectAtIndex:i];
        tmpPrice = tmpOpe.noi / capRate;
        tmpPoint = CGPointMake(i+1, tmpPrice);
        [priceArr addObject:[NSValue valueWithCGPoint:tmpPoint]];
    }
    return priceArr;
}

//======================================================================
// 指定したキャップレートでの[年数,税引後CapGain]配列の取得
//======================================================================
+(NSArray*) getAtCapGainArray_capRate:(CGFloat)capRate period:(NSInteger)period modelRE:(ModelRE*)modelRE
{
    NSMutableArray *cfArr = [NSMutableArray array];
    
    OpeAll *tmpOpeAll = [[OpeAll alloc]init];
    [tmpOpeAll calcOpeAll:period
               investment:modelRE.investment
                   estate:modelRE.estate
              declineRate:modelRE.declineRate];
    
    Sale *tmpSale       = [[Sale alloc]init];
    Operation   *tmpOpe;
    CGPoint     tmpPoint;
    for(int i=0; i<period/12; i++){
        tmpOpe = [tmpOpeAll.opeArr objectAtIndex:i];
        tmpSale.price       = tmpOpe.noi / capRate;
        tmpSale.expense     = tmpSale.price * 0.04;
        [tmpSale calcSale:modelRE.investment holdingPeriod:i+1 estate:modelRE.estate];
        tmpPoint = CGPointMake(i+1, tmpSale.atcf - modelRE.investment.equity);
        [cfArr addObject:[NSValue valueWithCGPoint:tmpPoint]];
    }
    return cfArr;
    
}

//======================================================================
@end
//======================================================================
