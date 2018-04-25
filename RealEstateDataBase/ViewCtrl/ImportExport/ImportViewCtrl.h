//
//  ImportViewCtrl.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/18.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ObjectiveDropboxOfficial/ObjectiveDropboxOfficial.h>

@interface ImportViewCtrl : UITableViewController
{
    NSArray         *_filesArray;
    NSString        *_path;
}

///@property (nonatomic, strong) DBDatastore *datastore;
@property (nonatomic) NSArray *filesArray;
@property (nonatomic) NSString *path;


@end
