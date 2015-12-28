//
//  ModelDB.m
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/22.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "ModelDB.h"
#import "ModelRE.h"
#import "AddonMgr.h"
#import "MBProgressHUD.h"

/****************************************************************/
static ModelDB* sharedModelDB = nil;
/****************************************************************/
@implementation ModelDB
{
    NSString *_exportFilename;
}
/****************************************************************/
@synthesize list    = _list;
/****************************************************************
 *
 ****************************************************************/
+ (ModelDB*)sharedManager
{
    @synchronized(self){
        if (sharedModelDB == nil ){
            sharedModelDB = [[self alloc ]init ];
        }
    }
    return sharedModelDB;
}
/****************************************************************
 *
 ****************************************************************/
+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self){
        if ( sharedModelDB == nil){
            sharedModelDB  = [super allocWithZone:zone];
            return sharedModelDB;
        }
    }
    return nil;
}
/****************************************************************
 *
 ****************************************************************/
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
/****************************************************************
 * 初期化
 ****************************************************************/
- (id)init {
    self = [super init];
    if (self) {
        _list = [NSMutableArray array];
        if ( [self isExistDataFile] == true){
            /* 設定ファイルがあったらロード */
#if 0
            [self deleteData];
            [self setDefaultData];
            [self saveData];
#endif
            [self loadData];
        } else {
#if 0
            NSLog(@"設定ファイルがなかったらデフォルト設定でファイル作成");
            [self setDefaultData];
            [self saveData];
#endif
        }
        _exportFilename = nil;
    }
    return self;
}

/****************************************************************
 * 選択されたIndexのレコードをロード
 ****************************************************************/
- (void) loadIndex:(NSInteger)index
{
    if ( [_list count] != 0){
        NSDictionary   *record = [_list objectAtIndex:index];
        NSString *name       = [record objectForKey:@"name"];
        NSString *serial    = [record objectForKey:@"serial"];
        ModelRE *modelRE = [ModelRE sharedManager];
        [modelRE fileToVal:serial name:name];
    }
    return;
}

/****************************************************************
 * 指定したIndexのレコードを削除
 ****************************************************************/
- (void) deleteIndex:(NSInteger)index
{
    NSDictionary *record = [_list objectAtIndex:index];
    NSString *serial = [record objectForKey:@"serial"];
    [_list removeObjectAtIndex:index];
    ModelRE *modelRE = [ModelRE sharedManager];
    [modelRE deleteItem:serial];
    [self saveData];
    return;
}
/****************************************************************
 * 指定したIndexから指定したIndexへレコードを移動
 ****************************************************************/
- (void) moveIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex
{
    NSDictionary *record = [_list objectAtIndex:fromIndex];
    [_list removeObjectAtIndex:fromIndex];
    [_list insertObject:record atIndex:toIndex];
    [self saveData];
    return;
}
/****************************************************************
 * 指定したIndexにレコードを挿入
 ****************************************************************/
- (void) insertRec:(NSDictionary*)record atIndex:(NSInteger)index
{
    [_list insertObject:record atIndex:index];
    [self saveData];
    return;
}
/****************************************************************
 * 新規レコードを追加(Index指定)
 ****************************************************************/
- (void) createRec:(NSString*)name atIndex:(NSInteger)index
{
    NSDictionary    *record = [NSDictionary dictionaryWithObjectsAndKeys:
                               name,@"name",
                               [self getNewId],@"serial",
                               nil];
    if ( _list != nil ){
        [self insertRec:record atIndex:index];
    } else {
        _list = [NSMutableArray array];
        [_list addObject:record];
        [self saveData];
    }
    return;
}

/****************************************************************
 * 新規レコードを追加(シリアル指定)
 ****************************************************************/
- (void) createRec:(NSString*)name serial:(NSString*)serial
{
    NSDictionary    *record = [NSDictionary dictionaryWithObjectsAndKeys:
                               name,@"name",
                               serial,@"serial",
                               nil];
    if ( _list == nil ){
        _list = [NSMutableArray array];
    }
    [_list addObject:record];
    [self saveData];
    return;
}

/****************************************************************
 * 登録レコードの更新
 ****************************************************************/
- (void) updateSerial:(NSString*)serial name:(NSString*)name
{
    /* 対象のIndexを抽出 */
    NSInteger index = [[_list valueForKey:@"serial"] indexOfObject:serial];

    /* レコードを更新 */
    NSDictionary *record = [NSDictionary dictionaryWithObjectsAndKeys:
                           name,@"name",
                           serial, @"serial",
                           nil];
    
    /* データベースのレコードを入れ替え */
    [_list replaceObjectAtIndex:index withObject:record];
    [self saveData];
}

/****************************************************************
 * 初期化直後
 ****************************************************************/
- (BOOL) isInitialized
{
    if ( [_list count] == 0 ){
        return true;
    } else {
        return false;
    }
}

/****************************************************************
 * 全データファイルの表示
 ****************************************************************/
- (void) showAllFiles
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:documentsDirectory
                                                     error:&error];
    
    // ファイルやディレクトリの一覧を表示する
    NSLog(@"----------");
    NSLog(@"ファイル一覧");
    NSLog(@"----------");
    for (NSString *files in list) {
        NSLog(@"%@",files );
    }
}
/****************************************************************
 * 全データファイルの削除
 ****************************************************************/
- (void) deleteAllFiles
{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    NSArray *list = [fileManager contentsOfDirectoryAtPath:documentsDirectory
                                                     error:&error];
    NSString *dbFilePath;
    // ファイルやディレクトリの一覧を表示する
    for (NSString *files in list) {
        dbFilePath = [documentsDirectory stringByAppendingPathComponent:files];
        BOOL result = [fileManager removeItemAtPath:dbFilePath error:&error];
        if (result) {
            NSLog(@"削除成功：%@", files);
        } else {
            NSLog(@"削除失敗：%@", error.description);
        }
    }
    [self loadData];
    return;
}

/****************************************************************
 * エクスポートファイル名を返す
 ****************************************************************/
- (void) createExportFilename
{
    NSCalendar          *calender = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger          flag = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents    *comp = [calender components:flag fromDate:[NSDate date]];

    _exportFilename = [NSString stringWithFormat:@"%4ld_%02ld%02ld_%02ld%02ld_%02ld.csv",
                       (long)comp.year,(long)comp.month,(long)comp.day,(long)comp.hour,(long)comp.minute,(long)comp.second];
    return;
}

/****************************************************************
 * エクスポートファイル名を返す
 ****************************************************************/
- (NSString*) getExportFilename
{
    if ( _exportFilename == nil ){
        [self createExportFilename];
    }
    return _exportFilename;
}

/****************************************************************
 * 全データファイルをエクスポート
 ****************************************************************/
- (NSString*) makeLocalFile:(NSString*)filename
{
    NSString *textBody  = [self createCSV];
    NSString *localDir  = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    [textBody writeToFile:localPath atomically:YES encoding:NSShiftJISStringEncoding error:nil];

    return localPath;
}

/****************************************************************
 * インポートファイル名を指定
 ****************************************************************/
- (void) importData:(NSString*)data
{
    NSMutableString *tmpStr;
    tmpStr = [NSMutableString stringWithString:data];
    NSString *keyStr;
    int i = 0;
    while (1) {
        NSRange r = [tmpStr rangeOfString:@"\n"];
        if ( r.location != NSNotFound ){
            NSString *str = [tmpStr substringToIndex:r.location];
            if ( i==0){
                keyStr = str;
            } else {
                [self importItem:str keyString:keyStr];
            }
            [tmpStr deleteCharactersInRange:NSMakeRange(0,r.location+1)];
        } else {
            break;
        }
        i++;
    }
    return;
}
/****************************************************************/
- (void) importItem:(NSString*)data keyString:(NSString*)keyStr
{
    /*--------------------*/
    NSRange r;
    NSString *serial;
    r = [data rangeOfString:@","];
    if ( r.location != NSNotFound ){
        /*--------------------*/
        serial = [data substringToIndex:r.location];
        /*--------------------*/
        if ( [self isExistSerial:serial] == false ){
            [self createRec:@"tmpName" serial:serial];
        }
        /*--------------------*/
        ModelRE *modelRE = [ModelRE sharedManager];
        [modelRE stringToVal:data keyString:keyStr];
        [modelRE valToFile];
    }
    return;
}
/****************************************************************/
- (BOOL) isExistSerial:(NSString*)serial
{
    NSInteger index;
    if ( _list == nil ){
        return false;
    } else {
        index = [[_list valueForKeyPath:@"serial"] indexOfObject:serial];
        if ( index > _list.count ){
            return false;
        } else {
            return true;
        }
    }
}
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************/
/****************************************************************
 * データベースのロード
 ****************************************************************/
- (void) loadData
{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *dbFilePath = [documentsDirectory stringByAppendingPathComponent:@"__db.plist"];
    
    
    NSMutableDictionary *setting;
    setting  = [NSMutableDictionary dictionaryWithContentsOfFile:dbFilePath];
    
    _list = [setting objectForKey:@"database"];
    if (_list) {
#if 0
        NSLog(@"LoadData");
        for (NSDictionary   *record in _list) {
            NSString    *str = [record objectForKey:@"name"];
            NSLog(@"%@",str);
        }
#endif
    } else {
        NSLog(@"%@", @"データが存在しません。");
    }
    return;
}
/****************************************************************
 * データベースのセーブ
 ****************************************************************/
- (void) saveData
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *dbFilePath = [documentsDirectory stringByAppendingPathComponent:@"__db.plist"];
    
    NSMutableDictionary *settings;
    settings  = [NSMutableDictionary dictionary];
    [settings setObject:_list forKey:@"database"];
    [settings  writeToFile:dbFilePath atomically:YES];
    
#if 0
    NSLog(@"SaveData!!!");
    for (NSDictionary   *record in _list) {
        NSLog(@"%@",[record objectForKey:@"name"]);
    }
#endif
    return;
}
/****************************************************************
 * データベースファイルの有無確認
 ****************************************************************/
- (BOOL) isExistDataFile
{
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *plistFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"__db.plist"]];
    
    // ファイルマネージャを作成
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    return [fileManager fileExistsAtPath:plistFilePath];
    
}
/****************************************************************
 * サンプル用のデフォルトデータベースの作成
 ****************************************************************/
- (void) setDefaultData
{
    _list = [NSMutableArray arrayWithObjects:
             @{@"name":@"名称未設定",     @"serial" : @"0"},
             nil];
    return;
}
/****************************************************************
 * 新規シリアルIDの生成
 ****************************************************************/
- (NSString*) getNewId
{
    NSInteger index;
    NSInteger serial;
    NSString  *str;
    
    if ( _list == nil ){
        str = @"0";
    } else {
        serial = 0;
        while(1){
            str = [NSString stringWithFormat:@"%ld",(long)serial];
            index = [[_list valueForKeyPath:@"serial"] indexOfObject:str];
            if ( index > _list.count )break;
            serial++;
        }
    }
    return str;
}

/****************************************************************
 * 
 ****************************************************************/
- (NSString*) createCSV
{

    NSString *csvText;
    ModelRE *modelRE = [ModelRE sharedManager];

    csvText = [NSString stringWithString:[modelRE titleString]];
    [self loadData];
    
    if (_list) {
        for (NSDictionary   *record in _list) {
            NSString    *serial = [record objectForKey:@"serial"];
            NSString    *name   = [record objectForKey:@"name"];
            NSString    *tmpStr = [modelRE valToString:serial name:name];
            csvText = [csvText stringByAppendingString:tmpStr];
        }
    }
        
    return csvText;
}

/****************************************************************/
@end
/****************************************************************/