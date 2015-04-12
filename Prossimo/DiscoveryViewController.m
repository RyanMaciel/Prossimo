//
//  DiscoveryViewController.m
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import "DiscoveryViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>

@protocol BarberViewTouchDelegate;

@interface BarberView : UIView
-(id)initWithBarber:(PFObject*)barber location:(CLLocationCoordinate2D)coordinate;
@property(assign, nonatomic)id<BarberViewTouchDelegate> touchDelegate;
@property(strong, nonatomic)PFObject *barber;
@end

@protocol BarberViewTouchDelegate
-(void)barberViewTouched:(BarberView*)view;
@end

@implementation BarberView

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.touchDelegate barberViewTouched:self];
}

//return the distance in miles based on the haversine formula
-(int)distanceToBarber:(PFObject*)barber fromLocation:(CLLocationCoordinate2D)coordinate{
    return [((PFGeoPoint*)barber[@"position"]) distanceInMilesTo:[PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude]];

}
-(void)addImage{
    UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin.jpg"]];
    userImage.frame = CGRectMake(0, 0, 60, 60);
    userImage.center = CGPointMake(userImage.frame.size.width/2 + 10, self.center.y);
    userImage.layer.cornerRadius = userImage.frame.size.width/2;
    userImage.clipsToBounds = YES;
    [self addSubview:userImage];
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
        self.barber = barber;
        CGFloat margin = 10;
        
        self.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = barber[@"username"];
        titleLabel.font = [titleLabel.font fontWithSize:20.0];
        [titleLabel sizeToFit];
        titleLabel.center = CGPointMake(80 + titleLabel.frame.size.width/2 + margin, self.frame.size.height * 1.5/4.0);
        [self addSubview:titleLabel];
        
        /*UILabel *nextLabel = [[UILabel alloc] init];
        nextLabel.text = [self parseNextLabel:barber[@"nextTime"]];
        nextLabel.font = [nextLabel.font fontWithSize:13.0];
        [nextLabel sizeToFit];
        nextLabel.center = CGPointMake(80 + nextLabel.frame.size.width/2 + margin, titleLabel.frame.origin.y + titleLabel.frame.size.height + margin);
        nextLabel.textColor = [UIColor grayColor];
        
        [self addSubview:nextLabel];*/
        
        UILabel *distanceLabel = [[UILabel alloc] init];
        distanceLabel.text = [NSString stringWithFormat:@"%i mi.",[self distanceToBarber:barber fromLocation:coordinate]];
        distanceLabel.font = [distanceLabel.font fontWithSize:17.0];
        [distanceLabel sizeToFit];
        distanceLabel.center = CGPointMake(self.frame.size.width - distanceLabel.frame.size.width/2 - margin, self.center.y);
        distanceLabel.textColor = [UIColor grayColor];
        
        [self addSubview:distanceLabel];
        
        UILabel *ratingLabel = [[UILabel alloc] init];
        ratingLabel.text = [NSString stringWithFormat:@"%.01f/5.0", [barber[@"barberRating"] floatValue]];
        ratingLabel.font = [ratingLabel.font fontWithSize:13.0];
        [ratingLabel sizeToFit];
        ratingLabel.center = CGPointMake(80 + ratingLabel.frame.size.width/2 + margin, titleLabel.frame.origin.y + titleLabel.frame.size.height + margin);
        ratingLabel.textColor = [UIColor grayColor];
        [self addSubview:ratingLabel];
        
        [self addImage];
        
    }
    return self;
}


@end
#import <CoreLocation/CoreLocation.h>
#import "BarberDiscoveryDataModel.h"
#import "BarberDetailViewController.h"

@interface DiscoveryViewController ()<DiscoveryLoadingDelegate, BarberViewTouchDelegate, CLLocationManagerDelegate>
@property(strong, nonatomic)BarberDiscoveryDataModel *discoveryModel;
@property(strong, nonatomic)PFObject *tappedBarber;
@property(strong, nonatomic)IBOutlet UIScrollView *scroller;

-(void)setUpApearance;

@end

@implementation DiscoveryViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"Detail"]){
        BarberDetailViewController *detail = segue.destinationViewController;
        detail.barber = self.tappedBarber;
        
    }
}

-(void)barberViewTouched:(BarberView *)view{
    self.tappedBarber = view.barber;
    [self performSegueWithIdentifier:@"Detail" sender:self];
}

-(void)discoveryLoaderFoundBarbers:(NSArray *)barbers{
    BarberView *bView;
    for(int i = 0; i < barbers.count; i++){
        
        PFObject *barber = barbers[i];
        bView = [[BarberView alloc] initWithBarber:barber location:[[CLLocation alloc] initWithLatitude:0 longitude:0].coordinate];
        bView.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, 5 + 0.5 * bView.frame.size.height/2 + bView.frame.size.height * i);
        bView.touchDelegate = self;
        [self.scroller addSubview:bView];
        
    }
    
    self.scroller.contentSize = CGSizeMake(self.scroller.contentSize.width, bView.center.y + bView.frame.size.height/2);
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

    
    [self setUpApearance];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpApearance{
    //Set the navigation controller color.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:250.0/255.0 green:70.0/255.0 blue:80.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor grayColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.title = @"Discover";
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
