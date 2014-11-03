//
//  TPWAppointmentBookingViewController.h
//  SMART
//
//  Created by John Smyth on 31/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWNetworking.h"

@interface TPWAppointmentBookingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, UIAlertViewDelegate>

@property (nonatomic) NSMutableArray *serviceUsers;
@property (nonatomic) NSDictionary *selectedSearchResult;
@property (nonatomic) NSDictionary *appointmentDetails;

- (IBAction)dismissModal:(id)sender;

@end
