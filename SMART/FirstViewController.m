//
//  FirstViewController.m
//  SMART
//
//  Created by John Smyth on 24/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

@synthesize serviceOptions, tableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *envDictionary = [[NSProcessInfo processInfo] environment];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[envDictionary objectForKey:@"API_KEY"] forHTTPHeaderField:@"Api-Key"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"Auth-Token"];

    [manager GET:[NSString stringWithFormat:@"%@service_options", [envDictionary objectForKey:@"API_URL"]] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [serviceOptions count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RecipeCell";

    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    cell.textLabel.text = [serviceOptions objectAtIndex:indexPath.row][@"name"];
    return cell;
}

@end
