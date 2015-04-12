//
//  BarberDetailModel.h
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@protocol AppointmentDownloadDelegate <NSObject>

-(void)appointmentsLoaded:(NSArray*)appointments;

@end

@interface BarberDetailModel : NSObject
@property(assign, nonatomic)id<AppointmentDownloadDelegate> downloadDelegate;
-(id)initWithBarber:(PFObject*)barber;
@end
