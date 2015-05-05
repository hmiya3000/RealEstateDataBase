//
//  ImportExportHelpViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2015/05/02.
//  Copyright (c) 2015年 Beetre. All rights reserved.
//

#import "ImportExportHelpViewCtrl.h"
#import "UIUtil.h"
#import "Pos.h"

@interface ImportExportHelpViewCtrl ()
{
    UILabel                 *_l_title;
    UIScrollView            *_scrollView;
    UITextView              *_tv_contents;
    Pos                     *_pos;
}
@end

@implementation ImportExportHelpViewCtrl
/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        self.view.backgroundColor = [UIUtil color_LightYellow];
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
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_title        = [UIUtil makeLabel:@"データの入出力"];
    [_scrollView addSubview:_l_title];
    /****************************************/
    _tv_contents                = [[UITextView alloc]init];
    _tv_contents.editable       = false;
    _tv_contents.scrollEnabled  = false;
    _tv_contents.backgroundColor = [UIUtil color_LightYellow];
    _tv_contents.text           = [NSString stringWithFormat:@"アドオンを購入することにより物件データをDropBoxを使ってcsvファイルに出力することができます\nまたDropBoxに置いたファイルを読み込むことができます\n\nこの機能により物件データのバックアップを取ることができ、複数の機種間でのデータ共有を行えます"];
    [_scrollView addSubview:_tv_contents];
    /****************************************/
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
    
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self viewMake];
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewMake
{
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
    [UIUtil setLabel:_l_title x:pos_x y:pos_y length:length30];
    /****************************************/
    pos_y = pos_y + dy;
    _tv_contents.frame      = CGRectMake(pos_x,         pos_y, _pos.len30, dy*7);
    
    /****************************************/
    return;
}

/****************************************************************
 * 回転していいかの判別
 ****************************************************************/
- (BOOL)shouldAutorotate
{
    return YES;
}

/****************************************************************
 * 回転処理の許可
 ****************************************************************/
- (NSUInteger)supportedInterfaceOrientations
{
    //    NSLog(@"%s",__FUNCTION__);
    //    return UIInterfaceOrientationMaskPortrait;
    return UIInterfaceOrientationMaskAll;
}

/****************************************************************
 * 回転時に処理したい内容
 ****************************************************************/
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"%s",__FUNCTION__);
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    switch (orientation) {
        case UIDeviceOrientationPortrait:
        case UIDeviceOrientationPortraitUpsideDown:
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
            //            [_scrollView setContentOffset:CGPointZero animated:YES];
            break;
        default:
            break;
    }
    
    [self viewMake];
}

/**
 * ビューがタップされたとき
 */
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    //    NSLog(@"タップされました．");
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
