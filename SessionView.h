//
//  SessionView.h
//  CocoapodDemo
//
//  Created by JETS on 3/2/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "DatabaseManager.h"
@interface SessionView : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>
@property    UIRefreshControl *refreshControl;
@property NSMutableArray *myList;
@property NSMutableArray *allDays;
@property NSMutableArray *day1List;
@property NSMutableArray *day2List;
@property NSMutableArray *day3List;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property DatabaseManager *db;
@property NSString *date1;
@property NSString *date2;
@property NSString *date3;
@property User *uu;

@end
