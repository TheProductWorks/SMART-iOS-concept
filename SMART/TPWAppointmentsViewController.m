//
//  TPWAppointmentsViewController.m
//  SMART
//
//  Created by John Smyth on 29/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import "TPWAppointmentsViewController.h"

@interface TPWAppointmentsViewController ()

@end

@implementation TPWAppointmentsViewController
@synthesize appointments, clinic, tableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    AFHTTPRequestOperationManager *manager = [TPWNetworking manager];
    appointments = [NSMutableArray array];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDictionary *params = @{
                              @"clinic_id": self.clinic[@"id"],
                              @"date": [dateFormatter stringFromDate:[NSDate date]]
                            };

    [manager GET:@"appointments" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        appointments = responseObject[@"appointments"];
        [tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)appointmentForTime:(NSString *)date {
    for (id appointment in self.appointments) {
        if ([appointment[@"time"] isEqualToString:date]) {
            return appointment;
        }
    }

    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];

    NSDate *openingTimeAsDate = [dateFormatter dateFromString:self.clinic[@"opening_time"]];
    NSDate *closingTimeAsDate = [dateFormatter dateFromString:self.clinic[@"closing_time"]];

    NSTimeInterval secondsBetween = [closingTimeAsDate timeIntervalSinceDate:openingTimeAsDate];
    NSTimeInterval appointment_interval = [(NSString *)self.clinic[@"appointment_interval"] doubleValue];
    NSTimeInterval minuteIntervalsBetween = secondsBetween / 60.0 / appointment_interval;

    return minuteIntervalsBetween;
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ACell";

    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }

    NSDictionary *existingAppointment = [self appointmentForTime:@""];
    if (existingAppointment) {
        cell.textLabel.text = existingAppointment[@"time"];
    } else {
        cell.textLabel.text = @"Free Slot";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
