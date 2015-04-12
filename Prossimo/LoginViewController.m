//
//  LoginViewController.m
//  Prossimo
//
//  Created by Ryan Maciel on 4/11/15.
//  Copyright (c) 2015 Prossimo. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>


@interface LoginViewController ()
@property(strong, nonatomic)IBOutlet UITextField *emailField;
@property(strong, nonatomic)IBOutlet UITextField *passwordField;
@property(strong, nonatomic)IBOutlet UITextField *usernameField;
@end

@implementation LoginViewController


-(IBAction)editingBegan:(UITextField*)sender{

}
-(IBAction)editingEnded:(UITextField*)sender{
    NSLog(@"ended");
}
-(IBAction)submitLogin{
    //Create a new user if one does not exist.
    if(![PFUser currentUser]){
        PFUser *newUser = [PFUser user];
        newUser.password = self.passwordField.text;
        newUser.email = self.emailField.text;
        newUser.username = self.usernameField.text;
        [newUser signUpInBackgroundWithBlock:^(BOOL success, NSError *error){
            
            
            //Log any errors.
            if(error)NSLog(@"%@", error.description);
            
            //If the signup was successful.
            if(success){
                
                [newUser save];
                
                //Add the user to the installation.
                PFInstallation *installation = [PFInstallation currentInstallation];
                installation[@"user"] = newUser;
                [installation save];
                
            }
        }];
    }
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];

}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:1 animations:^(){
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y - kbSize.height/2);
    }];
}

-(void)keyboardWillBeHidden:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [UIView animateWithDuration:1 animations:^(){
        self.view.center = CGPointMake(self.view.center.x, self.view.center.y + kbSize.height/2);
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [PFUser logOut];
    
    [self registerForKeyboardNotifications];
    
    self.emailField.layer.borderColor = self.passwordField.layer.borderColor = self.usernameField.layer.borderColor = [UIColor grayColor].CGColor;
    self.emailField.layer.borderWidth = self.passwordField.layer.borderWidth = self.usernameField.layer.borderWidth = 0.1;
    
    
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
