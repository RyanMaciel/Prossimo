//
//  BarberDiscoveryDataModel.h
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol DiscoveryLoadingDelegate <NSObject>

//May be called off the main thread.
-(void)discoveryLoaderFoundBarbers:(NSArray*)barbers;

@end

@interface BarberDiscoveryDataModel : NSObject
@property(assign, nonatomic)id<DiscoveryLoadingDelegate> loadingDelegate;
-(NSArray*)nearbyBarbers;
-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@end
