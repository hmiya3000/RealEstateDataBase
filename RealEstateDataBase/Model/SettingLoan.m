//
//  SettingLoan.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/06/15.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "SettingLoan.h"

@implementation SettingLoan
/****************************************************************/
static SettingLoan* sharedSettingLoan = nil;
/****************************************************************/
@synthesize loan0       = _loan0;
@synthesize loan1       = _loan1;
@synthesize loan2       = _loan2;
@synthesize name0       = _name0;
@synthesize name1       = _name1;
@synthesize name2       = _name2;
@synthesize startYear   = _startYear;
@synthesize startMonth  = _startMonth;
@synthesize sc          = _sc;
/****************************************************************
 *
 ****************************************************************/
+(SettingLoan*)sharedManager
{
    @synchronized(self){
        if (sharedSettingLoan == nil ){
            sharedSettingLoan = [[self alloc ]init ];
        }
    }
    return sharedSettingLoan;
}
/****************************************************************
 *
 ****************************************************************/
+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if ( sharedSettingLoan == nil){
            sharedSettingLoan  = [super allocWithZone:zone];
            return sharedSettingLoan;
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
- (id)init {
    self = [super init];
    if (self) {
        _loan0 = [[Loan alloc]init];
        _loan1 = [[Loan alloc]init];
        _loan2 = [[Loan alloc]init];

        
        NSString *seg0  = [NSString stringWithFormat:@"%1.2f%% %2d年",99.99,50];
        NSString *seg1  = [NSString stringWithFormat:@"%1.2f%% %2d年",99.99,50];
        NSString *seg2  = [NSString stringWithFormat:@"%1.2f%% %2d年",99.99,50];
        NSArray *arr    = [NSArray arrayWithObjects:seg0,seg1,seg2,nil];
        
        _sc = [UIUtil makeSegmentedControl_x:0  y:0 length:1   array:arr];

        if ( [self isExistDataFile] == true){
            /* 設定ファイルがあったらロード */
            [self loadData];
        } else {
            /* 設定ファイルがなかったらデフォルト設定でファイル作成*/
            [self setDefaultData];
            [self saveData];
        }
    }
    return self;
}
/****************************************************************
 *
 ****************************************************************/
-(void)setLoanBorrows:(float)lb
{
    _loan0.loanBorrow    = lb;
    _loan1.loanBorrow    = lb;
    _loan2.loanBorrow    = lb;
}
/****************************************************************
 *
 ****************************************************************/
- (SVSegmentedControl*)makeSegmentedControl:(CGFloat)x y:(CGFloat)y length:(CGFloat)length
{
    _sc.frame   = CGRectMake(x, y, length, 30);
    return _sc;
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getPeriodMax
{
    NSInteger periodMax = 0;
    if ( _loan0.periodYear > periodMax ){
        periodMax = _loan0.periodYear;
    }
    if ( _loan1.periodYear > periodMax ){
        periodMax = _loan1.periodYear;
    }
    if ( _loan2.periodYear > periodMax ){
        periodMax = _loan2.periodYear;
    }
    return periodMax;
}
/****************************************************************
 *
 ****************************************************************/
-(NSInteger)getPmtMax
{
    NSInteger pmt0;
    NSInteger pmt1;
    NSInteger pmt2;

    /* 元利均等返済の場合の最大支払い額 */
    pmt0 = [_loan0 getPmtYear:_loan0.periodYear];
    pmt1 = [_loan1 getPmtYear:_loan1.periodYear];
    pmt2 = [_loan2 getPmtYear:_loan2.periodYear];

    NSInteger pmtMax=0;
    if ( pmt0 > pmtMax){
        pmtMax = pmt0;
    }
    if ( pmt1 > pmtMax){
        pmtMax = pmt1;
    }
    if ( pmt2 > pmtMax){
        pmtMax = pmt2;
    }

    /* 元金均等返済の場合の最大支払い額 */
    pmt0 = [_loan0 getPmtYear:1];
    pmt1 = [_loan1 getPmtYear:1];
    pmt2 = [_loan2 getPmtYear:1];
    if ( pmt0 > pmtMax){
        pmtMax = pmt0;
    }
    if ( pmt1 > pmtMax){
        pmtMax = pmt1;
    }
    if ( pmt2 > pmtMax){
        pmtMax = pmt2;
    }
    
    return pmtMax;
}

/****************************************************************
 * データファイル初期化
 ****************************************************************/
-(void)initData
{
    [self deleteData];
    [self setDefaultData];
    [self saveData];
}

/****************************************************************
 * データファイルの有無確認
 ****************************************************************/
- (BOOL)isExistDataFile
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"__loan.plist"]];
    
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];

    return [fileManager fileExistsAtPath:plistFilePath];
    
}

/****************************************************************
 * データファイルの削除
 ****************************************************************/
-(void)deleteData
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"__loan.plist"]];

    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    
    // ファイルを移動
    BOOL result = [fileManager removeItemAtPath:plistFilePath error:&error];
    if (result) {
//        NSLog(@"ファイルを削除に成功：%@", plistFilePath);
    } else {
//        NSLog(@"ファイルの削除に失敗：%@", error.description);
    }
    return;
}

/****************************************************************
 * デフォルトデータによる初期設定
 ****************************************************************/
- (void)setDefaultData
{
    _name0  = @"固定3年";
    _name1  = @"固定10年";
    _name2  = @"フラット35";
    
    [_loan0 setAllProperty_loannBorrow:1000*10000
                              rateYear:0.75/100
                            periodYear:35
                          levelPayment:true];
    [_loan1 setAllProperty_loannBorrow:_loan0.loanBorrow
                              rateYear:1.30/100
                            periodYear:35
                          levelPayment:true];
    [_loan2 setAllProperty_loannBorrow:_loan0.loanBorrow
                              rateYear:1.76/100
                            periodYear:35
                          levelPayment:true];
    
    _startYear      = [UIUtil getThisYear];
    _startMonth     = [UIUtil getThisMonth];

}
/****************************************************************
 *
 ****************************************************************/
- (void)saveData
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"__loan.plist"]];
    
    
    //セーブデータの初期設定
    NSMutableDictionary* settings = [NSMutableDictionary dictionary];
    
    //要素を追加する
    /*--------------------------------------*/
    [settings setObject:_name0                                                  forKey:@"設定名0"];
    [settings setObject:_name1                                                  forKey:@"設定名1"];
    [settings setObject:_name2                                                  forKey:@"設定名2"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_loan0.loanBorrow]          forKey:@"借入金0"];
    [settings setObject:[NSNumber numberWithInteger:_loan1.loanBorrow]          forKey:@"借入金1"];
    [settings setObject:[NSNumber numberWithInteger:_loan2.loanBorrow]          forKey:@"借入金2"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_loan0.periodYear]          forKey:@"借入期間0"];
    [settings setObject:[NSNumber numberWithInteger:_loan1.periodYear]          forKey:@"借入期間1"];
    [settings setObject:[NSNumber numberWithInteger:_loan2.periodYear]          forKey:@"借入期間2"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithFloat:_loan0.rateYear]              forKey:@"金利0"];
    [settings setObject:[NSNumber numberWithFloat:_loan1.rateYear]              forKey:@"金利1"];
    [settings setObject:[NSNumber numberWithFloat:_loan2.rateYear]              forKey:@"金利2"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithBool:_loan0.levelPayment]           forKey:@"元利均等返済0"];
    [settings setObject:[NSNumber numberWithBool:_loan1.levelPayment]           forKey:@"元利均等返済1"];
    [settings setObject:[NSNumber numberWithBool:_loan2.levelPayment]           forKey:@"元利均等返済2"];
    /*--------------------------------------*/
    [settings setObject:[NSNumber numberWithInteger:_startYear]                 forKey:@"借入開始年"];
    [settings setObject:[NSNumber numberWithInteger:_startMonth]                forKey:@"借入開始月"];
    /*--------------------------------------*/
    
    //保存する
    [settings writeToFile:plistFilePath atomically:YES];
    return;
}
/****************************************************************
 *
 ****************************************************************/
- (void)loadData
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"__loan.plist"]];
    
    NSMutableDictionary *setting;
    setting  = [NSMutableDictionary dictionaryWithContentsOfFile:plistFilePath];
    /*--------------------------------------*/
    _name0 = [setting objectForKey:@"設定名0"];
    _name1 = [setting objectForKey:@"設定名1"];
    _name2 = [setting objectForKey:@"設定名2"];
    /*--------------------------------------*/
    _loan0.loanBorrow   = [[setting objectForKey:@"借入金0"] longValue];
    _loan1.loanBorrow   = [[setting objectForKey:@"借入金1"] longValue];
    _loan2.loanBorrow   = [[setting objectForKey:@"借入金2"] longValue];
    /*--------------------------------------*/
    _loan0.periodYear   = [[setting objectForKey:@"借入期間0"] longValue];
    _loan1.periodYear   = [[setting objectForKey:@"借入期間1"] longValue];
    _loan2.periodYear   = [[setting objectForKey:@"借入期間2"] longValue];
    /*--------------------------------------*/
    _loan0.rateYear     = [[setting objectForKey:@"金利0"] floatValue];
    _loan1.rateYear     = [[setting objectForKey:@"金利1"] floatValue];
    _loan2.rateYear     = [[setting objectForKey:@"金利2"] floatValue];
    /*--------------------------------------*/
    _loan0.levelPayment = [[setting objectForKey:@"元利均等返済0"] boolValue];
    _loan1.levelPayment = [[setting objectForKey:@"元利均等返済1"] boolValue];
    _loan2.levelPayment = [[setting objectForKey:@"元利均等返済2"] boolValue];
    /*--------------------------------------*/
    _startYear          = [[setting objectForKey:@"借入開始年"] longValue];
    _startMonth         = [[setting objectForKey:@"借入開始月"] longValue];
    /*--------------------------------------*/
    
    
}
/****************************************************************/
@end
/****************************************************************/