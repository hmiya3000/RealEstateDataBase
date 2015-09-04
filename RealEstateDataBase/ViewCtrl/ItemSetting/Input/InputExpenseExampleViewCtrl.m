//
//  InputExpenseExampleViewCtrl.m
//  RealEstateDataBase
//
//  Created by hmiya on 2014/09/23.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "InputExpenseExampleViewCtrl.h"
#import "Pos.h"
#import "UIUtil.h"
#import "ModelRE.h"
#import "Expense.h"
@interface InputExpenseExampleViewCtrl ()
{
    ModelRE             *_modelRE;
    Pos             *_pos;
    UIScrollView    *_scrollView;
    UILabel         *_l_title;
    UITextView      *_tv_contents;
    UITextView      *_tv_contentsVal;
    
    Expense         *_expense;
    
}
@end

@implementation InputExpenseExampleViewCtrl

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
    _modelRE    = [ModelRE sharedManager];
    _expense    = [[Expense alloc]initWithPrice:_modelRE.estate.prices.price
                                     loanBorrow:_modelRE.investment.loan.loanBorrow];
    /****************************************/
    _scrollView     = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_scrollView];
    /****************************************/
    _l_title        = [UIUtil makeLabel:@"諸費用の内訳例"];
    [_scrollView addSubview:_l_title];
    /****************************************/
    _tv_contents                = [[UITextView alloc]init];
    _tv_contents.editable       = false;
    _tv_contents.scrollEnabled  = false;
    _tv_contents.backgroundColor = [UIUtil color_LightYellow];
    _tv_contents.text           = [NSString stringWithFormat:@"■売買契約関係\n　仲介手数料\n　印紙代\n\n■ローン関係\n　借入契約印紙代\n　火災保険(概算)\n　抵当権設定登記費用\n\n■登記関係\n　所有権移転登記費用\n　司法書士報酬\n\n■税金\n　不動産取得税\n\n合計"];
    [_scrollView addSubview:_tv_contents];
    /****************************************/
    _tv_contentsVal                = [[UITextView alloc]init];
    _tv_contentsVal.editable       = false;
    _tv_contentsVal.scrollEnabled  = false;
    _tv_contentsVal.backgroundColor = [UIUtil color_LightYellow];
    _tv_contentsVal.textAlignment  = NSTextAlignmentRight;
    _tv_contentsVal.text           = [NSString stringWithFormat:@"\n%@\n%@\n\n\n%@\n%@\n%@\n\n\n%@\n%@\n\n\n%@\n\n%@",
                                      [UIUtil yenValue:_expense.brokenCom],
                                      [UIUtil yenValue:_expense.stamp],
                                      [UIUtil yenValue:_expense.stamp],
                                      [UIUtil yenValue:_expense.fireInsurance],
                                      [UIUtil yenValue:_expense.mortgageReg],
                                      [UIUtil yenValue:_expense.ownershipReg],
                                      [UIUtil yenValue:_expense.scrivener],
                                      [UIUtil yenValue:_expense.acquisitionTax],
                                      [UIUtil yenValue:_expense.sum]];
    [_scrollView addSubview:_tv_contentsVal];
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
    [super viewWillAppear:animated];
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
    _tv_contents.frame      = CGRectMake(pos_x,         pos_y, _pos.len10*2, dy*7);
    _tv_contentsVal.frame   = CGRectMake(pos_x+dx*2,    pos_y, _pos.len10, dy*7);
    pos_y = pos_y + dy;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
