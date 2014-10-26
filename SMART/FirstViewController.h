//
//  FirstViewController.h
//  SMART
//
//  Created by John Smyth on 24/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWNetworking.h"
#import "TPWClinicsViewController.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *serviceOptions;
@property (nonatomic) NSArray *clinic_ids;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

