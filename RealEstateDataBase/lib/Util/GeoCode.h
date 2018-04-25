//
//  GeoCode.h
//  RealEstateDataBase
//
//  Created by hmiya on 2015/12/26.
//  Copyright © 2015年 Beetre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapKit/MapKit.h"

@interface GeoCode : NSObject

+ (CLLocationCoordinate2D)AddressToyLocation2D:(NSString*)address;
+ (NSString*)Locationjj2DToAddress:(CLLocationCoordinate2D)location2D;

@end
