//
//  ExhibitorView.h
//  CocoapodDemo
//
//  Created by JETS on 2/28/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
@interface ExhibitorView : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *myList;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property    UIRefreshControl *refreshControl;
@property User *uu;
@end
