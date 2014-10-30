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
@synthesize appointments, clinic, tableView, times;

static NSDateFormatter *timeFormatter;
static NSDateFormatter *dateFormatter;

- (void)viewDidLoad {
    [super viewDidLoad];
    timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm:ss"];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    AFHTTPRequestOperationManager *manager = [TPWNetworking manager];
    appointments = [NSMutableArray array];

    NSDictionary *params = @{
                              @"clinic_id": self.clinic[@"id"],
                              @"date": [dateFormatter stringFromDate:[NSDate date]]
                            };

    [manager GET:@"appointments" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        appointments = responseObject[@"appointments"];

        NSDate *openingTimeAsDate = [timeFormatter dateFromString:self.clinic[@"opening_time"]];
        NSDate *closingTimeAsDate = [timeFormatter dateFromString:self.clinic[@"closing_time"]];

        NSTimeInterval secondsBetween = [closingTimeAsDate timeIntervalSinceDate:openingTimeAsDate];
        NSTimeInterval appointment_interval = [(NSString *)self.clinic[@"appointment_interval"] doubleValue];
        NSTimeInterval minuteIntervalsBetween = secondsBetween / 60.0 / appointment_interval;

        self.times = [NSMutableArray arrayWithObject:openingTimeAsDate];
        NSCalendar *calender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];

        for (int i=0; i<minuteIntervalsBetween; i++) {
            NSDate *lastDate = [self.times lastObject];
            NSDateComponents *lastDateComponent = [calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:lastDate];
            lastDateComponent.minute += appointment_interval;
            [self.times addObject:[calender dateFromComponents:lastDateComponent]];
        }

        [tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSDictionary *)appointmentForTime:(NSString *)time {
    for (id appointment in self.appointments) {
        if ([appointment[@"time"] isEqualToString:time]) {
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

    return [self.times count];
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"ACell";

    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSDate *nextDateInList = [self.times objectAtIndex:indexPath.row];
    NSDictionary *existingAppointment = [self appointmentForTime:[timeFormatter stringFromDate:nextDateInList]];

    [timeFormatter setDateFormat:@"HH:mm"];
    NSString *displayTime = [timeFormatter stringFromDate:nextDateInList];
    [timeFormatter setDateFormat:@"HH:mm:ss"];

    cell.textLabel.text = displayTime;

    if (existingAppointment) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@ %@", displayTime, existingAppointment[@"service_user"][@"personal_fields"][@"name"], existingAppointment[@"service_user"][@"clinical_fields"][@"gestation"]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ Free Slot", displayTime];
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
