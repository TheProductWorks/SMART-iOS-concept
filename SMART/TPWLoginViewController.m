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
    NSLog(@"Username: %@\nPassword: %@", usernameField.text, passwordField.text);
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
