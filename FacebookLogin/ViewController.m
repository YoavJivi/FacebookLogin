//
//  ViewController.m
//  FacebookLogin
//
//  Created by Yoav Gross on 10/19/15.
//  Copyright © 2015 jivi. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self FCMloginUserInViewController:self WithCompletionHandler:^(BOOL seccess, NSString *token, NSError *loginError) {
        NSLog(@"%@", loginError.description);
        NSLog(@"Hello");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)FCMloginUserInViewController:(UIViewController *)controller
               WithCompletionHandler:(void(^)(BOOL seccess, NSString *token, NSError *loginError))handler
{
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    if (token) {
        
        handler(YES, token.tokenString, nil);
    }else{
        //[FBSDKLoginManager renewSystemCredentials:^(ACAccountCredentialRenewResult result, NSError *error) {
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        [login logInWithReadPermissions:@[@"public_profile", @"user_friends", @"user_birthday", @"user_likes", @"email"]
                     fromViewController:controller
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    if (error) {
                                        // Process error
                                        handler(NO, nil, error);
                                    }else if (result.isCancelled){
                                        // Handle cancellations
                                        handler(NO, nil, error);
                                    }else{
                                        // If you ask for multiple permissions at once, you
                                        // should check if specific permissions missing
                                        FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
                                        handler(YES, token.tokenString, nil);
                                    }
                                }];
        //}];
    }
}

@end
