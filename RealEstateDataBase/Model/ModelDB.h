//
//  ModelDB.h
//  LoanHikaku
//
//  Created by MiyazakiHironobu on 2014/07/22.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DropboxSDK/DropboxSDK.h>

@interface ModelDB : NSObject
{
    NSMutableArray          *_list;

}
/****************************************************************/
+ (ModelDB*)sharedManager;
- (void) loadIndex:(NSInteger)index;
- (void) deleteIndex:(NSInteger)index;
- (void) moveIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex;
- (void) insertRec:(NSDictionary*)record atIndex:(NSInteger)index;
- (void) createRec:(NSString*)name atIndex:(NSInteger)index;
- (void) updateSerial:(NSString*)serial name:(NSString*)name;
- (void) showAllFiles;
- (void) deleteAllFiles;
- (void) createExportFilename;
- (NSString*) getExportFilename;
- (NSString*) makeLocalFile:(NSString*)filename;
/////- (void) exportAllFiles:(DBPath*)dbpath;
- (void) importData:(NSString*)data;
/****************************************************************/
@property   (nonatomic)     NSMutableArray  *list;
/****************************************************************/
@end
/****************************************************************/
