//
//  TPWServiceUserViewController.m
//  SMART
//
//  Created by John Smyth on 05/11/2014.
//  Copyright (c) 2014 The Product Works. All rights reserved.
//

#import "TPWServiceUserViewController.h"

@interface TPWServiceUserViewController ()

@end

@implementation TPWServiceUserViewController
@synthesize serviceUser, suName, criticalInfo, selectedButton, tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedButton = @"personal";

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dob = [formatter dateFromString:self.serviceUser[@"personal_fields"][@"dob"]];

    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitYear
                                                                   fromDate:dob toDate:[[NSDate alloc] init] options: 0];

    self.suName.text = self.serviceUser[@"personal_fields"][@"name"];
    self.criticalInfo.text = [NSString stringWithFormat:@"%ldyrs, P:%@, G:%@", (long)components.year, self.serviceUser[@"clinical_fields"][@"parity"], self.serviceUser[@"clinical_fields"][@"gestation"]];
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

- (IBAction)personalTapped:(id)sender {
    self.selectedButton = @"personal";
    [self.tableView reloadData];
}

- (IBAction)anteTapped:(id)sender {
    self.selectedButton = @"ante";
    [self.tableView reloadData];
}

- (IBAction)postTapped:(id)sender {
    self.selectedButton = @"post";
    [self.tableView reloadData];
}

-(UIView *)tableView:(UITableView *)thisTableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"sectionHeader"];

    if ([self.selectedButton isEqualToString:@"personal"]) {
        if (section == 0) {
            headerView.textLabel.text = @"Contact";
        } else if (section == 1) {
            headerView.textLabel.text = @"Address";
        } else {
            headerView.textLabel.text = @"Next of Kin";
        }
    } else if ([self.selectedButton isEqualToString:@"ante"]) {
        return nil;
    } else {
        if (section == 0) {
            headerView.textLabel.text = @"Mother";
        } else {
            headerView.textLabel.text = @"Baby";
        }
    }

    return headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.selectedButton isEqualToString:@"personal"]) {
        return 3;
    } else if ([self.selectedButton isEqualToString:@"ante"]) {
        return 1;
    } else {
        return 1 + ([self.serviceUser[@"babies"] count]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.selectedButton isEqualToString:@"personal"]) {
        if (section == 0) {
            return 4;
        } else if (section == 1) {
            return 2;
        } else {
            return 2;
        }
    } else if ([self.selectedButton isEqualToString:@"ante"]) {
        return 6;
    } else {
        if (section == 0) {
            return 4;
        } else {
            return 9;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)thisTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SUCell";

    UITableViewCell *cell = [thisTableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    NSDictionary *personal_fields = self.serviceUser[@"personal_fields"];
    NSDictionary *clinical_fields = self.serviceUser[@"clinical_fields"];
    NSDictionary *currentPregnancy = self.serviceUser[@"pregnancies"][0];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    if ([self.selectedButton isEqualToString:@"personal"]) {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = self.serviceUser[@"hospital_number"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = personal_fields[@"email"];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = personal_fields[@"mobile_phone"];
            } else if (indexPath.row == 3) {
                cell.textLabel.text = personal_fields[@"home_phone"];
            }
        } else if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.textLabel.text = personal_fields[@"home_type"];
            } else {
                cell.textLabel.text = [NSString stringWithFormat:@"%@, %@, %@", personal_fields[@"home_address"], personal_fields[@"home_county"], personal_fields[@"home_post_code"]];
            }
        } else {
            if (indexPath.row == 0) {
                cell.textLabel.text = personal_fields[@"next_of_kin_name"];
            } else {
                cell.textLabel.text = personal_fields[@"next_of_kin_phone"];
            }
        }
    } else if ([self.selectedButton isEqualToString:@"ante"]) {
        if (indexPath.row == 0) {
            cell.textLabel.text = currentPregnancy[@"estimated_delivery_date"];
        } else if (indexPath.row == 1) {
            cell.textLabel.text = clinical_fields[@"gestation"];
        } else if (indexPath.row == 2) {
            cell.textLabel.text = clinical_fields[@"blood_group"];
        } else if (indexPath.row == 3) {
            cell.textLabel.text = clinical_fields[@"rhesus"] ? @"Positive" : @"False";
        } else if (indexPath.row == 4) {
            cell.textLabel.text = clinical_fields[@"parity"];
        }
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                cell.textLabel.text = currentPregnancy[@"birth_mode"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = currentPregnancy[@"perineum"];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = currentPregnancy[@"anti_d"];
            } else {
                cell.textLabel.text = @"Midwife Notes";
            }
        } else {
            NSDictionary *baby = self.serviceUser[@"babies"][indexPath.section - 1];

            if (indexPath.row == 0) {
                cell.textLabel.text = baby[@"delivery_date_time"];
            } else if (indexPath.row == 1) {
                cell.textLabel.text = baby[@"delivery_date_time"];
            } else if (indexPath.row == 2) {
                cell.textLabel.text = @"DAYS since birth here";
            } else if (indexPath.row == 3) {
                cell.textLabel.text = baby[@"gender"];
            } else if (indexPath.row == 4) {
                cell.textLabel.text = baby[@"weight"];
            } else if (indexPath.row == 5) {
                cell.textLabel.text = baby[@"vitamin_k"];
            } else if (indexPath.row == 6) {
                cell.textLabel.text = baby[@"hearing"];
            } else if (indexPath.row == 7) {
                cell.textLabel.text = baby[@"feeding"];
            } else {
                cell.textLabel.text = baby[@"newborn_screening_test"];
            }
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
