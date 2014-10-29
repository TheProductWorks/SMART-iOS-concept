//
//  TPWClinicsViewController.h
//  SMART
//
//  Created by John Smyth on 26/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWNetworking.h"
#import "TPWAppointmentsViewController.h"

@interface TPWClinicsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableArray *clinics;
@property (nonatomic) NSArray *clinic_ids;
@property (nonatomic) NSDictionary *selectedClinic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
