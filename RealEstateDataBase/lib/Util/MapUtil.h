//
//  MapUtil.h
//  RealEstateDataBase
//
//  Created by hmiya on 2017/04/10.
//  Copyright © 2017年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

//======================================================================
@interface MapUtil : NSObject
{
    enum {
        CODE_UNKNOWN        = 0,
        //------------
        CODE_HOKKAIDO       = 1,
        CODE_AOMORI         = 2,
        CODE_IWATE          = 3,
        CODE_MIYAGI         = 4,
        CODE_AKITA          = 5,
        CODE_YAMAGATA       = 6,
        CODE_FUKUSHIMA      = 7,
        //------------
        CODE_IBARAKI        = 8,
        CODE_TOCHIGI        = 9,
        CODE_GUNMA          = 10,
        CODE_SAITAMA        = 11,
        CODE_CHIBA          = 12,
        CODE_TOKYO          = 13,
        CODE_KANAGAWA       = 14,
        //------------
        CODE_NIIGATA        = 15,
        CODE_TOYAMA         = 16,
        CODE_ISHIKAWA       = 17,
        CODE_FUKUI          = 18,
        CODE_YAMANASHI      = 19,
        CODE_NAGANO         = 20,
        CODE_GIFU           = 21,
        CODE_SHIZUOKA       = 22,
        CODE_AICHI          = 23,
        CODE_MIE            = 24,
        //------------
        CODE_SHIGA          = 25,
        CODE_KYOTO          = 26,
        CODE_OSAKA          = 27,
        CODE_HYOGO          = 28,
        CODE_NARA           = 29,
        CODE_WAKAYAMA       = 30,
        //------------
        CODE_TOTTORI        = 31,
        CODE_SHIMANE        = 32,
        CODE_OKAYAMA        = 33,
        CODE_HIROSHIMA      = 34,
        CODE_YAMAGUCHI      = 35,
        //------------
        CODE_TOKUSHIMA      = 36,
        CODE_KAGAWA         = 37,
        CODE_EHIME          = 38,
        CODE_KOCHI          = 39,
        //------------
        CODE_FUKUOKA        = 40,
        CODE_SAGA           = 41,
        CODE_NAGASAKI       = 42,
        CODE_KUMAMOTO       = 43,
        CODE_OITA           = 44,
        CODE_MIYAZAKI       = 45,
        CODE_KAGOSHIMA      = 46,
        CODE_OKINAWA        = 47
    };
}
//======================================================================
-(void)addressToLocate:(id)callbackInstance selector:(SEL)callbackSelector address:(NSString*)address;
-(void)locateToAddress:(id)callbackInstance selector:(SEL)callbackSelector locate2d:(CLLocationCoordinate2D)loc2d;
+(NSInteger) prefectureToCode:(NSString*)prefecture;
+(bool)isSetLoc:(CLLocationCoordinate2D)loc2d;
//======================================================================
@end
//======================================================================
