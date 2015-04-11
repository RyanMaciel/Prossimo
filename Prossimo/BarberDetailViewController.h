//
//  BarberDetailViewController.h
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface BarberDetailViewController : UIViewController
@property(strong, nonatomic)PFObject *barber;
@end
