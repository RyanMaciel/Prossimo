//
//  BarberDetailViewController.m
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import "BarberDetailViewController.h"

@interface BarberDetailViewController ()

@end

@implementation BarberDetailViewController

-(IBAction)sendRequest{
    [PFCloud callFunctionInBackground:@"BarberRequest" withParameters:@{@"Barber" : self.barber, @"User" : [PFUser currentUser], @"StartTime" : [NSDate date]} block:^(NSString *response, NSError *error) {
        if (!error) {
            
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
