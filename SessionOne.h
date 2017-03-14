//
//  SessionOne.h
//  CocoapodDemo
//
//  Created by JETS on 3/6/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"
#import "SessionView.h"
#import "MyAgenda.h"

@interface SessionOne : UIViewController<UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>
@property User *uu;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITableView *mytableview;
@property (strong, nonatomic) IBOutlet UIView *speaker;
@property (weak, nonatomic) IBOutlet UITextView *descrip;
//@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *location;
//@property (weak, nonatomic) IBOutlet UITextView *descrip;
@property (weak, nonatomic) IBOutlet UILabel *enddate;
@property (weak, nonatomic) IBOutlet UILabel *day;

@property (weak, nonatomic) IBOutlet UIButton *favourite;
@property Session *s;
- (IBAction)Prressbutton:(id)sender;

@property SessionView *sv;
@property MyAgenda *mg;
@property   bool whichOne;

@end
