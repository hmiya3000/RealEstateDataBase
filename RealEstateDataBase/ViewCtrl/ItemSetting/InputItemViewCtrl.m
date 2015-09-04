//
//  InputItemViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/03.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputItemViewCtrl.h"
#import "Pos.h"
#import "UIUtil.h"
#import "ModelDB.h"
#import "AddonMgr.h"

@interface InputItemViewCtrl ()
{
    ModelDB         *_db;
    Pos             *_pos;
    UIScrollView    *_scrollView;
    UILabel         *_l_title;
    UITextField     *_t_name;
    UIButton        *_btn_enter;
    UIButton        *_btn_cancel;
    
}
@end

@implementation InputItemViewCtrl

#define TTAG_NAME       1

#define BTAG_ENTER      1
#define BTAG_CANCEL     2
/****************************************************************
 *
 ****************************************************************/
- (id)init
{
    self = [super init];
    if (self){
        _db = [ModelDB sharedManager];
        self.title  = @"物件登録";
        self.tabBarItem.image = [UIImage imageNamed:@"building.png"];
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
    _l_title        = [UIUtil makeLabel:@"物件名を入力してください"];
    [_scrollView addSubview:_l_title];
    /****************************************/
    _t_name        = [UIUtil makeTextField:@"" tgt:self];
    _t_name.textAlignment   = NSTextAlignmentLeft;
    [_t_name   setTag:TTAG_NAME];
    [_t_name   setDelegate:(id)self];
    [_scrollView addSubview:_t_name];
    /****************************************/
    _btn_enter      = [UIUtil makeButton:@"決定" tag:BTAG_ENTER];
    [_btn_enter addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_btn_enter];
    /****************************************/
    _btn_cancel     = [UIUtil makeButton:@"キャンセル" tag:BTAG_CANCEL];
    [_btn_cancel addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_btn_cancel];
    /****************************************/

    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(view_Tapped:)];
    
    // ビューにジェスチャーを追加
    [self.view addGestureRecognizer:tapGesture];
    
    [self registerForKeyboardNotifications];
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self viewMake];
}

/****************************************************************
 *
 ****************************************************************/
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    return;
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
    [UIUtil setTextField:_t_name x:pos_x y:pos_y length:length30 ];
    /****************************************/
    pos_y = pos_y + dy;
    pos_y = pos_y + dy;
    [UIUtil setButton:_btn_enter    x:pos_x         y:pos_y length:length];
    [UIUtil setButton:_btn_cancel   x:pos_x+dx*2    y:pos_y length:length];
    
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
            NSLog(@"aaa");
            [_scrollView setContentOffset:CGPointZero animated:YES];
            break;
        default:
            break;
    }

    [self viewMake];
}

/****************************************************************
 * Returnでキーボードを閉じる
 ****************************************************************/
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



/**
 * ビューがタップされたとき
 */
- (void)view_Tapped:(UITapGestureRecognizer *)sender
{
    [_t_name resignFirstResponder];
//    NSLog(@"タップされました．");
}

/****************************************************************
 *
 ****************************************************************/
-(void)clickButton:(UIButton*)sender
{
    if ( sender.tag == BTAG_ENTER ){
        if ( [_t_name.text length] != 0 ){            
            if (  [_db isInitialized] == true ){
                AddonMgr *addonMgr = [AddonMgr sharedManager];
                [addonMgr activateFriend:_t_name.text];
            }
            [_db createRec:_t_name.text atIndex:0];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else if ( sender.tag == BTAG_CANCEL ){
        if ( _db.list.count != 0 ){
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
    return;
}

/****************************************************************
 *
 ****************************************************************/
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    CGPoint scrollPoint = CGPointMake(0.0,20.0);
    UIDeviceOrientation orientation =[[UIDevice currentDevice]orientation];
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:
            [_scrollView setContentOffset:scrollPoint animated:YES];
            break;
        default:
            break;
    }
    return;
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [_scrollView setContentOffset:CGPointZero animated:YES];
    return;
}
/****************************************************************
 *
 ****************************************************************/
-(void)closeKeyboard:(id)sender
{
    [UIUtil closeKeyboard:sender];
    
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
