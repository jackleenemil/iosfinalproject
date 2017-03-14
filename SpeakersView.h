//  SpeakersView.h
//  CocoapodDemo
//  Created by Rana on 2/24/17.


#import <UIKit/UIKit.h>
#import "JETSNetworkDelegate.h"
#import "NetworkManager.h"
#import "User.h"
#import "DatabaseManager.h"
@interface SpeakersView : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property NSMutableArray *myList;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property DatabaseManager *db;
@property    UIRefreshControl *refreshControl;
@property User *uu;
@end
