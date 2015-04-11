//
//  DiscoveryViewController.m
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import "DiscoveryViewController.h"
#import <Parse/Parse.h>
@interface BarberView : UIView
-(id)initWithBarber:(PFObject*)barber location:(CLLocationCoordinate2D)coordinate;
@end

@implementation BarberView

//return the distance in miles based on the haversine formula
-(int)distanceToBarber:(PFObject*)barber fromLocation:(CLLocationCoordinate2D)coordinate{
    return [((PFGeoPoint*)barber[@"position"]) distanceInMilesTo:[PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude]];

}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

-(NSString*)parseNextLabel:(NSDate*)nextTime{
    return [self stringFromTimeInterval:[nextTime timeIntervalSinceDate:[NSDate date]]];
}

-(id)initWithBarber:(PFObject *)barber location:(CLLocationCoordinate2D)coordinate{
    self = [super initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width , 100)];
    if(self){
        
        CGFloat margin = 10;
        
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = barber[@"username"];
        titleLabel.font = [titleLabel.font fontWithSize:27.0];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(titleLabel.frame.size.width/2 + margin, self.frame.size.height * 1.5/4.0);
        [self addSubview:titleLabel];
        
        UILabel *nextLabel = [[UILabel alloc] init];
        nextLabel.text = [self parseNextLabel:barber[@"nextTime"]];
        nextLabel.font = [nextLabel.font fontWithSize:13.0];
        [nextLabel sizeToFit];
        nextLabel.center = CGPointMake(nextLabel.frame.size.width/2 + margin, titleLabel.frame.origin.y + titleLabel.frame.size.height + margin);
        nextLabel.textColor = [UIColor grayColor];
        
        [self addSubview:nextLabel];
        
        UILabel *distanceLabel = [[UILabel alloc] init];
        distanceLabel.text = [NSString stringWithFormat:@"%i Mi. away",[self distanceToBarber:barber fromLocation:coordinate]];
        distanceLabel.font = [nextLabel.font fontWithSize:13.0];
        [distanceLabel sizeToFit];
        distanceLabel.center = CGPointMake(self.frame.size.width - distanceLabel.frame.size.width, self.center.y);
        distanceLabel.textColor = [UIColor grayColor];
        
        [self addSubview:distanceLabel];
        
    }
    return self;
}


@end
#import <CoreLocation/CoreLocation.h>
#import "BarberDiscoveryDataModel.h"

@interface DiscoveryViewController ()<DiscoveryLoadingDelegate, CLLocationManagerDelegate>
@property(strong, nonatomic)BarberDiscoveryDataModel *discoveryModel;
@end

@implementation DiscoveryViewController

-(void)discoveryLoaderFoundBarbers:(NSArray *)barbers{
    for(int i = 0; i < barbers.count; i++){
        
        PFObject *barber = barbers[i];
        BarberView *bView = [[BarberView alloc] initWithBarber:barber location:[[CLLocation alloc] initWithLatitude:0 longitude:0].coordinate];
        bView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, 100 + (bView.frame.size.height + 20) * i);
        [self.view addSubview:bView];
    }
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    self.discoveryModel = [[BarberDiscoveryDataModel alloc] initWithCoordinate:((CLLocation*)locations[0]).coordinate];
    self.discoveryModel.loadingDelegate = self;
    
}

- (void)viewDidLoad {
    [self getUserLocation];
    self.view.backgroundColor = [UIColor grayColor];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getUserLocation{
    
    //Start the location manager
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.delegate = self;
    if ([manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [manager requestWhenInUseAuthorization];
    }
    NSLog(@"%i", [CLLocationManager authorizationStatus]);
    [manager startUpdatingLocation];
    [self locationManager:manager didUpdateLocations:@[[[CLLocation alloc] initWithLatitude:0 longitude:0]]];
}

@end
