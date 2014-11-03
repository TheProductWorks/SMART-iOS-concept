//
//  TPWAppointmentsViewController.h
//  SMART
//
//  Created by John Smyth on 29/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWNetworking.h"
#import "TPWAppointmentBookingViewController.h"

@interface TPWAppointmentsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *appointments;
@property (nonatomic) NSDictionary *clinic;
@property (nonatomic) NSMutableArray *times;
@property (nonatomic) NSDate *selectedDate;
@property (nonatomic) NSDate *selectedTime;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (NSDictionary *)appointmentForTime:(NSString *)time;
- (void)populateTimes;

@end
