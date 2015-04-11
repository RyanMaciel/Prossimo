//
//  BarberDiscoveryDataModel.m
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import "BarberDiscoveryDataModel.h"
#import <Parse/Parse.h>

@interface BarberDiscoveryDataModel()

@end

@implementation BarberDiscoveryDataModel


-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate{
    self = [super init];
    if(self){
        
        //Query parse to find the best barbers in the database.
        PFQuery *barberQuery = [PFQuery queryWithClassName:@"_User"];
        
        #warning limit miles.
        //limit the query to 40 miles;
        [barberQuery whereKey:@"position" nearGeoPoint:[PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude]];

        
        [barberQuery whereKey:@"isBarber" equalTo:[NSNumber numberWithBool:YES]];
        
        [barberQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
            [self.loadingDelegate discoveryLoaderFoundBarbers:objects];
        }];
        
        
    }
    return self;
}

@end
