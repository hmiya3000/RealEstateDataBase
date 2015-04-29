//
//  ImportViewCtrl.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/18.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>

@interface ImportViewCtrl : UITableViewController<DBRestClientDelegate>
{
    NSArray         *_filesArray;
}

///@property (nonatomic, strong) DBDatastore *datastore;
@property (nonatomic) NSArray *filesArray;


@end
