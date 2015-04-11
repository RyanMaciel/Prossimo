//
//  ViewController.m
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PFUser *user = [PFUser user];
    user.username = @"Ryan Barber";
    user.password = @"foobar";
    NSLog(@"%@", user.parseClassName);
    //[user signUp];
    //[user save];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
