//
//  DropboxEditorViewCtrl.h
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/14.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DBPath;

@interface DropboxEditorViewCtrl : UIViewController <UITextFieldDelegate>
@property (nonatomic) DBPath *dropboxPath;

@end
