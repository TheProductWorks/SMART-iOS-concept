//
//  TPWServiceUserViewController.h
//  SMART
//
//  Created by John Smyth on 05/11/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TPWNetworking.h"

@interface TPWServiceUserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSMutableDictionary *serviceUser;
@property (nonatomic) NSString *selectedButton;

@property (weak, nonatomic) IBOutlet UILabel *suName;
@property (weak, nonatomic) IBOutlet UILabel *criticalInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)personalTapped:(id)sender;
- (IBAction)anteTapped:(id)sender;
- (IBAction)postTapped:(id)sender;

@end
