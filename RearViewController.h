
#import <UIKit/UIKit.h>

@interface RearViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *rearTableView;
//@property (nonatomic, retain) IBOutlet UIToolbar *rearToolBar;
#pragma mark - Properties
@property (strong, nonatomic) NSMutableArray *tableData;

#pragma mark - Properties
@property (strong, nonatomic) NSArray *theme;
@end