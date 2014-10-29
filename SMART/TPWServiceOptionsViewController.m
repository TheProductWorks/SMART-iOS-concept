//
//  TPWServiceOptionsViewController.m
//  SMART
//
//  Created by John Smyth on 24/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import "TPWServiceOptionsViewController.h"

@interface TPWServiceOptionsViewController ()

@end

@implementation TPWServiceOptionsViewController

@synthesize serviceOptions, tableView, clinic_ids;

- (void)viewDidLoad {
    [super viewDidLoad];

    AFHTTPRequestOperationManager *manager = [TPWNetworking manager];

    [manager GET:@"service_options" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        serviceOptions = responseObject[@"service_options"];
        [tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [serviceOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SOCell";

    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.textLabel.text = [serviceOptions objectAtIndex:indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.clinic_ids = [serviceOptions objectAtIndex:indexPath.row][@"clinic_ids"];
    [self performSegueWithIdentifier:@"soToClinicsSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ((TPWClinicsViewController *)[segue destinationViewController]).clinic_ids = self.clinic_ids;
}

@end
