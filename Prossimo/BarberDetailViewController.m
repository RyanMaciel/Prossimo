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
    [PFCloud callFunctionInBackground:@"barber" withParameters:@{@"barberid" : self.barber.objectId} block:^(NSString *response, NSError *error) {
        if (!error) {
            
        }
    }];
}
#warning attribute https://www.flickr.com/photos/rheinitz/13279135145/in/photolist-ijt91L-e9p4tD-fSxsuz-mer3eX-eCGX2Q-cCaXbd-f5yTwq-nAkqXt-pcUqZt-dT7DzX-6czmoh-iZGkso-nMCU8B-6WTzRd-huZacx-6hbaJY-4SQPvG-9HkcYL-57FHwK-c8QFJQ-mAVBFK-4pYusW-97wZJZ-7tpqcp-obhqWn-nNyET3-psEMrJ-agSVXw-pL3CCd-dxea2R-9qD1tt-9qG2bU-bDZKz4-fjgDUC-5NqScy-q5Puzz-hdRLGS-bFDoX-pvmXE2-5CEYNc-hLNETw-9YRkCp-eVttWA-8AoJj6-j3i4dM-kozstA-8ArMAy-7UYDWx-qWXPpT-ofucAp

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self sendRequest];
    
    // Do any additional setup after loading the view.
}

-(void)addImage{
    
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
