//
//  BarberDetailViewController.m
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//



#import "BarberDetailViewController.h"

@class BarberDetailView;

@protocol BarberDetailViewInterationDelegate <NSObject>
-(void)barberDetailViewTapped:(BarberDetailView*)view;

@end

@interface BarberDetailView : UIView
@property(assign, nonatomic)id<BarberDetailViewInterationDelegate> interactionDelegate;
@end
@implementation BarberDetailView

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.interactionDelegate barberDetailViewTapped:self];
}

-(id)initWithFrame:(CGRect)frame labelString:(NSString*)string{
    if(self = [super initWithFrame:frame]){
        
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = string;
        [timeLabel sizeToFit];
        timeLabel.center = CGPointMake(10 + timeLabel.frame.size.width/2, self.center.y);
        [self addSubview:timeLabel];
    }
    return self;
}

@end

#import "BarberDetailModel.h"

@interface BarberDetailViewController ()<AppointmentDownloadDelegate, BarberDetailViewInterationDelegate>
-(void)setUpLabels;
-(void)addImage;
-(void)setUpBottomWithAppointments:(NSArray *)appointment;
-(NSString*)stringTime:(NSDate*)date;

@property(strong, nonatomic)BarberDetailModel *detailModel;
@end

@implementation BarberDetailViewController

-(void)barberDetailViewTapped:(BarberDetailView *)view{
    [self performSegueWithIdentifier:@"schedule" sender:self];
}

-(void)appointmentsLoaded:(NSArray *)appointments{
    [self setUpBottomWithAppointments:appointments];
}

-(NSString*)stringTime:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    return minute < 10 ? [NSString stringWithFormat:@"%li:%li0", (long)hour, (long)minute] : [NSString stringWithFormat:@"%li:%li", (long)hour, (long)minute];
}
-(void)setUpBottomWithAppointments:(NSArray *)appointments{
    
    UILabel *available = [[UILabel alloc] init];
    available.text = @"Available Times:";
    available.textColor = [UIColor grayColor];
    [available sizeToFit];
    available.center = CGPointMake(self.view.center.x, 200 - available.frame.size.height/2);
    [self.view addSubview:available];
    
    UIScrollView *scroller = [[UIScrollView alloc] init];
    scroller.frame = CGRectMake(0, 200, self.view.frame.size.width, self.view.frame.size.height-200);
    BarberDetailView *timeView;
    for(int i = 0; i < appointments.count; i++){
        PFObject *time = appointments[i];
        
        
        timeView = [[BarberDetailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70) labelString:[self stringTime:time[@"startDate"]]];
        timeView.center = CGPointMake(self.view.center.x, timeView.frame.size.height/2 + timeView.frame.size.height * i);
        timeView.interactionDelegate = self;
        [scroller addSubview:timeView];
        [self.view addSubview:scroller];
    }
    
    scroller.contentSize = CGSizeMake(self.view.frame.size.width, timeView.frame.origin.y + timeView.frame.size.height);
    
}

-(void)addImage{
    UIImageView *userImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signin.jpg"]];
    userImage.frame = CGRectMake(0, 0, 100, 100);
    userImage.center = CGPointMake(self.view.center.x, 10 + userImage.frame.size.height/2);
    userImage.layer.cornerRadius = userImage.frame.size.width/2;
    userImage.clipsToBounds = YES;
    [self.view addSubview:userImage];
}
-(void)setUpLabels{
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(0, 0, 100, 100);
    nameLabel.text = self.barber[@"username"];
    nameLabel.font = [nameLabel.font fontWithSize:20];
    [nameLabel sizeToFit];
    nameLabel.center = CGPointMake(self.view.center.x, 130);
    [self.view addSubview:nameLabel];
}
-(IBAction)sendRequest{
    [PFCloud callFunctionInBackground:@"barber" withParameters:@{@"barberid" : self.barber.objectId} block:^(NSString *response, NSError *error) {
        if (!error) {
            
        }
    }];
}
#warning attribute https://www.flickr.com/photos/rheinitz/13279135145/in/photolist-ijt91L-e9p4tD-fSxsuz-mer3eX-eCGX2Q-cCaXbd-f5yTwq-nAkqXt-pcUqZt-dT7DzX-6czmoh-iZGkso-nMCU8B-6WTzRd-huZacx-6hbaJY-4SQPvG-9HkcYL-57FHwK-c8QFJQ-mAVBFK-4pYusW-97wZJZ-7tpqcp-obhqWn-nNyET3-psEMrJ-agSVXw-pL3CCd-dxea2R-9qD1tt-9qG2bU-bDZKz4-fjgDUC-5NqScy-q5Puzz-hdRLGS-bFDoX-pvmXE2-5CEYNc-hLNETw-9YRkCp-eVttWA-8AoJj6-j3i4dM-kozstA-8ArMAy-7UYDWx-qWXPpT-ofucAp

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addImage];
    [self setUpLabels];
    
    //set up the model.
    self.detailModel = [[BarberDetailModel alloc] initWithBarber:self.barber];
    self.detailModel.downloadDelegate = self;
    
    
    //[self sendRequest];
    
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
