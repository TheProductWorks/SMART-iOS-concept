//
//  TPWClinicsViewController.m
//  SMART
//
//  Created by John Smyth on 26/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import "TPWClinicsViewController.h"

@interface TPWClinicsViewController ()

@end

@implementation TPWClinicsViewController
@synthesize clinic_ids, clinics, tableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    AFHTTPRequestOperationManager *manager = [TPWNetworking manager];
    clinics = [NSMutableArray array];

    for (NSNumber *clinic_id in self.clinic_ids) {
        [manager GET:[NSString stringWithFormat:@"clinics/%d", [clinic_id intValue]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [clinics addObject:responseObject[@"clinics"][0]];
            [tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [clinics count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CCell";

    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.textLabel.text = [clinics objectAtIndex:indexPath.row][@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
