//
//  BarberDetailModel.m
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import "BarberDetailModel.h"
@implementation BarberDetailModel

-(void)getAppointments:(PFObject*)barber{
    PFQuery *queryAppointments = [[PFQuery alloc] initWithClassName:@"Appointments"];
    [queryAppointments whereKey:@"Barber" equalTo:barber];
    [queryAppointments orderByAscending:@"startDate"];
    [queryAppointments findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(objects && !error)[self.downloadDelegate appointmentsLoaded:objects];
    }];
}

-(id)initWithBarber:(PFObject*)barber{
    self = [super init];
    if(self){
        
        [self getAppointments:barber];
        
    }
    return self;
}


@end
