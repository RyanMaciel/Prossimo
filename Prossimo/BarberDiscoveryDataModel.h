//
//  BarberDiscoveryDataModel.h
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface BarberDiscoveryDataModel : NSObject
-(NSArray*)nearbyBarbers;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
