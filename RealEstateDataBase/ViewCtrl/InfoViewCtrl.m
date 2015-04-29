//
//  InfoViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/08/17.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InfoViewCtrl.h"
#import "ModelDB.h"
#import "UIUtil.h"
#import "Pos.h"
#import "DropboxTableVC.h"
#import "ExportViewCtrl.h"
#import "ImportViewCtrl.h"
#import "PDFViewCtrl.h"

@interface InfoViewCtrl ()
{
    ModelDB                 *_modelDB;
    UILabel                 *_l_version;
    Pos                     *_pos;
    
    UIButton                *_b_initial;
    UIButton                *_b_dropbox;
    UIButton                *_b_import;
    UIButton                *_b_export;
    UIButton                *_b_pdf;

    UIViewController        *_importVC;
    UINavigationController  *_importNAC;
    
    UIViewController        *_exportVC;
    UINavigationController  *_exportNAC;
    
    UIViewController        *_pdfVC;
    UINavigationController  *_pdfNAC;
    
    UIViewController        *_dropboxVC;
    UINavigationController  *_dropboxNAC;


}
@end

@implementation InfoViewCtrl

#define BTAG_INITIAL    1
#define BTAG_IMPORT     2
#define BTAG_EXPORT     3
#define BTAG_PDF        4
#define BTAG_DROPBOX    5

/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.title = @"Info";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
        _modelDB = [ModelDB sharedManager];
    }
    return self;
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /****************************************/
    _l_version      = [UIUtil makeLabel:@"version 0.99"];
    [self.view addSubview:_l_version];
    /****************************************/
    _b_initial  = [UIUtil makeButton:@"初期化" tag:BTAG_INITIAL];
    [_b_initial addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_b_initial];
    /****************************************/
    _b_import  = [UIUtil makeButton:@"Import" tag:BTAG_IMPORT];
    [_b_import addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_b_import];
    /****************************************/
    _b_export  = [UIUtil makeButton:@"Export" tag:BTAG_EXPORT];
    [_b_export addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_b_export];
    /****************************************/
    _b_pdf      = [UIUtil makeButton:@"PDF" tag:BTAG_PDF];
    [_b_pdf addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_b_pdf];
    /****************************************/
#if 1
    _b_dropbox  = [UIUtil makeButton:@"Dropbox" tag:BTAG_DROPBOX];
    [_b_dropbox addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_b_dropbox];
#endif
    /****************************************/
    [self viewMake];

#if 0
    self.datastore = [[DBDatastoreManager sharedManager] openDefaultDatastore:nil];
    DBTable *tasksTbl = [self.datastore getTable:@"tasks"];
    DBRecord *firstTask = [tasksTbl insert:@{ @"taskname": @"Buy milk", @"completed": @NO }];
    [self.datastore sync:nil];
#endif
}

/****************************************************************
 *
 ****************************************************************/
- (void) viewMake
{
    /****************************************/
    CGFloat pos_x,pos_y,dx,dy,length,length30;
    _pos        = [[Pos alloc]initWithUIViewCtrl:self];
    pos_x       = _pos.x_left;
    dx          = _pos.dx;
    dy          = _pos.dy;
    length      = _pos.len10;
    length30    = _pos.len30;
    /****************************************/
    pos_y = _pos.y_top -dy;
    /****************************************/
    pos_y   = pos_y + dy;
    pos_y   = pos_y + dy;
    pos_y   = pos_y + dy;
    pos_y   = pos_y + dy;
    [UIUtil setLabel:_l_version x:pos_x y:pos_y length:length30];

    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setButton:_b_initial x:pos_x y:pos_y length:length];
    /****************************************/
    pos_y = pos_y + dy;
    pos_y = pos_y + dy;
    [UIUtil setButton:_b_import     x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setButton:_b_export     x:pos_x+dx*1    y:pos_y length:length];
    pos_y = pos_y + dy;
    [UIUtil setButton:_b_pdf        x:pos_x+dx*0    y:pos_y length:length];
    [UIUtil setButton:_b_dropbox    x:pos_x+dx*2    y:pos_y length:length];
    
}

/****************************************************************
 * ビューの表示直前に呼ばれる
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewMake];
    return;
}

/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    if ( sender.tag == BTAG_INITIAL ){
        UIAlertView *_as_clear;
        _as_clear = [[UIAlertView alloc] init];
        _as_clear.title = @"設定を初期化しますか？";
        _as_clear.delegate = self;
        [_as_clear addButtonWithTitle:@"実行する" ];
        [_as_clear addButtonWithTitle:@"やめる" ];
        [_as_clear show];
        [_modelDB showAllFiles];
    } else if ( sender.tag == BTAG_IMPORT){
        _importVC       = [[ImportViewCtrl alloc]init];
        _importNAC      = [[UINavigationController alloc]initWithRootViewController:_importVC];
        [self presentViewController:_importNAC animated:YES completion:nil];

    } else if ( sender.tag == BTAG_EXPORT){
        _exportVC       = [[ExportViewCtrl alloc]init];
        _exportNAC      = [[UINavigationController alloc]initWithRootViewController:_exportVC];
        [self presentViewController:_exportNAC animated:YES completion:nil];
        
    } else if ( sender.tag == BTAG_PDF){
        _pdfVC       = [[PDFViewCtrl alloc]init];
        _pdfNAC      = [[UINavigationController alloc]initWithRootViewController:_pdfVC];
        [self presentViewController:_pdfNAC animated:YES completion:nil];

    } else if ( sender.tag == BTAG_DROPBOX){
        _dropboxVC  = [[DropboxTableVC alloc]init];
        _dropboxNAC        = [[UINavigationController alloc]initWithRootViewController:_dropboxVC];
        [self presentViewController:_dropboxNAC animated:YES completion:nil];
    }
}

/****************************************************************
 *
 ****************************************************************/
- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [_modelDB  deleteAllFiles];
            break;
        case 1:
            break;
        default:
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
