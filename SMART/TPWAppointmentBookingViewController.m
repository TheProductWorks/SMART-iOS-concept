//
//  TPWAppointmentBookingViewController.m
//  SMART
//
//  Created by John Smyth on 31/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import "TPWAppointmentBookingViewController.h"

@interface TPWAppointmentBookingViewController ()

@end

@implementation TPWAppointmentBookingViewController
@synthesize serviceUsers, appointmentDetails, selectedSearchResult;

static AFHTTPRequestOperationManager *manager;

- (void)viewDidLoad {
    [super viewDidLoad];

    manager = [TPWNetworking manager];
    serviceUsers = [NSMutableArray array];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [serviceUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SUCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSDictionary *serviceUser = [self.serviceUsers objectAtIndex:indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", serviceUser[@"personal_fields"][@"name"], serviceUser[@"hospital_number"]];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedSearchResult = [self.serviceUsers objectAtIndex:indexPath.row];

    UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Confirm Appointment" message:[NSString stringWithFormat:@"Confirm an appointment for %@ at %@", self.selectedSearchResult[@"personal_fields"][@"name"], self.appointmentDetails[@"time"]] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];

    [confirm show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSDictionary *params = @{
                                 @"appointment": @{
                                 @"date": self.appointmentDetails[@"date"],
                                 @"time": self.appointmentDetails[@"time"],
                                 @"service_provider_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"loggedin_service_provider_id"],
                                 @"service_user_id": self.selectedSearchResult[@"id"],
                                 @"priority": @"scheduled",
                                 @"visit_type": @"ante-natal",
                                 @"clinic_id": self.appointmentDetails[@"clinic_id"]
                                 }
                                };

        [manager POST:@"appointments" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchString {
    if (searchString.length > 1) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];

        NSRegularExpression *hospitalNumberRegex = [NSRegularExpression regularExpressionWithPattern:@"[hHtT][0-9]+" options:NSRegularExpressionCaseInsensitive error:nil];
        NSRegularExpression *dobRegex = [NSRegularExpression regularExpressionWithPattern:@"@[0-9]{2}\\-[0-9]{2}\\-[0-9]{4}" options:NSRegularExpressionCaseInsensitive error:nil];

        if ([hospitalNumberRegex numberOfMatchesInString:searchString options:0 range:NSMakeRange(0, [searchString length])]) {
            NSRange hospitalNumRange = [[hospitalNumberRegex firstMatchInString:searchString options:0 range:NSMakeRange(0, [searchString length])] rangeAtIndex:0];

            params[@"hospital_number"] = [searchString substringWithRange:hospitalNumRange];

            searchString = [hospitalNumberRegex stringByReplacingMatchesInString:searchString options:0 range:NSMakeRange(0, [searchString length]) withTemplate:@""];
        }

        if ([dobRegex numberOfMatchesInString:searchString options:0 range:NSMakeRange(0, [searchString length])]) {
            NSRange dobRange = [[dobRegex firstMatchInString:searchString options:0 range:NSMakeRange(0, [searchString length])] rangeAtIndex:0];

            params[@"dob"] = [[searchString substringWithRange:dobRange] stringByReplacingOccurrencesOfString:@"@" withString:@""];

            searchString = [dobRegex stringByReplacingMatchesInString:searchString options:0 range:NSMakeRange(0, [searchString length]) withTemplate:@""];
        }

        if (searchString.length > 0) {
            params[@"name"] = searchString;
        }

        [manager GET:@"service_users" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.serviceUsers = responseObject[@"service_users"];

            [self.searchDisplayController.searchResultsTableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    } else {
        self.serviceUsers = [NSMutableArray array];
    }
}

- (IBAction)dismissModal:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
