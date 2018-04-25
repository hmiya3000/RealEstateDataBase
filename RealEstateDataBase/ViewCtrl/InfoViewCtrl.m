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
#import "DisclaimerViewCtrl.h"
#import "ExportViewCtrl.h"
#import "ImportViewCtrl.h"
#import "PDFViewCtrl.h"
#import "ImportExportHelpViewCtrl.h"
#import "AddonViewCtrl.h"
#import "AddonMgr.h"
#import "ViewMgr.h"

@interface InfoViewCtrl ()
{
    ModelDB                 *_modelDB;

    UIScrollView            *_scrollView;
    UILabel                 *_l_appname;
    UITextView              *_tv_comment;
    UILabel                 *_l_TitleTools;
    Pos                     *_pos;

    UILabel                 *_l_multiYear;
    UILabel                 *_l_opeSetting;
    UILabel                 *_l_database;
    UILabel                 *_l_saleAnalysis;
    UILabel                 *_l_importExport;
    UILabel                 *_l_pdfOut;

    UISwitch                *_sw_multiYear;
    UISwitch                *_sw_opeSetting;
    UISwitch                *_sw_database;
    UISwitch                *_sw_saleAnalysis;
    UISwitch                *_sw_importExport;
    UISwitch                *_sw_pdfOut;
    
    UIButton                *_b_disclaimer;
    UIButton                *_b_initial;
    UIButton                *_b_dropbox;
    UIButton                *_b_import;
    UIButton                *_b_export;
    UIButton                *_b_pdf;

    UIViewController        *_disclaimerVC;

    UIViewController        *_importVC;
    UINavigationController  *_importNAC;
    
    UIViewController        *_exportVC;
    UINavigationController  *_exportNAC;
    
    UIViewController        *_pdfVC;
    UINavigationController  *_pdfNAC;
    
    UIViewController        *_dropboxVC;
    UINavigationController  *_dropboxNAC;

    UIViewController        *_addonVC;
    UINavigationController  *_addonNAC;
    AddonMgr                *_addOnMgr;
}
@end

//======================================================================
@implementation InfoViewCtrl
//======================================================================
#define BTAG_INITIAL    1
#define BTAG_IMPORT     2
#define BTAG_EXPORT     3
#define BTAG_PDF        4
#define BTAG_DISCLAIMER 6

#define STAG_MULTIYEAR  1
#define STAG_OPESETTING 2
#define STAG_SALE       3
#define STAG_DATABASE   4
#define STAG_IMPORT     5
#define STAG_PDFOUT     6
//======================================================================
@synthesize masterVC    = _masterVC;
//======================================================================

//======================================================================
//
//======================================================================
- (id)init
{
    self = [super init];
    if (self){
        self.title = @"Info";
        self.tabBarItem.image = [UIImage imageNamed:@"info-s.png"];
        self.view.backgroundColor = [UIUtil color_LightYellow];
        _masterVC   = nil;
    }
    return self;
}

//======================================================================
//
//======================================================================
-(void)viewDidLoad
{
    [super viewDidLoad];    
    _modelDB    = [ModelDB sharedManager];
    _addOnMgr   = [AddonMgr sharedManager];
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_appname          = [UIUtil makeLabel:[NSString stringWithFormat:@"%@    %@",[_addOnMgr getStrAppMode:_addOnMgr.appMode],VERSION ]];
    [_l_appname setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_l_appname];
    /****************************************/
    _tv_comment    = [[UITextView alloc]init];
    _tv_comment.editable       = false;
    _tv_comment.scrollEnabled  = true;
    _tv_comment.text           = [NSString stringWithFormat:@""];
    _tv_comment.text       = APP_COMMENT;
    [_scrollView addSubview:_tv_comment];
    /****************************************/
    _b_disclaimer  = [UIUtil makeButton:@"免責事項" tag:BTAG_DISCLAIMER];
    [_b_disclaimer addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_disclaimer];
    /****************************************/
    _l_multiYear        = [UIUtil makeLabel:@"複数年分析"];
    [_l_multiYear setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_multiYear];
    /*--------------------------------------*/
    _sw_multiYear       = [[UISwitch alloc]init];
    [_sw_multiYear addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    _sw_multiYear.tag   = STAG_MULTIYEAR;
    [_scrollView addSubview:_sw_multiYear];
    /****************************************/
    _l_opeSetting       = [UIUtil makeLabel:@"運営設定"];
    [_l_opeSetting setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_opeSetting];
    /*--------------------------------------*/
    _sw_opeSetting       = [[UISwitch alloc]init];
    [_sw_opeSetting addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    _sw_opeSetting.tag   = STAG_OPESETTING;
    [_scrollView addSubview:_sw_opeSetting];
    /****************************************/
    _l_database         = [UIUtil makeLabel:@"データベース"];
    [_l_database setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_database];
    /*--------------------------------------*/
    _sw_database       = [[UISwitch alloc]init];
    [_sw_database addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    _sw_database.tag   = STAG_DATABASE;
    [_scrollView addSubview:_sw_database];
    /****************************************/
    _l_saleAnalysis     = [UIUtil makeLabel:@"売却分析"];
    [_l_saleAnalysis setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_saleAnalysis];
    /*--------------------------------------*/
    _sw_saleAnalysis       = [[UISwitch alloc]init];
    [_sw_saleAnalysis addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    _sw_saleAnalysis.tag   = STAG_SALE;
    [_scrollView addSubview:_sw_saleAnalysis];
    /****************************************/
    _l_importExport     = [UIUtil makeLabel:@"外部データ"];
    [_l_importExport setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_importExport];
    /*--------------------------------------*/
    _sw_importExport       = [[UISwitch alloc]init];
    [_sw_importExport addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    _sw_importExport.tag   = STAG_IMPORT;
    [_scrollView addSubview:_sw_importExport];
    /****************************************/
#if 0
    _l_pdfOut           = [UIUtil makeLabel:@"PDF出力"];
    [_l_pdfOut setTextAlignment:NSTextAlignmentLeft];
    [_scrollView addSubview:_l_pdfOut];
    /*--------------------------------------*/
    _sw_pdfOut          = [[UISwitch alloc]init];
    [_sw_pdfOut addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    _sw_pdfOut.tag   = STAG_PDFOUT;
    [_scrollView addSubview:_sw_pdfOut];
#endif
    /****************************************/
    _l_TitleTools          = [UIUtil makeLabel:@"ツール"];
    [_l_appname setTextAlignment:NSTextAlignmentCenter];
    [_scrollView addSubview:_l_TitleTools];
    /****************************************/
    _b_initial  = [UIUtil makeButton:@"初期化" tag:BTAG_INITIAL];
    [_b_initial addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_initial];
    /****************************************/
    _b_import  = [UIUtil makeButton:@"Import" tag:BTAG_IMPORT];
    [_b_import addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_import];
    /****************************************/
    _b_export  = [UIUtil makeButton:@"Export" tag:BTAG_EXPORT];
    [_b_export addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_export];
#if 0
    /****************************************/
    _b_pdf      = [UIUtil makeButton:@"PDF" tag:BTAG_PDF];
    [_b_pdf addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_pdf];
    /****************************************/
    _b_dropbox  = [UIUtil makeButton:@"Dropbox" tag:BTAG_DROPBOX];
    [_b_dropbox addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_b_dropbox];
#endif
    /****************************************/

}

//======================================================================
// ビューの表示直前に呼ばれる
//======================================================================
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self rewriteProperty];
    [self viewMake];

    ViewMgr  *viewMgr   = [ViewMgr sharedManager];
    if ( viewMgr.stage == STAGE_DATALIST ){
        //すでにDATALISTステージにいる場合
        if ( viewMgr.reqViewInit == true ){
            self.tabBarController.selectedIndex = 0;
        }
    } else {
        if ( [viewMgr isReturnDataList ] == true ){
            [self dismissViewControllerAnimated:YES completion:nil];
            viewMgr.stage   = STAGE_DATALIST;
        }
    }
    return;
}
//======================================================================
// ビューのレイアウト作成
//======================================================================
-(void)viewMake
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
    [_scrollView setFrame:_pos.frame];
    /*--------------------------------------*/
    NSString *model = [UIDevice currentDevice].model;
    if ( [model hasPrefix:@"iPhone"] ){
        if ( _pos.isPortrait == true ){
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*(1.6-0.5));
        } else {
            _scrollView.contentSize = CGSizeMake(_pos.frame.size.width, _pos.frame.size.height*(2.9-1.0));
        }
        _scrollView.bounces = YES;
    } else {
    }
    /****************************************/
    pos_y   = 0.2*dy;
    [UIUtil setRectLabel:_l_appname x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
    /****************************************/
    pos_y   = pos_y + dy;
    _tv_comment.frame      = CGRectMake(pos_x,         pos_y, length30, dy*3);
    /****************************************/
    pos_y   = pos_y + 3*dy;
    [UIUtil setButton:_b_disclaimer x:pos_x y:pos_y length:length];
    /****************************************/
    pos_y = pos_y + dy;
    [UIUtil setLabel:_l_multiYear       x:pos_x y:pos_y length:length*2];
    _sw_multiYear.center = CGPointMake( pos_x+2.5*dx,pos_y+dy/2);
    /****************************************/
    pos_y   = pos_y + dy;
    [UIUtil setLabel:_l_opeSetting      x:pos_x y:pos_y length:length*2];
    _sw_opeSetting.center = CGPointMake( pos_x+2.5*dx,pos_y+dy/2);
    /****************************************/
    pos_y   = pos_y + dy;
    [UIUtil setLabel:_l_saleAnalysis    x:pos_x y:pos_y length:length*2];
    _sw_saleAnalysis.center = CGPointMake( pos_x+2.5*dx,pos_y+dy/2);
    /****************************************/
    pos_y   = pos_y + dy;
    [UIUtil setLabel:_l_database        x:pos_x y:pos_y length:length*2];
    _sw_database.center = CGPointMake( pos_x+2.5*dx,pos_y+dy/2);
    /****************************************/
    pos_y   = pos_y + dy;
    [UIUtil setLabel:_l_importExport    x:pos_x y:pos_y length:length*3];
    _sw_importExport.center = CGPointMake( pos_x+2.5*dx,pos_y+dy/2);
    /****************************************/
#if 0
    pos_y   = pos_y + dy;
    [UIUtil setLabel:_l_pdfOut          x:pos_x y:pos_y length:length*2];
    _sw_pdfOut.center = CGPointMake( pos_x+2.5*dx,pos_y+dy/2);
#endif
    /****************************************/
    pos_y   = pos_y + dy;
    [UIUtil setRectLabel:_l_TitleTools  x:pos_x y:pos_y viewWidth:length30 viewHeight:dy color:[UIUtil color_Yellow]];
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
//
//======================================================================
-(void)clickButton:(UIButton*)sender
{
    if ( sender.tag == BTAG_DISCLAIMER){
        _disclaimerVC   = [[DisclaimerViewCtrl alloc]init];
        [self presentViewController:_disclaimerVC animated:YES completion:nil];
    } else if ( sender.tag == BTAG_INITIAL ){
        UIAlertController *_as_clear;
        _as_clear = [UIAlertController alertControllerWithTitle:@"全データを初期化しますか？"
                                                        message:@"購入情報は初期化しません"
                                                 preferredStyle:UIAlertControllerStyleAlert];
        [_as_clear addAction:[UIAlertAction actionWithTitle:@"実行する" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            AddonMgr *addonMgr = [AddonMgr sharedManager];
            if ( addonMgr.friendMode == true ){
                [addonMgr initializeAddons];
            }
            [_modelDB  deleteAllFiles];
            ViewMgr *viewMgr = [ViewMgr sharedManager];
            viewMgr.reqViewInit = true;
            if ( [viewMgr isReturnDataList ] == true ){
                [self dismissViewControllerAnimated:YES completion:nil];
                viewMgr.stage   = STAGE_DATALIST;
            }
            if ( self.masterVC != nil ){
                self.tabBarController.selectedIndex = 0;
                [self.masterVC viewWillAppear:YES];
            }
        }]];
        [_as_clear addAction:[UIAlertAction actionWithTitle:@"やめる"  style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //何もしない
        }]];
        [self presentViewController:_as_clear animated:YES completion:nil];
        [_modelDB showAllFiles];

    } else if ( sender.tag == BTAG_IMPORT){
        if ( _addOnMgr.importExport == true ){
            _importVC       = [[ImportViewCtrl alloc]init];
            _importNAC      = [[UINavigationController alloc]initWithRootViewController:_importVC];
            [self presentViewController:_importNAC animated:YES completion:nil];
        } else {
            _importVC       = [[ImportExportHelpViewCtrl alloc]init];
            if ( self.navigationController != nil ){
                [self.navigationController pushViewController:_importVC animated:YES];
            } else {
                [self presentViewController:_importVC animated:YES completion:nil];
            }
        }

    } else if ( sender.tag == BTAG_EXPORT){
        if ( _addOnMgr.importExport == true ){
            _exportVC       = [[ExportViewCtrl alloc]init];
            _exportNAC      = [[UINavigationController alloc]initWithRootViewController:_exportVC];
            [self presentViewController:_exportNAC animated:YES completion:nil];
        } else {
            _exportVC       = [[ImportExportHelpViewCtrl alloc]init];
            if ( self.navigationController != nil ){
                [self.navigationController pushViewController:_exportVC animated:YES];
            } else {
                [self presentViewController:_exportVC animated:YES completion:nil];
            }
        }
    } else if ( sender.tag == BTAG_PDF){
        _pdfVC       = [[PDFViewCtrl alloc]init];
        _pdfNAC      = [[UINavigationController alloc]initWithRootViewController:_pdfVC];
        [self presentViewController:_pdfNAC animated:YES completion:nil];

    }
}

//======================================================================
//
//======================================================================
-(void) switchChange:(UISwitch *)sw
{
    if ( _addOnMgr.friendMode == true ){
        [self startAddonViewCtrl];
        return;
    }

    switch (sw.tag) {
        case STAG_MULTIYEAR:
            sw.on = _addOnMgr.multiYear;
            if ( _addOnMgr.multiYear == false ){
                [self startAddonViewCtrl];
            }
            break;
        case STAG_OPESETTING:
            sw.on =  _addOnMgr.opeSetting;
            if ( _addOnMgr.opeSetting == false ){
                [self startAddonViewCtrl];
            }
            break;
        case STAG_SALE:
            sw.on = _addOnMgr.saleAnalysys;
            if ( _addOnMgr.saleAnalysys == false ){
                [self startAddonViewCtrl];
            }
            break;
        case STAG_DATABASE:
            sw.on = _addOnMgr.database;
            if ( _addOnMgr.database == false ){
                [self startAddonViewCtrl];
            }
            break;
        case STAG_IMPORT:
            sw.on = _addOnMgr.importExport;
            if ( _addOnMgr.importExport == false ){
                [self startAddonViewCtrl];
            }
            break;
        case STAG_PDFOUT:
            sw.on = _addOnMgr.pdfOut;
            if ( _addOnMgr.pdfOut == false ){
                [self startAddonViewCtrl];
            }
            break;
        default:
            break;
    }
    

}

//======================================================================
//
//======================================================================
-(void) startAddonViewCtrl
{
    _addonVC        = [[AddonViewCtrl alloc]init];
    _addonNAC         = [[UINavigationController alloc]initWithRootViewController:_addonVC];
    [self presentViewController:_addonNAC animated:YES completion:nil];
}

//======================================================================
// 表示する値の更新
//======================================================================
-(void)rewriteProperty
{

    _l_appname.text = [NSString stringWithFormat:@"%@    %@",[_addOnMgr getStrAppMode:_addOnMgr.appMode],VERSION ];
    /*--------------------------------------*/
    _sw_multiYear.on    = _addOnMgr.multiYear;
    _sw_opeSetting.on   = _addOnMgr.opeSetting;
    _sw_saleAnalysis.on = _addOnMgr.saleAnalysys;
    _sw_database.on     = _addOnMgr.database;
    _sw_importExport.on = _addOnMgr.importExport;
    _sw_pdfOut.on       = _addOnMgr.pdfOut;
    /*--------------------------------------*/
}

@end
