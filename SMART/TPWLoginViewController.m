//
//  TPWLoginViewController.m
//  SMART
//
//  Created by John Smyth on 24/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import "TPWLoginViewController.h"

@interface TPWLoginViewController ()

@end

@implementation TPWLoginViewController

@synthesize usernameField, passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitLogin:(id)sender {
    NSDictionary *envDictionary = [[NSProcessInfo processInfo] environment];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[envDictionary objectForKey:@"API_KEY"] forHTTPHeaderField:@"Api-Key"];

    NSDictionary *parameters = @{
                                 @"login": @{
                                     @"username": usernameField.text,
                                     @"password": passwordField.text
                                 }
                                };

    [manager POST:[NSString stringWithFormat:@"%@login", [envDictionary objectForKey:@"API_URL"]] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"login"][@"token"] forKey:@"access_token"];
        [self performSegueWithIdentifier:@"loginToAppSegue" sender:self];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
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
