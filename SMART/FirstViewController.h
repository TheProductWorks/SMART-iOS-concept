//
//  FirstViewController.h
//  SMART
//
//  Created by John Smyth on 24/10/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFHTTPRequestOperationManager.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSArray *serviceOptions;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

