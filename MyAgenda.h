//
//  MyAgenda.h
//  FinalMWDProject
//
//  Created by JETS on 3/9/17.
//  Copyright © 2017 JETS. All rights reserved.
//
#import "DatabaseManager.h"
#import <UIKit/UIKit.h>
#import "User.h"
@interface MyAgenda : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>
@property    UIRefreshControl *refreshControl;
@property NSMutableArray *myList;
@property NSMutableArray *allDays;
@property NSMutableArray *day1List;
@property NSMutableArray *day2List;
@property NSMutableArray *day3List;
@property IBOutlet UITableView *myTableView;
@property DatabaseManager *db;
@property User *uu;
@property NSString *date1;
@property NSString *date2;
@property NSString *date3;

@end
