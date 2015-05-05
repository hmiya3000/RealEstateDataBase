//
//  ModelRE.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/18.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "ModelRE.h"
#import "ModelDB.h"
#import "UIUtil.h"
#import "SettingLoan.h"
#import "Finance.h"
#import "Operation.h"
#import "AddonMgr.h"

@implementation ModelRE
{
    NSString            *_serial;
    NSString            *_name;

    NSInteger           _priceAquisition;
    NSInteger           _tmpCfAccumMin;
    NSInteger           _tmpCfAccumMax;
    
    AddonMgr            *_addonMgr;
    
}
/****************************************************************/
static ModelRE* sharedModelRE = nil;
/****************************************************************/
@synthesize investment          = _investment;
@synthesize estate              = _estate;
@synthesize loanName            = _loanName;
@synthesize ope1                = _ope1;
@synthesize opeLast             = _opeLast;

@synthesize yearAquisition      = _yearAquisition;
@synthesize declineRate         = _declineRate;
@synthesize holdingPeriod       = _holdingPeriod;
@synthesize discountRate        = _discountRate;
@synthesize npv                 = _npv;
@synthesize irr                 = _irr;

@synthesize improvementCosts    = _improvementCosts;
@synthesize priceSales          = _priceSales;
@synthesize transferExpense     = _transferExpense;
@synthesize transferIncome      = _transferIncome;
@synthesize lbSales             = _lbSales;
@synthesize btcfSales           = _btcfSales;
@synthesize amCosts             = _amCosts;
@synthesize transferTax         = _transferTax;
@synthesize atcfSales           = _atcfSales;

@synthesize btcfOpeAll          = _btcfOpeAll;
@synthesize atcfOpeAll          = _atcfOpeAll;
@synthesize btcfTotal           = _btcfTotal;
@synthesize atcfTotal           = _atcfTotal;

@synthesize btcfAccumMin        = _btcfAccumMin;
@synthesize btcfAccumMax        = _btcfAccumMax;
@synthesize atcfAccumMin        = _atcfAccumMin;
@synthesize atcfAccumMax        = _atcfAccumMax;
/****************************************************************
 *
 ****************************************************************/
+(ModelRE*)sharedManager
{
    @synchronized(self){
        if (sharedModelRE == nil ){
            sharedModelRE = [[self alloc ]init ];
        }
    }
    return sharedModelRE;
}
/****************************************************************
 *
 ****************************************************************/
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if ( sharedModelRE == nil){
            sharedModelRE  = [super allocWithZone:zone];
            return sharedModelRE;
        }
    }
    return nil;
}
/****************************************************************
 *
 ****************************************************************/
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}
/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self) {
        [self setDefaultItem:@"未選択"];
        _addonMgr = [AddonMgr sharedManager];
    }
    return self;
}
/****************************************************************
 * データの再計算
 ****************************************************************/
- (void) calcAll
{
    NSArray *opeN = [self calcOperationAll:_holdingPeriod];
    
    _ope1       = [opeN objectAtIndex:0];
    _opeLast    = [opeN objectAtIndex:_holdingPeriod-1];
    
    /*--------------------------------------*/
    if ( _ope1.btcf == 0 || _investment.equity == 0 ){
        /* 未設定の場合には計算しない */
        _npv    = 0;
        _irr    = 0;
    } else {
        NSMutableArray *arr = [NSMutableArray array];
        NSNumber *num_btcf;
        NSInteger tmpGpi = _investment.prices.gpi;
        for( int i=0; i< _holdingPeriod; i ++){
            Operation *tmpOpe = [_investment getOperation:i+1 gpi:tmpGpi loan:_investment.loan amortizationCosts:[_estate.house getAmortizationCosts_aquYear:_yearAquisition term:i+1]];
            num_btcf = [NSNumber numberWithFloat:tmpOpe.btcf];
            [arr addObject:num_btcf];
            tmpGpi = tmpGpi * (1 - _declineRate);
        }
        _npv = [Finance npv_rate:_discountRate array:arr ] - _investment.equity;
        /*--------------------------------------*/
        num_btcf = [NSNumber numberWithFloat:- _investment.equity];
        [arr insertObject:num_btcf atIndex:0];
        _irr = [Finance irr_array:arr];
    }
    /*--------------------------------------*/
    _lbSales                = [_investment.loan getLbYear:_holdingPeriod];
    _btcfSales              = _priceSales - _transferExpense - _lbSales;
    NSInteger amCosts = 0;
    for(int i=0; i< _holdingPeriod; i++){
        amCosts = amCosts + [_estate.house getAmortizationCosts_aquYear:_yearAquisition term:i+1];
    }
    _amCosts = amCosts;
    _priceAquisition        = _investment.prices.price + _investment.expense + _improvementCosts - amCosts;
    _transferIncome         = _priceSales - _priceAquisition -_transferExpense;
    
    
    NSInteger incomeTax;
    NSInteger regidentTax;
    NSInteger incomeTaxSp;
    if ( _transferIncome > 0 ){
        if ( _holdingPeriod > 5 ){
            incomeTax       = _transferIncome * 0.15;
            regidentTax     = _transferIncome * 0.05;
            incomeTaxSp     = incomeTax * 0.021;
        } else {
            incomeTax       = _transferIncome * 0.30;
            regidentTax     = _transferIncome * 0.09;
            incomeTaxSp     = incomeTax * 0.021;
        }
    } else {
        incomeTax           = 0;
        regidentTax         = 0;
        incomeTaxSp         = 0;
    }
    _transferTax = incomeTax + regidentTax + incomeTaxSp;
    _atcfSales = _btcfSales  - _transferTax;
    
    
    _btcfTotal  = _btcfSales + _btcfOpeAll;
    _atcfTotal  = _atcfSales + _atcfOpeAll;
}

/****************************************************************
 * 年ごとの運営状況を表形式で取得
 ****************************************************************/
- (NSArray*) getOperationArray
{
    NSInteger   tmpHoldingPeriod;
    
    if ( _addonMgr.multiYear == true ){
        tmpHoldingPeriod = _holdingPeriod;
    } else {
        tmpHoldingPeriod = 1;
    }
    
    NSMutableArray *opeArrAll = [NSMutableArray array];
    NSArray *item = [NSArray arrayWithObjects:@"年数",@"潜在総収入(GPI)",@"空室損",@"実効総収入(EGI)",@"運営費(OPEx)",@"営業利益(NOI)",@"負債支払額(ADS)",@"税引前CF",@"所得税等",@"税引後CF",@"累積税引前CF",@"累積税引後CF",nil];
    [opeArrAll addObject:item];

    NSInteger btcfSum = 0;
    NSInteger atcfSum = 0;
    
    NSArray *opeN = [self calcOperationAll:_holdingPeriod];
    Operation *ope;
    
    for(int i=0; i<tmpHoldingPeriod; i++){
        ope = [opeN objectAtIndex:i];
        
        NSMutableArray *opeArr = [NSMutableArray array];
        [opeArr addObject:[NSString stringWithFormat:@"%d年目",i+1]];
        [opeArr addObject:[UIUtil yenValue:ope.gpi]];
        [opeArr addObject:[UIUtil yenValue:- ope.emptyLoss]];
        [opeArr addObject:[UIUtil yenValue:ope.egi]];
        [opeArr addObject:[UIUtil yenValue:- ope.opex]];
        [opeArr addObject:[UIUtil yenValue:ope.noi]];
        [opeArr addObject:[UIUtil yenValue:- ope.ads]];
        [opeArr addObject:[UIUtil yenValue:ope.btcf]];
        [opeArr addObject:[UIUtil yenValue:- ope.tax]];
        [opeArr addObject:[UIUtil yenValue:ope.atcf]];
        btcfSum = btcfSum+ ope.btcf;
        [opeArr addObject:[UIUtil yenValue:btcfSum]];
        atcfSum = atcfSum+ ope.atcf;
        [opeArr addObject:[UIUtil yenValue:atcfSum]];
        [opeArrAll addObject:opeArr];
    }
    return opeArrAll;
}
/****************************************************************
 * 累積キャッシュフローを座標配列で取得
 ****************************************************************/
#define BTCF    1
#define ATCF    2

- (NSArray*) getBTCashFlowAccum
{
    NSArray *retArr;
    
    retArr = [self getCashFlowAccum:BTCF];
    _btcfAccumMin = _tmpCfAccumMin;
    _btcfAccumMax = _tmpCfAccumMax;
    
    return retArr;
    
}

/****************************************************************
 * 累積キャッシュフローを座標配列で取得
 ****************************************************************/
- (NSArray*) getATCashFlowAccum
{
    NSArray *retArr;

    retArr = [self getCashFlowAccum:ATCF];
    _btcfAccumMin = _tmpCfAccumMin;
    _btcfAccumMax = _tmpCfAccumMax;

    return retArr;
}

/****************************************************************
 * 累積キャッシュフローを座標配列で取得
 ****************************************************************/
- (NSArray*) getCashFlowAccum:(NSInteger)mode
{
    NSMutableArray *cfArr = [NSMutableArray array];
    
    CGPoint tmpPoint;
    NSInteger cfSum = 0;
    NSInteger cfSumMin;
    NSInteger cfSumMax;
    
    /* 0年目は自己資金 */
    cfSum = - _investment.equity;
    cfSumMin = cfSumMax = cfSum;
    

    tmpPoint = CGPointMake(0, cfSum );
    [cfArr addObject:[NSValue valueWithCGPoint:tmpPoint]];

    /* 運営データを取得 */
    NSArray *opeN = [self calcOperationAll:_holdingPeriod];
    Operation *tmpOpe;
    
    for ( int year = 1; year <= _holdingPeriod; year++){
        tmpOpe = [opeN objectAtIndex:year-1];

        if ( mode == BTCF ){
            cfSum = cfSum + tmpOpe.btcf;
        } else {
            cfSum = cfSum + tmpOpe.atcf;
        }
        /* 最大値・最小値を更新 */
        if ( cfSumMax < cfSum ){
            cfSumMax = cfSum;
        }
        if ( cfSumMin > cfSum ){
            cfSumMin = cfSum;
        }
        /* 配列に追加 */
        tmpPoint = CGPointMake(year, cfSum);
        [cfArr addObject:[NSValue valueWithCGPoint:tmpPoint]];
    }

    if ( mode == BTCF ){
        cfSum = cfSum + _btcfSales;
    } else {
        cfSum = cfSum + _atcfSales;
    }
    /* 最大値・最小値を更新 */
    if ( cfSumMax < cfSum ){
        cfSumMax = cfSum;
    }
    if ( cfSumMin > cfSum ){
        cfSumMin = cfSum;
    }
    
    tmpPoint = CGPointMake(_holdingPeriod+1, cfSum);
    [cfArr addObject:[NSValue valueWithCGPoint:tmpPoint]];

    _tmpCfAccumMax  = cfSumMax;
    _tmpCfAccumMin  = cfSumMin;
    return cfArr;
}

/****************************************************************
 *
 ****************************************************************/
- (NSArray*) getNpvArray
{
    NSMutableArray *arr = [NSMutableArray array];

    NSMutableArray *npvArr = [NSMutableArray array];
    CGFloat discountRate = 0.05;
    CGFloat npv;
    CGPoint tmpPoint;

    tmpPoint = CGPointMake(0, -_investment.equity);
    [npvArr addObject:[NSValue valueWithCGPoint:tmpPoint]];
    
    CGFloat capRateSales = _ope1.capRate + 0.005;
    NSInteger tmpBtcfOpe;
    NSInteger tmpBtcfSales;
    
    NSInteger tmpGpi = _investment.prices.gpi;
    for(int holdingPeriod=1; holdingPeriod<=20; holdingPeriod++){
        /*--------------------------------------*/
        Operation *tmpOpe = [_investment getOperation:holdingPeriod gpi:tmpGpi loan:_investment.loan amortizationCosts:[_estate.house getAmortizationCosts_aquYear:_yearAquisition term:holdingPeriod]];
        tmpBtcfOpe = tmpOpe.btcf;
        tmpBtcfSales = tmpOpe.noi / capRateSales - _transferExpense - [_investment.loan getLbYear:holdingPeriod];
        [arr addObject:[NSNumber numberWithInteger:(tmpBtcfOpe+tmpBtcfSales)]];
        /*--------------------------------------*/
        npv = [Finance npv_rate:discountRate array:arr ] - _investment.equity;
        /*--------------------------------------*/
        tmpPoint = CGPointMake(holdingPeriod, npv);
        [npvArr addObject:[NSValue valueWithCGPoint:tmpPoint]];
        /*--------------------------------------*/
        [arr removeObjectAtIndex:holdingPeriod-1];
        [arr addObject:[NSNumber numberWithInteger:tmpBtcfOpe]];
        /*--------------------------------------*/
//        NSLog(@"%d %f",holdingPeriod, npv);
    }
    
    return npvArr;
}

/****************************************************************
 *
 ****************************************************************/
- (NSArray*) getIrrArray
{
    NSMutableArray *arr = [NSMutableArray array];
    
    NSMutableArray *irrArr = [NSMutableArray array];
    CGFloat irr;
    CGPoint tmpPoint;
    
    tmpPoint = CGPointMake(0, -100);
    [irrArr addObject:[NSValue valueWithCGPoint:tmpPoint]];
    
    CGFloat capRateSales = _ope1.capRate + 0.005;
    NSInteger tmpBtcfOpe;
    NSInteger tmpBtcfSales;
    
    NSInteger tmpGpi = _investment.prices.gpi;
    [arr addObject:[NSNumber numberWithFloat:- _investment.equity]];

    for(int holdingPeriod=1; holdingPeriod<=20; holdingPeriod++){
        /*--------------------------------------*/
        Operation *tmpOpe = [_investment getOperation:holdingPeriod gpi:tmpGpi loan:_investment.loan amortizationCosts:[_estate.house getAmortizationCosts_aquYear:_yearAquisition term:holdingPeriod]];
        tmpBtcfOpe = tmpOpe.btcf;
        tmpBtcfSales = tmpOpe.noi / capRateSales - _transferExpense - [_investment.loan getLbYear:holdingPeriod];
        [arr addObject:[NSNumber numberWithInteger:(tmpBtcfOpe+tmpBtcfSales)]];
        /*--------------------------------------*/
        irr = [Finance irr_array:arr ]*100;
        /*--------------------------------------*/
        tmpPoint = CGPointMake(holdingPeriod, irr);
        [irrArr addObject:[NSValue valueWithCGPoint:tmpPoint]];
        /*--------------------------------------*/
        [arr removeObjectAtIndex:holdingPeriod];
        [arr addObject:[NSNumber numberWithInteger:tmpBtcfOpe]];
        /*--------------------------------------*/
        NSLog(@"%d %f",holdingPeriod, irr);
    }
    
    return irrArr;
}

/****************************************************************
 *
 ****************************************************************/
- (void) valToFile
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",_serial]];
    
    NSDictionary    *settings = [self valToDic];

    //保存する
    [settings writeToFile:plistFilePath atomically:YES];

    if ( [_estate.name isEqualToString:_name] == false ){
        _name = _estate.name;
        ModelDB *db = [ModelDB sharedManager];
        [db updateSerial:_serial name:_name];
    }
}

/****************************************************************
 *
 ****************************************************************/
- (void) fileToVal:(NSString*)serial name:(NSString*)name
{
    _name   = name;
    _serial = serial;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",serial]];

    
    if ( [self isExistDataFile:plistFilePath] == true){
        NSLog(@"ロード...%@.plist",serial);
        NSMutableDictionary *settings;
        settings  = [NSMutableDictionary dictionaryWithContentsOfFile:plistFilePath];
        [self dicToVal:settings name:name];
    } else {
        NSLog(@"ファイル作成...%@.plist",serial);
        [self setDefaultItem:name];
        NSDictionary *settings = [self valToDic];
        [settings writeToFile:plistFilePath atomically:YES];
    }

}
/****************************************************************
 *
 ****************************************************************/
- (void)setDefaultItem:(NSString*)name
{
    SettingLoan *tmploan = [SettingLoan sharedManager];
    /*--------------------------------------*/
    _loanName                       = [tmploan.name0 copy];
    /*--------------------------------------*/
    _investment = [[Investment alloc]init];
    _investment.prices = [[Prices alloc]initWithPrice:5000*10000
                                                  gpi:5000*10000*0.08];
    _investment.equity              = 1350 * 10000;
    _investment.expense             = 350 * 10000;
    NSInteger lb;
    lb = _investment.prices.price + _investment.expense - _investment.equity;
    [tmploan setLoanBorrows:lb];
    
    _investment.loan.loanBorrow     =   4000*10000;
    _investment.loan.rateYear       =   0.02;
    _investment.loan.periodYear     =   30;
    _investment.loan.levelPayment   =   tmploan.loan0.levelPayment;
    /*--------------------------------------*/
    _investment.emptyRate           = 0.10;
    _investment.mngRate             = 0.05;
    _investment.propTaxRate         = 0.014;
    _investment.incomeTaxRate       = 0.3;
    /*--------------------------------------*/
    _estate                 = [[Estate alloc]init];
    _estate.prices          = _investment.prices;

    _estate.land.area       = 100.0;
    _estate.land.address    = [NSString stringWithFormat:@"千代田区銀座1-1-1"];
    _estate.land.assessment = 125;
    _estate.house.rooms     = 8;
    _estate.house.area      = 100.00;
    _estate.house.buildYear = [UIUtil getThisYear];
    _estate.house.construct = CONST_WOOD;
    [_estate setLandPrice:2500 *10000];
    _estate.name            = name;
 
    _yearAquisition         = [UIUtil getThisYear];
    _declineRate            = 0.01;
    
    _holdingPeriod          = 10;
    _priceSales             = 4500*10000;
    _transferExpense        = 180*10000;
    
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void) deleteItem:(NSString*)serial
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    NSString *reFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",serial]];
    BOOL result = [fileManager removeItemAtPath:reFilePath error:&error];

    if (result) {
        NSLog(@"ファイル削除...%@.plist",serial);
    } else {
        NSLog(@"削除失敗：%@", error.description);
    }

    return;
}

/****************************************************************
 * データファイルの有無確認
 ****************************************************************/
- (BOOL)isExistDataFile:(NSString*)plistFilePath
{
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:plistFilePath];
    
}
/****************************************************************
 *
 ****************************************************************/
- (NSString*) getString:(NSString*)key
{
    NSString *str;
    
    if ( [key isEqualToString:@"物件名"]){
        str = [NSString stringWithFormat:@"%@",_estate.name];
    } else if ( [key isEqualToString:@"物件価格"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_estate.prices.price/10000]];
    } else if ( [key isEqualToString:@"表面利回り"]){
        str = [NSString stringWithFormat:@"%2.2f%%",_estate.prices.interest*100];
    } else if ( [key isEqualToString:@"諸費用"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_investment.expense/10000]];
    } else if ( [key isEqualToString:@"自己資金"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_investment.equity/10000]];
        /****************************************/
    } else if ( [key isEqualToString:@"借入金"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_investment.loan.loanBorrow/10000]];
    } else if ( [key isEqualToString:@"金利"]){
        str = [NSString stringWithFormat:@"%g%%",_investment.loan.rateYear*100];
    } else if ( [key isEqualToString:@"借入期間"]){
        str = [NSString stringWithFormat:@"%ld年",(long)_investment.loan.periodYear];
        /****************************************/
    } else if ( [key isEqualToString:@"土地価格"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_estate.land.price/10000]];
    } else if ( [key isEqualToString:@"建物価格"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_estate.house.price/10000]];
    } else if ( [key isEqualToString:@"建築年"]){
        str = [NSString stringWithFormat:@"%ld年",(long)_estate.house.buildYear];
    } else if ( [key isEqualToString:@"路線価"]){
        str = [NSString stringWithFormat:@"%@千円/㎡",[UIUtil yenValue:_estate.land.assessment]];
    } else if ( [key isEqualToString:@"土地面積"]){
        str = [NSString stringWithFormat:@"%g㎡",_estate.land.area];
        /****************************************/
    } else if ( [key isEqualToString:@"床面積"]){
        str = [NSString stringWithFormat:@"%g㎡",_estate.house.area];
    } else if ( [key isEqualToString:@"住所"]){
        str = [NSString stringWithFormat:@"%@",_estate.land.address];
    } else if ( [key isEqualToString:@"構造"]){
        str = [House constructStr:_estate.house.construct];
    } else if ( [key isEqualToString:@"戸数"]){
        str = [NSString stringWithFormat:@"%d戸",(int)_estate.house.rooms];
        /****************************************/
    } else if ( [key isEqualToString:@"取得年"]){
        str = [NSString stringWithFormat:@"%ld年",(long)_yearAquisition];
    } else if ( [key isEqualToString:@"家賃下落率"]){
        str = [NSString stringWithFormat:@"%2.2f%%",_declineRate*100];
    } else if ( [key isEqualToString:@"空室率"]){
        str = [NSString stringWithFormat:@"%2.2f%%",_investment.emptyRate*100];
    } else if ( [key isEqualToString:@"管理費割合"]){
        str = [NSString stringWithFormat:@"%2.2f%%",_investment.mngRate*100];
    } else if ( [key isEqualToString:@"所得税・住民税"]){
        str = [NSString stringWithFormat:@"%2.1f%%",_investment.incomeTaxRate*100];
        /****************************************/
    } else if ( [key isEqualToString:@"保有期間"]){
        str = [NSString stringWithFormat:@"%ld年",(long)_holdingPeriod];
    } else if ( [key isEqualToString:@"売却価格"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_priceSales/10000]];
    } else if ( [key isEqualToString:@"改良費"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_improvementCosts/10000]];
    } else if ( [key isEqualToString:@"譲渡費用"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_transferExpense/10000]];
        /****************************************/
    } else {
        str = @"";
    }
    return str;
           
}


/****************************************************************
 *
 ****************************************************************/
- (void) dicToVal:(NSDictionary*)settings name:(NSString*)name
{
    /*--------------------------------------*/
    _investment.equity      = [[settings objectForKey:@"自己資金"] integerValue];
    _investment.expense     = [[settings objectForKey:@"諸費用"] integerValue];
    /*--------------------------------------*/
    _investment.prices.price    = [[settings objectForKey:@"物件価格"] integerValue];
    _investment.prices.gpi  =[[settings objectForKey:@"GPI"] floatValue];
    /*--------------------------------------*/
    _investment.loan.loanBorrow =[[settings objectForKey:@"借入金"] integerValue];
    _investment.loan.rateYear   =[[settings objectForKey:@"金利"] floatValue];
    _investment.loan.periodYear =[[settings objectForKey:@"借入期間"] integerValue];
    /*--------------------------------------*/
    _estate.name            = name;
    _estate.prices.price    = [[settings objectForKey:@"物件価格"] integerValue];
    _estate.prices.gpi      = [[settings objectForKey:@"GPI"] floatValue];
    /*--------------------------------------*/
    _estate.land.price      = [[settings objectForKey:@"土地価格"] integerValue];
    _estate.land.area       = [[settings objectForKey:@"土地面積"] floatValue];
    _estate.land.address    = [settings objectForKey:@"住所"];
    _estate.land.assessment = [[settings objectForKey:@"路線価"] integerValue];
    /*--------------------------------------*/
    _estate.house.price     = [[settings objectForKey:@"建物価格"] integerValue];
    _estate.house.area      = [[settings objectForKey:@"床面積"] floatValue];
    _estate.house.rooms     = [[settings objectForKey:@"戸数"] integerValue];
    _estate.house.buildYear = [[settings objectForKey:@"建築年"] integerValue];
    _estate.house.construct = [[settings objectForKey:@"構造"] intValue];
    /*--------------------------------------*/
    if ( _addonMgr.opeSetting == true ){
        _yearAquisition             = [[settings objectForKey:@"取得年"] integerValue];
        _declineRate                = [[settings objectForKey:@"家賃下落率"] floatValue];
        _investment.emptyRate       = [[settings objectForKey:@"空室率"] floatValue];
        _investment.mngRate         = [[settings objectForKey:@"管理費割合"] floatValue];
        _investment.incomeTaxRate   = [[settings objectForKey:@"所得税・住民税"] floatValue];
    } else {
        _yearAquisition             = [UIUtil getThisYear];
    }
    /*--------------------------------------*/
    if ( _addonMgr.saleAnalysys == true ){
        _holdingPeriod          = [[settings objectForKey:@"保有期間"] intValue];
        _priceSales             = [[settings objectForKey:@"売却価格"] intValue];
        _improvementCosts       = [[settings objectForKey:@"改良費"] intValue];
        _transferExpense        = [[settings objectForKey:@"譲渡費用"] intValue];
        _discountRate           = 0.05;
    } else {
        _priceSales             = _investment.prices.price;
    }
    return;
}

/****************************************************************
 * 設定値を辞書に設定
 ****************************************************************/
- (NSDictionary*) valToDic
{
    NSMutableDictionary *settings;
    settings  = [NSMutableDictionary dictionary];
    
    //要素を追加する
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_investment.equity]         forKey:@"自己資金"];
    [settings setObject:[NSNumber numberWithInteger:_investment.expense]        forKey:@"諸費用"];
    /*--------------------------------------*/
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_investment.loan.loanBorrow]forKey:@"借入金"];
    [settings setObject:[NSNumber numberWithFloat:_investment.loan.rateYear]    forKey:@"金利"];
    [settings setObject:[NSNumber numberWithInteger:_investment.loan.periodYear]forKey:@"借入期間"];
    /*--------------------------------------*/
    [settings setObject:_estate.name                                            forKey:@"物件名"];
    [settings setObject:[NSNumber numberWithInteger:_estate.prices.price]       forKey:@"物件価格"];
    [settings setObject:[NSNumber numberWithFloat:_estate.prices.gpi]           forKey:@"GPI"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_estate.land.price]         forKey:@"土地価格"];
    [settings setObject:[NSNumber numberWithFloat:_estate.land.area   ]         forKey:@"土地面積"];
    [settings setObject:[NSNumber numberWithInteger:_estate.land.assessment]    forKey:@"路線価"];
    [settings setObject:_estate.land.address                                    forKey:@"住所"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_estate.house.price]        forKey:@"建物価格"];
    [settings setObject:[NSNumber numberWithFloat:_estate.house.area  ]         forKey:@"床面積"];
    [settings setObject:[NSNumber numberWithInteger:_estate.house.rooms ]       forKey:@"戸数"];
    [settings setObject:[NSNumber numberWithInteger:_estate.house.buildYear]    forKey:@"建築年"];
    [settings setObject:[NSNumber numberWithInteger:_estate.house.construct]    forKey:@"構造"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_yearAquisition]            forKey:@"取得年"];
    [settings setObject:[NSNumber numberWithFloat:_declineRate]                 forKey:@"家賃下落率"];
    [settings setObject:[NSNumber numberWithFloat:_investment.emptyRate]        forKey:@"空室率"];
    [settings setObject:[NSNumber numberWithFloat:_investment.mngRate]          forKey:@"管理費割合"];
    [settings setObject:[NSNumber numberWithFloat:_investment.incomeTaxRate]    forKey:@"所得税・住民税"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_holdingPeriod]             forKey:@"保有期間"];
    [settings setObject:[NSNumber numberWithInteger:_priceSales]                forKey:@"売却価格"];
    [settings setObject:[NSNumber numberWithInteger:_improvementCosts]          forKey:@"改良費"];
    [settings setObject:[NSNumber numberWithInteger:_transferExpense]           forKey:@"譲渡費用"];
    
    return settings;
}

/****************************************************************
 *
 ****************************************************************/
- (NSString*) titleString
{
    return @"serial,物件名,物件価格,GPI,諸費用,自己資金,借入金,金利,借入期間,土地価格,土地面積,住所,路線価,建物価格,床面積,構造,戸数,建築年,取得年,家賃下落率,空室率,管理費割合,所得税・住民税,保有期間,売却価格,改良費,譲渡費用\n";
}
/****************************************************************
 *
 ****************************************************************/
- (NSString*) valToString:(NSString*)serial name:(NSString*)name
{
    NSString *str;
    
    str = [NSString stringWithString:[NSString stringWithFormat:@"%@,",serial]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",name]];
    [self fileToVal:serial name:name];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.prices.price]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.prices.gpi]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.expense]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.equity]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.loan.loanBorrow]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_investment.loan.rateYear]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.loan.periodYear]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.land.price]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_estate.land.area]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",_estate.land.address]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.land.assessment]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.house.price]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_estate.house.area]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.house.construct]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.house.rooms]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.house.buildYear]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_yearAquisition]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_declineRate]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_investment.emptyRate]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_investment.mngRate]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_investment.incomeTaxRate]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_holdingPeriod]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_priceSales]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_improvementCosts]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_transferExpense]];
    str = [str stringByAppendingString:@"\n"];
    
    return str;
}
/****************************************************************
 *
 ****************************************************************/
- (void) stringToVal:(NSString*)dataStr keyString:(NSString*)keyStr
{
    NSMutableString *tmpKeyStr;
    NSMutableString *tmpDataStr;
    NSString *key;
    NSString *data;
    
    NSRange rkey,rdata;
    tmpKeyStr   = [NSMutableString stringWithString:keyStr];
    tmpDataStr  = [NSMutableString stringWithString:dataStr];

    NSMutableDictionary *settings;
    settings  = [NSMutableDictionary dictionary];

    BOOL breakFlag = false;
    while (1) {
        rkey    = [tmpKeyStr   rangeOfString:@","];
        rdata   = [tmpDataStr  rangeOfString:@","];
        if ( rkey.location  == NSNotFound ){
            key = tmpKeyStr;
            breakFlag = true;
        } else {
            key  = [tmpKeyStr  substringToIndex:rkey.location];
        }
        if ( rdata.location == NSNotFound ){
            data = tmpDataStr;
            breakFlag = true;
        } else {
            data = [tmpDataStr substringToIndex:rdata.location];
        }

        if( [key isEqualToString:@"serial"] == true ){
            //辞書にはないので直接保持
            _serial = data;
        } else if( [key isEqualToString:@"物件名"] == true ){
            _estate.name   = data;
        } else {
            //要素を追加する
            [settings setObject:data    forKey:key];
        }
        /*--------------------------------------*/
        if ( breakFlag == false ){
            [tmpKeyStr  deleteCharactersInRange:NSMakeRange(0,rkey.location+1)];
            [tmpDataStr deleteCharactersInRange:NSMakeRange(0,rdata.location+1)];
        } else {
            break;
        }
    }
    [self dicToVal:settings name:_estate.name];


}
/****************************************************************
 *
 ****************************************************************/
- (void) setPrice:(NSInteger)price
{
    _estate.prices.price        = price;
    _investment.prices.price    = price;
    if ( _addonMgr.saleAnalysys == false ){
        _priceSales             = price;
    }
    [self adjustEquity];
}
/****************************************************************
 *
 ****************************************************************/
- (void) adjustEquity
{
    [_investment adjustEquity];
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (void) adjustLoanBorrow
{
    [_investment adjustLoanBorrow];
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (void) adjustHousePrice
{
    _estate.house.price = _estate.prices.price - _estate.land.price;
    return;
}

/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************
 *
 ****************************************************************/
- (NSArray*)calcOperationAll:(NSInteger)holdingPeriod
{
    NSInteger tmpGpi = _investment.prices.gpi;
    NSMutableArray  *opeAll = [NSMutableArray array];
    NSInteger btcfSum = 0;
    NSInteger atcfSum = 0;
    
    for(int i=0; i< holdingPeriod; i++){
        Operation *ope = [_investment getOperation:i+1
                                               gpi:tmpGpi
                                              loan:_investment.loan
                                 amortizationCosts:[_estate.house getAmortizationCosts_aquYear:_yearAquisition term:i+1]];
        tmpGpi = tmpGpi * (1 - _declineRate);
        
        [opeAll addObject:ope];
        btcfSum = btcfSum+ ope.btcf;
        atcfSum = atcfSum+ ope.atcf;
    }
    
    _btcfOpeAll = btcfSum;
    _atcfOpeAll = atcfSum;
    
    return opeAll;
    
    
}

#if 0
/****************************************************************
 *
 ****************************************************************/
-(NSData*)str2data:(NSString*)str
{
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}
/****************************************************************
 *
 ****************************************************************/
-(BOOL)data2file:(NSData *)data fileName:(NSString*)fileName
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:fileName];
    return [data writeToFile:path atomically:YES];
    
}
/****************************************************************
 *
 ****************************************************************/
-(NSData*)file2data:(NSString*)filenName
{
    NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:filenName];
    return [NSData dataWithContentsOfFile:path];
}
/****************************************************************
 *
 ****************************************************************/
-(NSString*)data2str:(NSData*)data
{
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}
#endif
/****************************************************************/
@end
/****************************************************************/

