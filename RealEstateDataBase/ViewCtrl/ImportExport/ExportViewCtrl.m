//
//  ExportViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/10/18.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "ExportViewCtrl.h"
#import "UIUtil.h"
#import "ModelDB.h"
#import "Pos.h"
#import "MBProgressHUD.h"

@interface ExportViewCtrl ()
{
    ModelDB                     *_modelDB;
    Pos                         *_pos;
    
    UIScrollView                *_scrollView;
    UILabel                     *_l_filename;
    UITextView                  *_tv_tips;
    UIButton                    *_b_exec;

    NSString                    *_localPath;
    NSString                    *_tmpfile;
    DBUserClient                *_userClient;
}
@end

@implementation ExportViewCtrl

#define BTAG_EXEC       1

//======================================================================
//
//======================================================================
- (id)init
{
    self = [super init];
    if (self){
        self.title  = @"エクスポート";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
    }
    return self;
}

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];
    _modelDB = [ModelDB sharedManager];
    [_modelDB createExportFilename];
    
    UIBarButtonItem *retButton =
    [[UIBarButtonItem alloc] initWithTitle:@"戻る"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(retButtonTapped:)];
    self.navigationItem.leftBarButtonItem = retButton;

    UIBarButtonItem *accountButton =
    [[UIBarButtonItem alloc] initWithTitle:@"アカウント"
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(accountButtonTapped:)];
    self.navigationItem.rightBarButtonItem = accountButton;
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_filename     = [UIUtil makeLabel:[_modelDB getExportFilename]];
    [_scrollView addSubview:_l_filename];
    /****************************************/
    _tv_tips                = [[UITextView alloc]init];
    _tv_tips.editable       = false;
    _tv_tips.scrollEnabled  = false;
    _tv_tips.backgroundColor = [UIUtil color_LightYellow];
    _tv_tips.text           = @"アプリ内のデータをこのファイル名で出力します";
    [_scrollView addSubview:_tv_tips];
    /****************************************/
    _b_exec  = [UIUtil makeButton:@"実行" tag:BTAG_EXEC];
    [_b_exec addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_exec];
    /****************************************/

    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
}
//======================================================================
// ビューの表示直前に呼ばれる
//======================================================================
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!DBClientsManager.authorizedClient && !DBClientsManager.authorizedTeamClient){
        [DBClientsManager authorizeFromController:UIApplication.sharedApplication
                                       controller:self
                                          openURL:^(NSURL *url){
                                              [UIApplication.sharedApplication openURL:url
                                                                               options:@{}
                                                                     completionHandler:nil];
                                          }
         ];
    }
    [self rewriteProperty];
    [self viewMake];
}
//======================================================================
// ビューのレイアウト作成
//======================================================================
-(void)viewMake{
    /****************************************/
    CGFloat pos_x,pos_y,dx,dy,length,lengthR,length30;
    _pos = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy;
    length      = _pos.len10;
    lengthR     = _pos.len15;
    length30    = _pos.len30;
    /****************************************/
    [_scrollView setFrame:_pos.frame];
    /****************************************/
    pos_y = 0;
    if ( _pos.isPortrait == true ){
        [UIUtil setLabel:_l_filename x:pos_x y:pos_y length:_pos.len30];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*1);
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        pos_y = pos_y + dy;
        [UIUtil setButton:_b_exec       x:pos_x+dx*1    y:pos_y length:length];

    }else {
        [UIUtil setLabel:_l_filename x:pos_x y:pos_y length:_pos.len30];
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        _tv_tips.frame = CGRectMake(pos_x, pos_y, _pos.len30, dy*1);
        /*--------------------------------------*/
        pos_y = pos_y + dy;
        pos_y = pos_y + dy;
        [UIUtil setButton:_b_exec       x:pos_x+dx*1    y:pos_y length:length];
        /*--------------------------------------*/
    }
    return;
}

//======================================================================
// 回転していいかの判別
//======================================================================
-(BOOL)shouldAutorotate
{
    return YES;
}

//======================================================================
// 回転処理の許可
//======================================================================
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
//======================================================================
// 回転時に処理したい内容
//======================================================================
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            break;
        default:
            break;
    }
    [self viewMake];
}
//======================================================================
// ビューがタップされたとき
//======================================================================
-(void)view_Tapped:(UITapGestureRecognizer *)sender
{
    //    [_t_name resignFirstResponder];
    //    NSLog(@"タップされました．");
}
//======================================================================
// 表示する値の更新
//======================================================================
-(void)rewriteProperty
{
}

//======================================================================
//
//======================================================================
- (IBAction)retButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//======================================================================
//
//======================================================================
- (IBAction)accountButtonTapped:(id)sender
{
//    [[DBSession sharedSession] linkFromController:self];
    return;
}

//======================================================================
//
//======================================================================
- (void)uploadFileWithClient:(DBUserClient *)client uploadData:(NSString *)uploadData inputData:(NSData*)inputData
{
    DBFILESWriteMode *mode = [[DBFILESWriteMode alloc] initWithOverwrite];
    DBUploadTask *task = [client.filesRoutes uploadData:uploadData
                                                mode:mode
                                          autorename:@(YES)
                                      clientModified:nil
                                                mute:@(NO)
                                      propertyGroups:nil
                                           inputData:inputData];
    [task setResponseBlock:^(DBFILESFileMetadata *result, DBFILESUploadError *routeError, DBRequestError *networkError) {
        if (result) {
            NSLog(@"%@\n", result);
        } else {
            NSLog(@"%@\n%@\n", routeError, networkError);
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [task start];
}

//======================================================================
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    if ( sender.tag == BTAG_EXEC ){
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // Write a file to the local documents directory
        _tmpfile  = [_modelDB getExportFilename];
        _localPath = [_modelDB makeLocalFile:_tmpfile];
        NSLog(@"~~~~~~%@",_localPath);
        NSString *destDir = @"/";
        NSString *uploadData = [NSString stringWithFormat:@"%@%@",destDir,_tmpfile];
        NSData *inputData = [[NSData alloc]initWithContentsOfFile:_localPath];
        _userClient = [DBClientsManager authorizedClient];
        // Upload file to Dropbox
        [self uploadFileWithClient:_userClient uploadData:uploadData inputData:inputData];
    }
}
//======================================================================
@end
//======================================================================
