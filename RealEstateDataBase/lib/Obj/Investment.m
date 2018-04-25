//
//  Investment.m
//  RealEstate
//
//  Created by MiyazakiHironobu on 2014/06/07.
//  Copyright (c) 2014年 Beetre. All rights reserved.
//

#import "Investment.h"

@implementation Investment
{
}
//======================================================================
@synthesize price               = _price;
@synthesize gpi                 = _gpi;
@synthesize interest            = _interest;
@synthesize loan                = _loan;
@synthesize emptyRate           = _emptyRate;
@synthesize mngRate             = _mngRate;
@synthesize propTaxRate         = _propTaxRate;
@synthesize incomeTaxRate       = _incomeTaxRate;
@synthesize expense             = _expense;
@synthesize equity              = _equity;
@synthesize opexEtc             = _opexEtc;
@synthesize bootMonth           = _bootMonth;
@synthesize isCompany           = _isCompany;

//======================================================================
//
//======================================================================
-(id) initWithPrice:(NSInteger)price gpi:(NSInteger)gpi;
{
    self = [super init];
    if ( self != nil){
        _loan           = [[Loan alloc]init];
        _price          = price;
        _gpi            = gpi;
        _equity         = 0;
        if ( _price != 0 ){
            _interest       = (CGFloat)gpi/price;
        } else {
            _interest       = 0;
        }
    }
    return self;
}
//======================================================================
//
//======================================================================
-(id)copyWithZone:(NSZone*)zone
{
    // 複製を保存するためのインスタンスを生成します。
    Investment* result = [[[self class] allocWithZone:zone] init];
    
    if (result){
        result.price    = _price;
        result.loan     = _loan;
    }
    
    return result;
}
//======================================================================
//
//======================================================================
-(void)setPrice:(NSInteger)price
{
    _price      = price;
    if ( _price != 0 && _gpi != 0 ){
        _interest   = (CGFloat)_gpi / _price;
    }
}
//======================================================================
//
//======================================================================
-(void)setGpi:(NSInteger)gpi
{
    _gpi        = gpi;
    if ( _price != 0 && _gpi != 0 ){
        _interest   = (CGFloat)_gpi / _price;
    }
}
//======================================================================
//
//======================================================================
- (void)setIncomeTaxRate:(CGFloat)incomeTaxRate
{
    _incomeTaxRate = incomeTaxRate;
    NSInteger idx = 0;
    if ( incomeTaxRate <= 0.16 ){
        idx = 0;
    } else if ( 0.16 < incomeTaxRate && incomeTaxRate <= 0.21 ){
        idx = 1;
    } else if ( 0.21 < incomeTaxRate && incomeTaxRate <= 0.215 ){
        idx = 7;
    } else if ( 0.215 < incomeTaxRate && incomeTaxRate <= 0.233 ){
        idx = 8;
    } else if ( 0.233 < incomeTaxRate && incomeTaxRate <= 0.31 ){
        idx = 2;
    } else if ( 0.31 < incomeTaxRate && incomeTaxRate <= 0.34 ){
        idx = 3;
    } else if ( 0.34 < incomeTaxRate && incomeTaxRate <= 0.37 ){
        idx = 9;
    } else if ( 0.37 < incomeTaxRate && incomeTaxRate <= 0.44 ){
        idx = 4;
    } else if ( 0.44 < incomeTaxRate && incomeTaxRate <= 0.51 ){
        idx = 5;
    } else if ( 0.51 < incomeTaxRate ){
        idx = 6;
    } else {
        idx = 0;
    }
    switch (idx) {
        case 7:
        case 8:
        case 9:
            _isCompany = true;
            break;
        default:
            _isCompany = false;
            break;
        }
}
//======================================================================
//
//======================================================================
-(void) adjustEquity
{
    _equity = _price + _expense - _loan.loanBorrow;
}
//======================================================================
//
//======================================================================
-(void) adjustLoanBorrow
{
    _loan.loanBorrow = _price + _expense - _equity;
}
//======================================================================
//
//======================================================================
- (void)setBootMonth:(NSInteger)bootMonth
{
    _bootMonth = bootMonth;
    
}
//======================================================================
//
//======================================================================
-(Operation*) getOperation_year:(NSInteger)year
                            gpi:(NSInteger)gpi
                           loan:(Loan*)loan
                        propTax:(NSInteger)propTax
              amortizationCosts:(NSInteger)amortizationCosts
                     house_area:(CGFloat)houseArea
{
    Operation *opeYear = [[Operation alloc]init];
    
    opeYear.gpi         = gpi;
    opeYear.emptyLoss   = gpi * _emptyRate;
    opeYear.egi         = gpi - opeYear.emptyLoss;
    opeYear.opex_tax    = propTax;
    opeYear.opex_mng    = opeYear.egi  * _mngRate;
    opeYear.opex_etc    = _opexEtc;
    opeYear.opex        = opeYear.opex_tax + opeYear.opex_mng + opeYear.opex_etc;
    opeYear.noi         = opeYear.egi - opeYear.opex;
    opeYear.ads         = [loan getPmtYear:year];
    opeYear.btcf        = opeYear.noi - opeYear.ads;
    opeYear.amCost      = amortizationCosts;
    /*--------------------------------------*/
    opeYear.taxIncome = opeYear.noi - [_loan getIpmtYear:year] - opeYear.amCost;
    if ( opeYear.taxIncome > 0){
        opeYear.tax    = opeYear.taxIncome * _incomeTaxRate;
    } else {
        opeYear.tax    = 0;
    }
    opeYear.atcf   = opeYear.btcf - opeYear.tax;
    
    if ( _price == 0 ){
        /* 未設定の場合には計算しない */
        opeYear.fcr            = 0;
        opeYear.loanConst      = 0;
        opeYear.ccr            = 0;
        opeYear.pb             = 0;
        opeYear.dcr            = 0;
        opeYear.ber            = 0;
        opeYear.ltv            = 0;
        opeYear.capRate        = 0;
    } else {
        opeYear.fcr        = (CGFloat)opeYear.noi / ( _price + _expense);
        if ( _loan.loanBorrow != 0 ){
            opeYear.loanConst  = (CGFloat)opeYear.ads / _loan.loanBorrow;
        } else {
            opeYear.loanConst  = 0;
        }
        if ( _equity != 0 ){
            opeYear.ccr        = (CGFloat)opeYear.btcf / _equity;
        } else {
            opeYear.ccr        = 0;
        }
        if ( opeYear.btcf != 0 ){
            opeYear.pb         = (CGFloat)_equity / opeYear.btcf;
        } else {
            opeYear.pb         = 0;
        }
        if ( opeYear.ads != 0 ){
            opeYear.dcr        = (CGFloat)opeYear.noi / opeYear.ads;
        } else {
            opeYear.dcr        = 0;
        }
        if ( gpi != 0 ){
            opeYear.ber        = (CGFloat)(opeYear.opex + opeYear.ads ) / gpi;
        } else {
            opeYear.ber        = 0;
        }
        opeYear.ltv        = (CGFloat)loan.loanBorrow / _price;
        opeYear.capRate    = (CGFloat)opeYear.noi / _price;
        
        opeYear.rentUnitPrice   = opeYear.gpi / houseArea;
        opeYear.yieldNfc        = (CGFloat)opeYear.noi / _price;
        opeYear.yieldAmo        = (CGFloat)(opeYear.noi- amortizationCosts)/ _price;
        
        
    }
    return opeYear;
}
//======================================================================
//
//======================================================================
-(Operation*) getOperation_start_term:(NSInteger)start_term
                         new_gpi_term:(NSInteger)new_gpi_term
                             end_term:(NSInteger)end_term
                         aqu_tax_term:(NSInteger)aqu_tax_term
                             prop_tax:(NSInteger)propTax
                             acqu_tax:(NSInteger)acquTax
                                 gpi1:(NSInteger)gpi1
                                 gpi2:(NSInteger)gpi2
                                 loan:(Loan*)loan
                    amortizationCosts:(NSInteger)amortizationCosts
{
    Operation *ope = [[Operation alloc]init];
    
    //変な範囲にあった場合の補正
    if ( new_gpi_term <= start_term ){
        ope.gpi = (end_term-start_term+1)*gpi2/12;
    } else if ( new_gpi_term >= end_term ){
        ope.gpi = (end_term-start_term+1)*gpi1/12;
    } else {
        ope.gpi = ((new_gpi_term-start_term)*gpi1 + (end_term-new_gpi_term+1)*gpi2 ) /12;
    }
    
    ope.emptyLoss   = ope.gpi * _emptyRate;
    ope.egi         = ope.gpi - ope.emptyLoss;
    ope.opex_tax    = propTax;
    ope.opex_mng    = ope.egi  * _mngRate;
    ope.opex_etc    = _opexEtc * (end_term - start_term +1) / 12;
    ope.opex        = ope.opex_tax + ope.opex_mng + ope.opex_etc;
    ope.noi         = ope.egi - ope.opex;

    ope.ads = 0;
    NSInteger ipmt = 0;
    for(NSInteger term=start_term; term<=end_term; term++){
        ope.ads = ope.ads + [loan getPmt:term];
        ipmt    = ipmt    + [loan getIpmt:term];
    }
    ope.btcf        = ope.noi - ope.ads;

    //初期投資の計算
    ope.initCost = 0;   //初回だけかかるので通常はゼロ
    if ( start_term == 0 ){
        ope.initCost    = _equity - acquTax;
    }
    if ( start_term<= aqu_tax_term && aqu_tax_term <= end_term ){
        ope.initCost = ope.initCost + acquTax;
    }
    
    ope.amCost      = amortizationCosts;
    /*--------------------------------------*/
    ope.taxIncome = ope.noi - ipmt - ope.amCost - ope.initCost;
    if ( ope.taxIncome > 0){
        ope.tax    = ope.taxIncome * _incomeTaxRate;
    } else {
        ope.tax    = 0;
    }
    ope.atcf   = ope.btcf - ope.tax;
    
    if ( _price == 0 ){
        /* 未設定の場合には計算しない */
        ope.fcr            = 0;
        ope.loanConst      = 0;
        ope.ccr            = 0;
        ope.pb             = 0;
        ope.dcr            = 0;
        ope.ber            = 0;
        ope.ltv            = 0;
        ope.capRate        = 0;
    } else {
        ope.fcr        = (CGFloat)ope.noi / ( _price + _expense);
        if ( _loan.loanBorrow != 0 ){
            ope.loanConst  = (CGFloat)ope.ads / _loan.loanBorrow;
        } else {
            ope.loanConst  = 0;
        }
        if ( _equity != 0 ){
            ope.ccr        = (CGFloat)ope.btcf / _equity;
        } else {
            ope.ccr        = 0;
        }
        if ( ope.btcf != 0 ){
            ope.pb         = (CGFloat)_equity / ope.btcf;
        } else {
            ope.pb         = 0;
        }
        if ( ope.ads != 0 ){
            ope.dcr        = (CGFloat)ope.noi / ope.ads;
        } else {
            ope.dcr        = 0;
        }
        if ( ope.gpi != 0 ){
            ope.ber        = (CGFloat)(ope.opex + ope.ads ) / ope.gpi;
        } else {
            ope.ber        = 0;
        }
        ope.ltv        = (CGFloat)loan.loanBorrow / _price;
        ope.capRate    = (CGFloat)ope.noi / _price;
    }
    return ope;
}
//======================================================================
@end
//======================================================================
