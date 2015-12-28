//
//  AppDelegate.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/08/16.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>
#import "UIUtil.h"
#import "AddonMgr.h"
#import "ViewMgr.h"

#import "DataBaseIPhoneViewCtrl.h"
#import "DataBaseIPadViewCtrl.h"

/****************************************************************/
@implementation AppDelegate
{
    UIWindow                    *_window;

    UISplitViewController       *_iPadVC;
    DataBaseIPhoneViewCtrl      *_iPhoneVC;
    
}
/****************************************************************/
@synthesize managedObjectContext        = _managedObjectContext;
@synthesize managedObjectModel          = _managedObjectModel;
@synthesize persistentStoreCoordinator  = _persistentStoreCoordinator;
/****************************************************************/
#define APP_KEY     @"330rpbyqebi60n2"
#define APP_SECRET  @"rhh5cev809t6ak2"
/****************************************************************/


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:APP_KEY
                            appSecret:APP_SECRET
                            root: kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    

    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.backgroundColor = [UIUtil color_LightYellow];
    [_window makeKeyAndVisible];


    NSString *model     = [UIDevice currentDevice].model;
    ViewMgr  *viewMgr   = [ViewMgr sharedManager];
    viewMgr.stage       = STAGE_TOP;
    
    if ( [model hasPrefix:@"iPhone"] ){
        NSLog(@"iPhone");
        _iPhoneVC           = [[DataBaseIPhoneViewCtrl alloc]init];
        _window.rootViewController  = _iPhoneVC;
        
    } else if ( [model hasPrefix:@"iPad"]){
        NSLog(@"iPad");
        _iPadVC             = [[DataBaseIPadViewCtrl alloc]init];
        _iPadVC.delegate    = self;
        _window.rootViewController  = _iPadVC;

    }
    [self.window makeKeyAndVisible];
    
#if 0
    
    DBAccountManager* accountMgr =
    [[DBAccountManager alloc] initWithAppKey:APP_KEY
                                      secret:APP_SECRET];
    [DBAccountManager setSharedManager:accountMgr];
    DBAccount *account = [DBAccountManager sharedManager].linkedAccount;
    if (account) {
        DBFilesystem *filesystem = [[DBFilesystem alloc] initWithAccount:account];
        [DBFilesystem setSharedFilesystem:filesystem];
    }
#endif

    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];


    sleep(1);   //起動画面を保持
    return YES;
}

/****************************************************************/
- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

/****************************************************************/
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    NSLog(@"Not App linked successfully!");
    return NO;

    
#if 0
    NSLog(@"%s",__FUNCTION__);
    DBAccount *account = [[DBAccountManager sharedManager] handleOpenURL:url];
    if (account) {
        NSLog(@"App linked successfully!");
        // Migrate any local datastores to the linked account
        DBDatastoreManager *localManager = [DBDatastoreManager localManagerForAccountManager:
                                            [DBAccountManager sharedManager]];
        [localManager migrateToAccount:account error:nil];
        // Now use Dropbox datastores
        [DBDatastoreManager setSharedManager:[DBDatastoreManager managerForAccount:account]];
        return YES;
    }
    return NO;
#endif
}

/****************************************************************/
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"RealEstateDataBase" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"RealEstateDataBase.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}
/****************************************************************/



#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
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
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    AddonMgr *addonMgr = [AddonMgr sharedManager];
    
    NSLog(@"paymentQueue:updatedTransactions");
    for (SKPaymentTransaction *transaction in transactions ){
        switch (transaction.transactionState) {
                /****************************************/
            case SKPaymentTransactionStatePurchasing:
            {
                NSLog(@"SKPaymentTransactionStatePurchasing");
                break;
            }
                /****************************************/
            case SKPaymentTransactionStatePurchased:
            {
                NSLog(@"SKPaymentTransactionStatePurchased");
                //設定にProductIDを保存する
                [addonMgr saveProductId:transaction.payment.productIdentifier];
                //購入処理成功したことを通知する
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Purchased" object:transaction];
                [queue finishTransaction:transaction];
                break;
            }
                /****************************************/
            case SKPaymentTransactionStateRestored:
            {
                NSLog(@"SKPaymentTransactionStateRestored");
                //設定にProductIDを保存する
                [addonMgr saveProductId:transaction.payment.productIdentifier];
                //リストアが成功したことを通知する
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Purchased" object:transaction];
                [queue finishTransaction:transaction];
                break;
            }
                /****************************************/
            case SKPaymentTransactionStateDeferred:
            {
                NSLog(@"SKPaymentTransactionStateDeferred");
                break;
            }
                /****************************************/
            case SKPaymentTransactionStateFailed:
            {
                NSLog(@"SKPaymentTransactionStateFailed");
                [queue finishTransaction:transaction];
                NSError *error = transaction.error;
                NSString *errormsg = [NSString stringWithFormat:@"%@ [%ld]",error.localizedDescription, (long)error.code];
                [[[UIAlertView alloc]initWithTitle:@"エラー" message:errormsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                if ( transaction.error.code != SKErrorPaymentCancelled ){
                    //支払いキャンセル
                    NSLog(@"支払いキャンセル");
                } else if ( transaction.error.code == SKErrorUnknown ){
                    //請求先情報の入力画面に移り、購入処理を強制終了した
                    NSLog(@"請求先情報の入力画面に移り、購入処理を強制終了した");
                } else {
                    //その他のエラー
                    NSLog(@"その他のエラー");
                }
                break;
            }
        }
    }
    return;
}
/****************************************************************
 * すべての購入が正常終了した時に実行
 ****************************************************************/
- (void) paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PurchasedAll" object:transactions];
    return;
}

/****************************************************************
 * すべてのリストアが正常終了した時に実行
 ****************************************************************/
- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreOK" object:queue];
    return;
    
}
/****************************************************************
 * リストアが失敗した時に実行
 ****************************************************************/
- (void) paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RestoreNG" object:error];
    return;
}


/****************************************************************/
@end
/****************************************************************/
