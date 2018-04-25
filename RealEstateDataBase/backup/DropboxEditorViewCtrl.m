//
//  DropboxEditorViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/14.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "DropboxEditorViewCtrl.h"
#import "MBProgressHUD.h"

@interface DropboxEditorViewCtrl ()
@property (nonatomic) UITextField *nameField;
@property (nonatomic) UITextView *documentTextView;
@property (nonatomic,copy) NSString *fileText;
@end

@implementation DropboxEditorViewCtrl


//======================================================================
//
//======================================================================
-(void)viewDidLayoutSubviews
{
    CGSize size = self.view.frame.size;
    self.nameField.frame = CGRectMake(0,100,size.width,44);
    self.documentTextView.frame = CGRectMake(0,144,size.width,size.height-44);
}

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
#if 0
    [super viewDidLoad];
    self.nameField = [[UITextField alloc] init];
    self.nameField.borderStyle = UITextBorderStyleLine;
    self.nameField.text = [self.dropboxPath name];
    self.nameField.placeholder = [self.dropboxPath name];
    self.nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameField.delegate = self;
    [self.view addSubview:self.nameField];
    self.documentTextView = [[UITextView alloc] init];
    [self.view addSubview:self.documentTextView];
    [self loadFile];
#endif
}

//======================================================================
//
//======================================================================
-(void)loadFile
{
#if 0
    // completedFirstSyncがfalseの間はreadString:が待ちになる。これはファイルごと１回だけ発生します。
    // readString:をメインスレッドで実行すると警告が出ます
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DBError *error;
        DBFile *file = [[DBFilesystem sharedFilesystem] openFile:self.dropboxPath error:&error];
        // 待ちが発生する場合はprogress dialogを表示（メインスレッド）
        if ([file status] && !(file.status.cached)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            });
        }
        NSString *contents = [file readString:nil];
        // 読み込み完了後の画面表示
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.fileText = contents;
            self.documentTextView.text = contents;
        });
    });
#endif
}
//======================================================================
//
//======================================================================
-(void)viewWillDisappear:(BOOL)animated
{
    if (![self.documentTextView.text isEqualToString:self.fileText]) {
        [self saveFile];
    }
}
//======================================================================
//
//======================================================================
-(void)saveFile
{
#if 0
    DBError *error;
    DBFile *file = [[DBFilesystem sharedFilesystem] openFile:self.dropboxPath error:&error];
    BOOL ret = [file writeString:self.documentTextView.text error:nil];
    if (ret) {
        self.fileText = [NSString stringWithString:self.documentTextView.text];
    }else { // error
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Write Error" message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
#endif
}

//======================================================================
//
//======================================================================
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == self.nameField) {
        return [self renameFile:self.nameField.text];
    }
    return YES;
}
//======================================================================
//
//======================================================================
#pragma mark -
- (BOOL)renameFile:(NSString*)newName {
#if 0
    if ([newName length]==0) {
        self.nameField.text = [self.dropboxPath name];
        return YES;
    }else if ([newName isEqualToString:[self.dropboxPath name]]) {
        return YES;
    }
    // rename
    DBError *error;
    DBPath *newPath = [[DBPath root] childPath:newName];
    BOOL ret = [[DBFilesystem sharedFilesystem] movePath:self.dropboxPath toPath:newPath error:&error];
    if (ret) {
        self.dropboxPath = newPath;
        return YES;
    }else { // error
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Rename Error" message:error.description delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return NO;
    }
#else
    return YES;
#endif
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
