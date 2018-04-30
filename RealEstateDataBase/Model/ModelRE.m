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
#import "OpeAll.h"
#import "AddonMgr.h"

//======================================================================
@implementation ModelRE
{
    NSString            *_serial;
    NSString            *_name;

    NSInteger           _priceAquisition;
    NSInteger           _tmpCfAccumMin;
    NSInteger           _tmpCfAccumMax;

    OpeAll              *_opeAll;
    
    AddonMgr            *_addonMgr;
    
}
//======================================================================
static ModelRE* sharedModelRE = nil;
//======================================================================
@synthesize investment              = _investment;
@synthesize estate                  = _estate;
@synthesize loanName                = _loanName;
@synthesize sale                    = _sale;
@synthesize ope1                    = _ope1;
@synthesize opeLast                 = _opeLast;

@synthesize declineRate             = _declineRate;
@synthesize holdingPeriodTerm       = _holdingPeriodTerm;
@synthesize holdingPeriodTermForOpe = _holdingPeriodTermForOpe;
@synthesize discountRate            = _discountRate;
@synthesize npv                     = _npv;
@synthesize btIrr                   = _btIrr;
@synthesize atIrr                   = _atIrr;

@synthesize btcfOpeAll          = _btcfOpeAll;
@synthesize atcfOpeAll          = _atcfOpeAll;
@synthesize btcfTotal           = _btcfTotal;
@synthesize atcfTotal           = _atcfTotal;

@synthesize btcfAccumMin        = _btcfAccumMin;
@synthesize btcfAccumMax        = _btcfAccumMax;
@synthesize atcfAccumMin        = _atcfAccumMin;
@synthesize atcfAccumMax        = _atcfAccumMax;
//======================================================================
#define BTCF        1
#define ATCF        2
#define BTCFBANK    3
//======================================================================
//
//======================================================================
+(ModelRE*)sharedManager
{
    @synchronized(self){
        if (sharedModelRE == nil ){
            sharedModelRE = [[self alloc ]init ];
        }
    }
    return sharedModelRE;
}
//======================================================================
//
//======================================================================
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
//======================================================================
//
//======================================================================
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}
//======================================================================
//
//======================================================================
-(id)init
{
    self = [super init];
    if (self) {
        [self setDefaultItem:@"未選択"];
        _opeAll     = [[OpeAll alloc]init];
        _sale       = [[Sale alloc]init];
        _addonMgr = [AddonMgr sharedManager];
    }
    return self;
}
//======================================================================
//
//======================================================================
-(void) autoInput
{
    _investment.expense             = _investment.price * 0.07;
    [_investment adjustEquity];
    _investment.mngRate             = 0.05;
    _investment.propTaxRate         = 0.014;
    _investment.incomeTaxRate       = 0.3;
    _investment.loan.levelPayment   = true;
    _investment.bootMonth           = 3;

    _estate.land.assessment         = _estate.land.price / 1000 / _estate.land.area;
    _estate.house.area              = _estate.land.area;
    _estate.house.equipRatio        = 0;
    _estate.house.price             = _investment.price - _estate.land.price;
    _estate.house.acquisitionTerm   = [UIUtil getTerm_year:[UIUtil getThisYear] month:[UIUtil getThisMonth]];
    _declineRate                    = 0.01;
    _holdingPeriodTerm              = 10*12;
    _sale.price                     = _investment.price;
    _sale.expense                   = _sale.price * 0.04;
}
//======================================================================
// データの再計算
//======================================================================

//======================================================================
//
//======================================================================
-(void) calcAll
{
    if ( _addonMgr.saleAnalysys == true ){
        _holdingPeriodTermForOpe = _holdingPeriodTerm;
    } else if ( _addonMgr.multiYear == true ){
        _holdingPeriodTermForOpe =_investment.loan.periodTerm +1 + 12;
    } else {
        _holdingPeriodTermForOpe = 12;
    }

    
    [_opeAll calcOpeAll:_holdingPeriodTermForOpe
             investment:_investment
                 estate:_estate
            declineRate:_declineRate];
    NSArray *opeN = _opeAll.opeArr;
    
    _btcfOpeAll = _opeAll.btcf;
    _atcfOpeAll = _opeAll.atcf;
    _ope1       = _opeAll.ope1;
    if ( _holdingPeriodTermForOpe < 12 ){
        //1年未満の売却。最終年は1年目と同じ
        _opeLast = _ope1;
    } else {
        _opeLast    = [opeN objectAtIndex:_holdingPeriodTermForOpe/12-1];
    }
    

    /*--------------------------------------*/
    [_sale calcSale:_investment holdingPeriod:_holdingPeriodTermForOpe/12 estate:_estate];

    /*--------------------------------------*/
    //キャッシュフローの集計
    _btcfTotal  = _sale.btcf + _btcfOpeAll;
    _atcfTotal  = _sale.atcf + _atcfOpeAll;

    /*--------------------------------------*/
    if ( _ope1.btcf == 0 || _investment.equity == 0 ){
        /* 未設定の場合には計算しない */
        _npv    = 0;
        _btIrr  = 0;
        _atIrr  = 0;
    } else {
        NSArray *arrBtcf = [self makeArrAllCF:BTCF opeArr:_opeAll.opeArr cfSale:_sale.btcf];
        NSArray *arrAtcf = [self makeArrAllCF:ATCF opeArr:_opeAll.opeArr cfSale:_sale.atcf];
        /*--------------------------------------*/
        _npv = [Finance npv_rate:_discountRate array:arrBtcf ] - _investment.equity;
        /*--------------------------------------*/
        _btIrr  = [self calcIrr:arrBtcf initialInvest:_investment.equity];
        _atIrr  = [self calcIrr:arrAtcf initialInvest:_investment.equity];
    }

}
//======================================================================
// 年ごとの運営状況を表形式で取得
//======================================================================
-(NSArray*) getOperationArray
{
    NSInteger   tmpHoldingPeriodYear = ([UIUtil getMonth_term:_estate.house.acquisitionTerm] + _holdingPeriodTermForOpe -2) / 12 + 1;
    
    NSMutableArray *opeArrAll = [NSMutableArray array];
    NSArray *item = [NSArray arrayWithObjects:@"年数",@"期間",@"潜在総収入(GPI)",@"空室損",@"実効総収入(EGI)",@"運営費(OPEx)",@"(管理費)",@"(固都税)",@"(その他)",@"営業利益(NOI)",@"負債支払額(ADS)",@"税引前CF",@"初期投資",@"減価償却費",@"課税所得",@"所得税等",@"税引後CF",@"累積税引前CF",@"累積税引後CF",nil];
    [opeArrAll addObject:item];

    _ope1       = _opeAll.ope1;
    
    NSMutableArray *opeArr = [NSMutableArray array];
    [opeArr addObject:[NSString stringWithFormat:@"1年目実質"]];
    [opeArr addObject:[NSString stringWithFormat:@"1年分"]];
    [opeArr addObject:[UIUtil yenValue:_ope1.gpi]];
    [opeArr addObject:[UIUtil yenValue:- _ope1.emptyLoss]];
    [opeArr addObject:[UIUtil yenValue:_ope1.egi]];
    [opeArr addObject:[UIUtil yenValue:- _ope1.opex]];
    [opeArr addObject:[UIUtil yenValue:- _ope1.opex_mng]];
    [opeArr addObject:[UIUtil yenValue:- _ope1.opex_tax]];
    [opeArr addObject:[UIUtil yenValue:- _ope1.opex_etc]];
    [opeArr addObject:[UIUtil yenValue:_ope1.noi]];
    [opeArr addObject:[UIUtil yenValue:- _ope1.ads]];
    [opeArr addObject:[UIUtil yenValue:_ope1.btcf]];
    [opeArr addObject:@"***"];
    [opeArr addObject:[UIUtil yenValue:- _ope1.amCost]];
    [opeArr addObject:[UIUtil yenValue:_ope1.taxIncome]];
    [opeArr addObject:[UIUtil yenValue:- _ope1.tax]];
    [opeArr addObject:[UIUtil yenValue:_ope1.atcf]];
    [opeArr addObject:@"***"];
    [opeArr addObject:@"***"];
    [opeArrAll addObject:opeArr];
    
    NSInteger btcfSum = 0;
    NSInteger atcfSum = 0;
    
    Operation *ope;
    NSInteger lastMonth = [UIUtil getMonth_term:_estate.house.acquisitionTerm+_holdingPeriodTermForOpe-1];
    NSInteger acquYear  = [UIUtil getYear_term:_estate.house.acquisitionTerm];
    NSInteger acquMonth = [UIUtil getMonth_term:_estate.house.acquisitionTerm];
    for(int year=1; year<=tmpHoldingPeriodYear; year++){
        ope = [_opeAll.opeArr objectAtIndex:year-1];
        
        NSMutableArray *opeArr = [NSMutableArray array];
        [opeArr addObject:[NSString stringWithFormat:@"%d年目(%ld)",year,acquYear +year-1]];
        if (year==1){
            //1年目
            if ( acquMonth != 12 ){
                if ( year != tmpHoldingPeriodYear){
                    [opeArr addObject:[NSString stringWithFormat:@"%ld月-12月",acquMonth]];
                } else {
                    //1年以内に売却する場合
                    if (acquMonth != lastMonth){
                        [opeArr addObject:[NSString stringWithFormat:@"%ld月-%ld月",acquMonth,lastMonth]];
                    } else {
                        //取得した月に売却する場合...あんまり普通じゃないけどね
                        [opeArr addObject:[NSString stringWithFormat:@"%ld月",acquMonth]];
                        }
                    }
            } else {
                [opeArr addObject:[NSString stringWithFormat:@"12月"]];
                }
        } else if ( year == tmpHoldingPeriodYear){
            //最後の年
            if ( lastMonth == 1 ){
                [opeArr addObject:[NSString stringWithFormat:@"1月"]];
            } else {
                [opeArr addObject:[NSString stringWithFormat:@"1月-%ld月",lastMonth]];
                }
        } else {
            //間の年
            [opeArr addObject:[NSString stringWithFormat:@"1月-12月"]];
        }
        [opeArr addObject:[UIUtil yenValue:ope.gpi]];
        [opeArr addObject:[UIUtil yenValue:- ope.emptyLoss]];
        [opeArr addObject:[UIUtil yenValue:ope.egi]];
        [opeArr addObject:[UIUtil yenValue:- ope.opex]];
        [opeArr addObject:[UIUtil yenValue:- ope.opex_mng]];
        [opeArr addObject:[UIUtil yenValue:- ope.opex_tax]];
        [opeArr addObject:[UIUtil yenValue:- ope.opex_etc]];
        [opeArr addObject:[UIUtil yenValue:ope.noi]];
        [opeArr addObject:[UIUtil yenValue:- ope.ads]];
        [opeArr addObject:[UIUtil yenValue:ope.btcf]];
        [opeArr addObject:[UIUtil yenValue:- ope.initCost]];
        [opeArr addObject:[UIUtil yenValue:- ope.amCost]];
        [opeArr addObject:[UIUtil yenValue:  ope.taxIncome]];
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
//======================================================================
// 累積キャッシュフローを座標配列で取得
//======================================================================
-(NSArray*) getBTCashFlowAccum:(NSInteger)period
{
    NSArray *retArr;
    
    retArr = [self getCashFlowAccum:BTCF period:period];
    _btcfAccumMin = _tmpCfAccumMin;
    _btcfAccumMax = _tmpCfAccumMax;
    
    return retArr;
}
//======================================================================
// 累積キャッシュフローを座標配列で取得
//======================================================================
-(NSArray*) getATCashFlowAccum:(NSInteger)period
{
    NSArray *retArr;

    retArr = [self getCashFlowAccum:ATCF period:period];
    _btcfAccumMin = _tmpCfAccumMin;
    _btcfAccumMax = _tmpCfAccumMax;

    return retArr;
}
//======================================================================
// 累積キャッシュフローを座標配列で取得
//======================================================================
-(NSArray*) getCashFlowAccum:(NSInteger)mode period:(NSInteger)period
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
    Operation *tmpOpe;
    for ( int year = 1; year <= period; year++){
        tmpOpe = [_opeAll.opeArr objectAtIndex:year-1];

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
    
    if ( _addonMgr.saleAnalysys == true ){
        //売却益を追加
        if ( mode == BTCF ){
            cfSum = cfSum + _sale.btcf;
        } else {
            cfSum = cfSum + _sale.atcf;
        }
        tmpPoint = CGPointMake(period+1, cfSum);
        [cfArr addObject:[NSValue valueWithCGPoint:tmpPoint]];
    }


    /* 最大値・最小値を更新 */
    if ( cfSumMax < cfSum ){
        cfSumMax = cfSum;
    }
    if ( cfSumMin > cfSum ){
        cfSumMin = cfSum;
    }
    _tmpCfAccumMax  = cfSumMax;
    _tmpCfAccumMin  = cfSumMin;
    return cfArr;
}
//======================================================================
// [割引率,NPV(正味現在価値)] 配列の取得
//======================================================================
-(NSArray*) getNpvArray
{
    //CFを配列に用意する
    NSArray *arr = [self makeArrAllCF:BTCF opeArr:_opeAll.opeArr cfSale:_sale.btcf];;
    

    NSMutableArray *npvArr = [NSMutableArray array];
    CGFloat discountRate;
    CGFloat npv;
    CGPoint tmpPoint;
    
    int i = 0;
    do {
        discountRate = i * 0.5 / 100;   // 0.5%刻みでデータ作成
        /*--------------------------------------*/
        npv = [Finance npv_rate:discountRate array:arr ] - _investment.equity;
        /*--------------------------------------*/
        tmpPoint = CGPointMake(discountRate*100, npv);
        [npvArr addObject:[NSValue valueWithCGPoint:tmpPoint]];
        if ( discountRate > 0.10 && npv < 0 ){
            break;
        }
        i++;
    } while (discountRate < 1 );
    return npvArr;
}
//======================================================================
// [年数,債務償還年数] 配列の取得
//======================================================================
-(NSArray*) getDebtRepaymentPeriodArray
{
    NSInteger period = _holdingPeriodTermForOpe /12;

    NSArray *arrBtcf = [self makeArrAllCF:BTCFBANK opeArr:_opeAll.opeArr cfSale:_sale.btcf];
    NSArray *lbArr = [_investment.loan getLbArrayYear];
    
    NSMutableArray *drpArr = [NSMutableArray array];
    CGPoint tmpLbPoint;
    CGFloat tmpBtcf;
    CGFloat tmpDrp;
    CGPoint tmpDrpPoint;
    
    
    for( int i=0; i < _investment.loan.periodTerm/12; i++ ){
        if ( [lbArr count] > i ){
            tmpLbPoint  = [[lbArr       objectAtIndex:i] CGPointValue];
        } else {
            tmpLbPoint  = CGPointMake(i+1, 0 );
        }
        if ( [arrBtcf count] > i ){
            tmpBtcf     = [[arrBtcf    objectAtIndex:i] floatValue];
        } else {
            tmpBtcf     = 0;
        }
        if ( tmpBtcf > 0 ){
            tmpDrp      = (CGFloat)tmpLbPoint.y / tmpBtcf;
        } else {
            tmpDrp      = 0;
        }
        tmpDrpPoint = CGPointMake(i+1, tmpDrp);
        [drpArr addObject:[NSValue valueWithCGPoint:tmpDrpPoint]];
        
        if ( i >= period -1 ){
            break;
        }
    }
    
    return drpArr;
}
//======================================================================
-(NSArray*) getRentRollArray:(NSInteger)rentRoll startYear:(NSInteger)startYear endYear:(NSInteger)endYear declineRate:(CGFloat)declineRate
{
    NSMutableArray *rentRollArr = [NSMutableArray array];
    CGPoint tmpRentRollPoint;
    NSInteger year;
    for(int i=0; i<(endYear-startYear); i++){
        year = startYear + i;
        //レントロール
        tmpRentRollPoint = CGPointMake(year,rentRoll);
        [rentRollArr addObject:[NSValue valueWithCGPoint:tmpRentRollPoint]];

        rentRoll = ( 1- declineRate)*rentRoll;
    }
    
    return rentRollArr;
}
//======================================================================
// [年数,積算評価] 配列の取得
//======================================================================
-(NSArray*) getAllValArrayYear
{
    NSInteger period = _investment.loan.periodTerm /12;

    
    NSMutableArray *valuationArr = [NSMutableArray array];
    NSInteger valuation;
    CGPoint tmpValuationPoint;
    
    
    for( int i=0; i < _investment.loan.periodTerm/12; i++ ){

        valuation = _estate.land.assessValue + [_estate.house getValuation_term:(i*12+1)];
        
        tmpValuationPoint = CGPointMake(i+1, valuation);
        [valuationArr addObject:[NSValue valueWithCGPoint:tmpValuationPoint]];

        if ( i >= period -1 ){
            break;
        }
    }
    return valuationArr;
}
//======================================================================
// [年数,路線価] 配列の取得
//======================================================================
-(NSArray*) getLandValArrayYear
{
    NSInteger period = _investment.loan.periodTerm /12;
    
    NSMutableArray *valuationArr = [NSMutableArray array];
    CGPoint tmpValuationPoint;
    
    
    for( int i=0; i < _investment.loan.periodTerm/12; i++ ){
        tmpValuationPoint = CGPointMake(i+1, _estate.land.assessValue);
        [valuationArr addObject:[NSValue valueWithCGPoint:tmpValuationPoint]];
        
        if ( i >= period -1 ){
            break;
        }
    }
    return valuationArr;
    
}
//======================================================================
- (NSArray*) getVacantArray:(NSInteger)gpiMonth emptyRate:(CGFloat)emptyRate bootMonth:(NSInteger)bootMonth
{
    NSMutableArray *gpiArr = [NSMutableArray array];
    CGPoint tmpGpiPoint;
    NSInteger month;
    NSInteger tmpGpiMonth;
    for(int i=0; i<13; i++){
        month = i;
        //レントロール
        if ( bootMonth != 0 && i <= bootMonth ){
            tmpGpiMonth = (CGFloat)gpiMonth*( 1- emptyRate) * i  / bootMonth;
        } else {
            tmpGpiMonth = (CGFloat)gpiMonth*( 1- emptyRate);
        }
        tmpGpiPoint = CGPointMake(month,tmpGpiMonth);
        [gpiArr addObject:[NSValue valueWithCGPoint:tmpGpiPoint]];
        
    }
    
    return gpiArr;
}


//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//
//======================================================================
-(void) valToFile
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

//======================================================================
//
//======================================================================
-(void) fileToVal:(NSString*)serial name:(NSString*)name
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
//======================================================================
//
//======================================================================
-(void)setDefaultItem:(NSString*)name
{
    SettingLoan *tmploan = [SettingLoan sharedManager];
    /*--------------------------------------*/
    _loanName                       = [tmploan.name0 copy];
    /*--------------------------------------*/
    _investment = [[Investment alloc]initWithPrice:5000*10000
                                                  gpi:5000*10000*0.08];
    _investment.equity              = 1350 * 10000;
    _investment.expense             = 350 * 10000;
    NSInteger lb;
    lb = _investment.price + _investment.expense - _investment.equity;
    [tmploan setLoanBorrows:lb];
    
    _investment.loan.loanBorrow     =   4000*10000;
    _investment.loan.rateYear       =   0.02;
    _investment.loan.periodTerm     =   30*12;
    _investment.loan.levelPayment   =   tmploan.loan0.levelPayment;
    /*--------------------------------------*/
    _investment.emptyRate           = 0.10;
    _investment.mngRate             = 0.05;
    _investment.propTaxRate         = 0.014;
    _investment.incomeTaxRate       = 0.3;
    _investment.opexEtc             = 60000;
    _investment.bootMonth           = 3;
    /*--------------------------------------*/
    _estate                         = [[Estate alloc]init];
    _estate.isBrokerageFee          = true;
    _estate.land.price              = 2500 *10000;
    _estate.land.area               = 100.0;
    _estate.land.address            = [NSString stringWithFormat:@"千代田区千代田内堀通り"];
    _estate.land.latitude           = 0;
    _estate.land.longitude          = 0;
    _estate.land.assessment         = 125;
    _estate.house.price             = _investment.price - _estate.land.price;
    _estate.house.rooms             = 8;
    _estate.house.equipRatio        = 0;
    _estate.house.area              = 100.00;
    _estate.house.buildTerm         = [UIUtil getTerm_year:[UIUtil getThisYear] month:[UIUtil getThisMonth]];
    _estate.house.construct         = CONST_WOOD;
    _estate.house.acquisitionTerm   = [UIUtil getTerm_year:[UIUtil getThisYear] month:[UIUtil getThisMonth]];
    _estate.name                    = name;
 
    _declineRate            = 0.01;
    
    _holdingPeriodTerm          = 10 *12;
    _sale.price             = 4500*10000;
    _sale.expense           = 180*10000;
    
    return;
}

//======================================================================
//
//======================================================================
-(void) deleteItem:(NSString*)serial
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
//======================================================================
// データファイルの有無確認
//======================================================================
-(BOOL)isExistDataFile:(NSString*)plistFilePath
{
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:plistFilePath];
    
}
//======================================================================
// 項目キーから表示用の値を取り出す
//======================================================================
-(NSString*) getString:(NSString*)key
{
    NSString *str;
    
        //----------------------------------------
        // 基本情報
        //----------------------------------------
    if ( [key isEqualToString:@"物件名"]){
        str = [NSString stringWithFormat:@"%@",_estate.name];
    } else if ( [key isEqualToString:@"物件価格"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_investment.price/10000]];
    } else if ( [key isEqualToString:@"表面利回り"]){
        str = [NSString stringWithFormat:@"%2.2f%%(%ld万円)",_investment.interest*100,_investment.gpi/10000];
    } else if ( [key isEqualToString:@"諸費用"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_investment.expense/10000]];
    } else if ( [key isEqualToString:@"仲介手数料"]){
        str =  _estate.isBrokerageFee ? @"あり" : @"なし";
    } else if ( [key isEqualToString:@"自己資金"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_investment.equity/10000]];
        //----------------------------------------
        // 融資関係
        //----------------------------------------
    } else if ( [key isEqualToString:@"借入金"]){
        NSInteger lvt = (_investment.loan.loanBorrow/100)/(_investment.price/10000);
        str = [NSString stringWithFormat:@"%@万円(%ld%%融資)",[UIUtil yenValue:_investment.loan.loanBorrow/10000],(long)lvt];
    } else if ( [key isEqualToString:@"金利"]){
        str = [NSString stringWithFormat:@"%g%%",_investment.loan.rateYear*100];
    } else if ( [key isEqualToString:@"借入期間"]){
        if ( _investment.loan.periodTerm%12 == 0 ){
            str = [NSString stringWithFormat:@"%ld年",
                   (long)_investment.loan.periodTerm/12];
        } else {
            str = [NSString stringWithFormat:@"%ld年%ldヶ月",
                   (long)_investment.loan.periodTerm/12,
                   (long)_investment.loan.periodTerm%12];
        }
        //----------------------------------------
        // 土地関係
        //----------------------------------------
    } else if ( [key isEqualToString:@"土地価格"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_estate.land.price/10000]];
    } else if ( [key isEqualToString:@"土地面積"]){
        str = [NSString stringWithFormat:@"%g㎡",_estate.land.area];
    } else if ( [key isEqualToString:@"住所"]){
        str = [NSString stringWithFormat:@"%@",_estate.land.address];
    } else if ( [key isEqualToString:@"路線価"]){
        str = [NSString stringWithFormat:@"%@千円/㎡",[UIUtil yenValue:_estate.land.assessment]];
        //----------------------------------------
        // 建物関係
        //----------------------------------------
    } else if ( [key isEqualToString:@"建物価格"]){
        str = [NSString stringWithFormat:@"%@万円(税:%@万円)",[UIUtil yenValue:_estate.house.price/10000],[UIUtil yenValue:_estate.house.price/10000*0.08]];
    } else if ( [key isEqualToString:@"建築年"]){
        str = [NSString stringWithFormat:@"%ld年%ld月",
               (long)[UIUtil getYear_term:_estate.house.buildTerm],
               (long)[UIUtil getMonth_term:_estate.house.buildTerm]];
    } else if ( [key isEqualToString:@"設備割合"]){
        str = [NSString stringWithFormat:@"%g%%",_estate.house.equipRatio*100];
    } else if ( [key isEqualToString:@"床面積"]){
        str = [NSString stringWithFormat:@"%g㎡",_estate.house.area];
    } else if ( [key isEqualToString:@"構造"]){
        str = [House constructStr:_estate.house.construct];
    } else if ( [key isEqualToString:@"戸数"]){
        str = [NSString stringWithFormat:@"%d戸",(int)_estate.house.rooms];
        //----------------------------------------
        // 運営関係
        //----------------------------------------
    } else if ( [key isEqualToString:@"取得年"]){
        str = [NSString stringWithFormat:@"%ld年%ld月",
               (long)[UIUtil getYear_term:_estate.house.acquisitionTerm],
               (long)[UIUtil getMonth_term:_estate.house.acquisitionTerm]];
    } else if ( [key isEqualToString:@"立ち上げ期間"]){
        str = [NSString stringWithFormat:@"%ldヶ月",_investment.bootMonth];
    } else if ( [key isEqualToString:@"家賃下落率"]){
        str = [NSString stringWithFormat:@"%2.2f%%",_declineRate*100];
    } else if ( [key isEqualToString:@"空室率"]){
        str = [NSString stringWithFormat:@"%2.2f%%",_investment.emptyRate*100];
    } else if ( [key isEqualToString:@"管理費割合"]){
        str = [NSString stringWithFormat:@"%2.2f%%",_investment.mngRate*100];
    } else if ( [key isEqualToString:@"その他運営費"]){
        str = [NSString stringWithFormat:@"%2.1f万/年",(CGFloat)_investment.opexEtc/10000];
    } else if ( [key isEqualToString:@"所得税・住民税"]){
        str = [NSString stringWithFormat:@"%2.1f%%(%@)",_investment.incomeTaxRate*100,_investment.isCompany ? @"法人" : @"個人"];
        //----------------------------------------
        // 売却関係
        //----------------------------------------
    } else if ( [key isEqualToString:@"保有期間"]){
        if ( _holdingPeriodTerm%12 != 0 ){
            str = [NSString stringWithFormat:@"%ld年%ldヶ月",
                   (long)_holdingPeriodTerm/12,
                   (long)_holdingPeriodTerm%12];
        } else {
            str = [NSString stringWithFormat:@"%ld年",
                   (long)_holdingPeriodTerm/12];
        }
    } else if ( [key isEqualToString:@"売却価格"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_sale.price/10000]];
    } else if ( [key isEqualToString:@"改良費"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_estate.house.improvementCosts/10000]];
    } else if ( [key isEqualToString:@"譲渡費用"]){
        str = [NSString stringWithFormat:@"%@万円",[UIUtil yenValue:_sale.expense/10000]];
        //----------------------------------------
    } else {
        str = @"";
    }
    return str;
}
//======================================================================
// 辞書形式から設定値を取り出す
//======================================================================
-(void) dicToVal:(NSDictionary*)settings name:(NSString*)name
{
    //最初にデフォルト値を入れてしまい、後から辞書から読みだした値で上書きする
    [self setDefaultItem:name];
    /*--------------------------------------*/
    _investment.equity      = [[settings objectForKey:@"自己資金"] integerValue];
    _investment.expense     = [[settings objectForKey:@"諸費用"] integerValue];
    _estate.isBrokerageFee  = [[settings objectForKey:@"仲介手数料"] boolValue];
    /*--------------------------------------*/
    _investment.price    = [[settings objectForKey:@"物件価格"] integerValue];
    _investment.gpi  =[[settings objectForKey:@"GPI"] floatValue];
    /*--------------------------------------*/
    _investment.loan.loanBorrow =[[settings objectForKey:@"借入金"] integerValue];
    _investment.loan.rateYear   =[[settings objectForKey:@"金利"] floatValue];
    _investment.loan.periodTerm =[[settings objectForKey:@"借入期間"] integerValue] *12;
    _investment.loan.periodTerm +=[[settings objectForKey:@"借入期間月"] integerValue];
    /*--------------------------------------*/
    _estate.name            = name;
    _investment.price    = [[settings objectForKey:@"物件価格"] integerValue];
    _investment.gpi      = [[settings objectForKey:@"GPI"] floatValue];
    /*--------------------------------------*/
    _estate.land.price      = [[settings objectForKey:@"土地価格"] integerValue];
    _estate.land.area       = [[settings objectForKey:@"土地面積"] floatValue];
    _estate.land.address    = [settings objectForKey:@"住所"];
    _estate.land.assessment = [[settings objectForKey:@"路線価"] integerValue];
    _estate.land.latitude   = [[settings objectForKey:@"緯度"] doubleValue];
    _estate.land.longitude  = [[settings objectForKey:@"経度"] doubleValue];
    /*--------------------------------------*/
    _estate.house.price     = [[settings objectForKey:@"建物価格"] integerValue];
    _estate.house.equipRatio=[[settings objectForKey:@"設備割合"] floatValue];
    _estate.house.area      = [[settings objectForKey:@"床面積"] floatValue];
    _estate.house.rooms     = [[settings objectForKey:@"戸数"] integerValue];
    NSInteger buildYear     = [[settings objectForKey:@"建築年"] integerValue];
    NSInteger buildMonth    =  [[settings objectForKey:@"建築月"] integerValue];
    _estate.house.buildTerm = [UIUtil getTerm_year:buildYear month:buildMonth];
    _estate.house.construct = [[settings objectForKey:@"構造"] intValue];
    /*--------------------------------------*/
    if ( _addonMgr.opeSetting == true ){
        NSInteger acquYear  = [[settings objectForKey:@"取得年"] integerValue];
        NSInteger acquMonth = [[settings objectForKey:@"取得月"] integerValue];
        _estate.house.acquisitionTerm = [UIUtil getTerm_year:acquYear month:acquMonth];
        _declineRate                    = [[settings objectForKey:@"家賃下落率"] floatValue];
        _investment.emptyRate           = [[settings objectForKey:@"空室率"] floatValue];
        _investment.mngRate             = [[settings objectForKey:@"管理費割合"] floatValue];
        _investment.opexEtc             = [[settings objectForKey:@"その他運営費"] integerValue];
        _investment.bootMonth           = [[settings objectForKey:@"立ち上げ期間"] integerValue];
        _investment.incomeTaxRate       = [[settings objectForKey:@"所得税・住民税"] floatValue];
    } else {
        //まだ建ってなかったら取得Termは建築Termにする。
        NSInteger cur_Term    = [UIUtil getTerm_year:[UIUtil getThisYear] month:[UIUtil getThisMonth]];
        if (cur_Term < _estate.house.buildTerm){
            _estate.house.acquisitionTerm = _estate.house.buildTerm;
        } else {
            _estate.house.acquisitionTerm = cur_Term;
        }
    }
    /*--------------------------------------*/
    if ( _addonMgr.saleAnalysys == true ){
        NSInteger holdingYear           = [[settings objectForKey:@"保有期間"] intValue];
        NSInteger holdingMonth          = [[settings objectForKey:@"保有期間月"] intValue];
        _holdingPeriodTerm                  = holdingYear*12 + holdingMonth;
        _sale.price                     = [[settings objectForKey:@"売却価格"] intValue];
        _estate.house.improvementCosts  = [[settings objectForKey:@"改良費"] intValue];
        _sale.expense                   = [[settings objectForKey:@"譲渡費用"] intValue];
        _discountRate                   = 4.0 / 100;
    } else {
        _sale.price                     = _investment.price;
    }
    return;
}
//======================================================================
// 設定値を辞書形式に設定
//======================================================================
-(NSDictionary*) valToDic
{
    NSMutableDictionary *settings;
    settings  = [NSMutableDictionary dictionary];
    
    //要素を追加する
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_investment.equity]             forKey:@"自己資金"];
    [settings setObject:[NSNumber numberWithInteger:_investment.expense]            forKey:@"諸費用"];
    [settings setObject:[NSNumber numberWithInteger:_estate.isBrokerageFee]         forKey:@"仲介手数料"];
    /*--------------------------------------*/
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_investment.loan.loanBorrow]    forKey:@"借入金"];
    [settings setObject:[NSNumber numberWithFloat:_investment.loan.rateYear]        forKey:@"金利"];
    [settings setObject:[NSNumber numberWithInteger:_investment.loan.periodTerm/12] forKey:@"借入期間"];
    [settings setObject:[NSNumber numberWithInteger:_investment.loan.periodTerm%12] forKey:@"借入期間月"];
    /*--------------------------------------*/
    [settings setObject:_estate.name                                                forKey:@"物件名"];
    [settings setObject:[NSNumber numberWithInteger:_investment.price]              forKey:@"物件価格"];
    [settings setObject:[NSNumber numberWithFloat:_investment.gpi]                  forKey:@"GPI"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_estate.land.price]             forKey:@"土地価格"];
    [settings setObject:[NSNumber numberWithFloat:_estate.land.area   ]             forKey:@"土地面積"];
    [settings setObject:[NSNumber numberWithInteger:_estate.land.assessment]        forKey:@"路線価"];
    [settings setObject:_estate.land.address                                        forKey:@"住所"];
    [settings setObject:[NSNumber numberWithDouble:_estate.land.latitude]           forKey:@"緯度"];
    [settings setObject:[NSNumber numberWithDouble:_estate.land.longitude]          forKey:@"経度"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_estate.house.price]            forKey:@"建物価格"];
    [settings setObject:[NSNumber numberWithFloat:_estate.house.equipRatio]         forKey:@"設備割合"];
    [settings setObject:[NSNumber numberWithFloat:_estate.house.area  ]             forKey:@"床面積"];
    [settings setObject:[NSNumber numberWithInteger:_estate.house.rooms ]           forKey:@"戸数"];
    NSInteger buildYear  = [UIUtil getYear_term:_estate.house.buildTerm];
    NSInteger buildMonth = [UIUtil getMonth_term:_estate.house.buildTerm];
    [settings setObject:[NSNumber numberWithInteger:buildYear]                      forKey:@"建築年"];
    [settings setObject:[NSNumber numberWithInteger:buildMonth]                     forKey:@"建築月"];
    [settings setObject:[NSNumber numberWithInteger:_estate.house.construct]        forKey:@"構造"];
    /*--------------------------------------*/
    if ( _addonMgr.opeSetting == false ){
        //まだ建ってなかったら取得Termは建築Termにする。
        NSInteger cur_Term    = [UIUtil getTerm_year:[UIUtil getThisYear] month:[UIUtil getThisMonth]];
        if (cur_Term < _estate.house.buildTerm){
            _estate.house.acquisitionTerm = _estate.house.buildTerm;
        } else {
            _estate.house.acquisitionTerm = cur_Term;
        }
    }
    NSInteger acquisitionYear  = [UIUtil getYear_term:_estate.house.acquisitionTerm];
    NSInteger acquisitionMonth = [UIUtil getMonth_term:_estate.house.acquisitionTerm];
    [settings setObject:[NSNumber numberWithInteger:acquisitionYear]                forKey:@"取得年"];
    [settings setObject:[NSNumber numberWithInteger:acquisitionMonth]               forKey:@"取得月"];
    [settings setObject:[NSNumber numberWithFloat:_declineRate]                     forKey:@"家賃下落率"];
    [settings setObject:[NSNumber numberWithFloat:_investment.emptyRate]            forKey:@"空室率"];
    [settings setObject:[NSNumber numberWithFloat:_investment.mngRate]              forKey:@"管理費割合"];
    [settings setObject:[NSNumber numberWithInteger:_investment.opexEtc]            forKey:@"その他運営費"];
    [settings setObject:[NSNumber numberWithInteger:_investment.bootMonth]          forKey:@"立ち上げ期間"];
    [settings setObject:[NSNumber numberWithFloat:_investment.incomeTaxRate]        forKey:@"所得税・住民税"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_holdingPeriodTerm/12]          forKey:@"保有期間"];
    [settings setObject:[NSNumber numberWithInteger:_holdingPeriodTerm%12]          forKey:@"保有期間月"];
    [settings setObject:[NSNumber numberWithInteger:_sale.price]                    forKey:@"売却価格"];
    [settings setObject:[NSNumber numberWithInteger:_estate.house.improvementCosts] forKey:@"改良費"];
    [settings setObject:[NSNumber numberWithInteger:_sale.expense]                  forKey:@"譲渡費用"];
    
    return settings;
}
//======================================================================
// CSVのタイトル行
//======================================================================
-(NSString*) titleString
{
    return @"serial,物件名,物件価格,GPI,諸費用,仲介手数料,自己資金,借入金,金利,借入期間,借入期間月,土地価格,土地面積,住所,緯度,経度,路線価,建物価格,設備割合,床面積,構造,戸数,建築年,建築月,取得年,取得月,家賃下落率,空室率,管理費割合,その他運営費,立ち上げ期間,所得税・住民税,保有期間,保有期間月,売却価格,改良費,譲渡費用\n";
}
//======================================================================
// 設定値をCSV形式に変換
//======================================================================
-(NSString*) valToString:(NSString*)serial name:(NSString*)name
{
    NSString *str;
    
    str = [NSString stringWithString:[NSString stringWithFormat:@"%@,",serial]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",name]];
    [self fileToVal:serial name:name];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.price]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.gpi]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.expense]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.isBrokerageFee]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.equity]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.loan.loanBorrow]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_investment.loan.rateYear]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.loan.periodTerm/12]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_investment.loan.periodTerm%12]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.land.price]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_estate.land.area]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%@,",_estate.land.address]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_estate.land.latitude]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_estate.land.longitude]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.land.assessment]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.house.price]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_estate.house.equipRatio]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_estate.house.area]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.house.construct]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.house.rooms]];
    NSInteger buildYear  = [UIUtil getYear_term:_estate.house.buildTerm];
    NSInteger buildMonth = [UIUtil getMonth_term:_estate.house.buildTerm];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)buildYear]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)buildMonth]];
    NSInteger acquisitionYear  = [UIUtil getYear_term:_estate.house.acquisitionTerm];
    NSInteger acquisitionMonth = [UIUtil getMonth_term:_estate.house.acquisitionTerm];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)acquisitionYear]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)acquisitionMonth]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_declineRate]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_investment.emptyRate]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_investment.mngRate]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",_investment.opexEtc]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",_investment.bootMonth]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%f,",_investment.incomeTaxRate]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_holdingPeriodTerm/12]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_holdingPeriodTerm%12]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_sale.price]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_estate.house.improvementCosts]];
    str = [str stringByAppendingString:[NSString stringWithFormat:@"%ld,",(long)_sale.expense]];
    str = [str stringByAppendingString:@"\n"];
    
    return str;
}
//======================================================================
//
//======================================================================
-(void) stringToVal:(NSString*)dataStr keyString:(NSString*)keyStr
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
//======================================================================
// 物件価格を設定したら自己資金を調整
//======================================================================
-(void) setPrice:(NSInteger)price
{
    _investment.price    = price;
    if ( _addonMgr.saleAnalysys == false ){
        _sale.price             = price;
    }
    [self adjustEquity];
}
//======================================================================
// 自己資金を調整
//======================================================================
-(void) adjustEquity
{
    [_investment adjustEquity];
    return;
}
//======================================================================
// 借入金を調整
//======================================================================
-(void) adjustLoanBorrow
{
    [_investment adjustLoanBorrow];
    return;
}
//======================================================================
// 建物価格を「物件価格 - 土地価格」に設定
//======================================================================
-(void) adjustHousePrice
{
    _estate.house.price = _investment.price - _estate.land.price;
    return;
}

//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
//======================================================================
// 運営配列と売却CFからNPV計算用のCF配列を作る
//======================================================================
-(NSArray*) makeArrAllCF:(NSInteger)mode opeArr:(NSArray*)opeArr cfSale:(NSInteger)cfSale
{
    NSInteger holdingPeriod = [opeArr count];
    NSMutableArray *arrCf   = [NSMutableArray array];
    /*--------------------------------------*/
    Operation *tmpOpe;
    for( int year=1; year < holdingPeriod; year++ ){
        tmpOpe = [opeArr objectAtIndex:year-1];
        if ( mode == BTCF ){
            [arrCf addObject:[NSNumber numberWithInteger:tmpOpe.btcf]];
        } else if ( mode == ATCF ){
            [arrCf addObject:[NSNumber numberWithInteger:tmpOpe.atcf]];
        } else {
            NSInteger btcfBank = tmpOpe.taxIncome + tmpOpe.amCost;
            [arrCf addObject:[NSNumber numberWithInteger:btcfBank]];
        }
    }
    //最終年のCFに売却時CFを加算して追加
    tmpOpe = [opeArr objectAtIndex:holdingPeriod-1];
    [arrCf addObject:[NSNumber numberWithInteger:tmpOpe.btcf+cfSale]];

    return arrCf;
}
//======================================================================
// NPV計算用のCF配列と初期投資額から配列を作り直してIRRを計算
//======================================================================
-(CGFloat) calcIrr:(NSArray*)arrOrg initialInvest:(NSInteger)iniInvest
{
    NSMutableArray *arr = [arrOrg mutableCopy];

    /*--------------------------------------*/
    NSNumber *num_cf = [NSNumber numberWithFloat:- iniInvest];
    [arr insertObject:num_cf atIndex:0];
    return [Finance irr_array:arr];

}
//======================================================================
@end
//======================================================================

