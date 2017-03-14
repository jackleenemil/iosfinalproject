

#import "RearViewController.h"

#import "SWRevealViewController.h"
#import "FrontViewController.h"
#import "SessionView.h"
#import "SpeakersView.h"
#import "ExhibitorView.h"
#import "ViewController.h"
#import "MyAgenda.h"
#import "UserProfile.h"
#import "FirstPage.h"
@interface RearViewController()
{
    NSInteger _presentedRow;
}



@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;

/*
 * The following lines are crucial to understanding how the SWRevealViewController works.
 *
 * In this example, we show how a SWRevealViewController can be contained in another instance
 * of the same class. We have three scenarios of hierarchies as follows
 *
 * In the first scenario a FrontViewController is contained inside of a UINavigationController.
 * And the UINavigationController is contained inside of a SWRevealViewController. Thus the
 * following hierarchy is created:
 *
 * - SWRevealViewController is parent of:
 * - 1 UINavigationController is parent of:
 * - - 1.1 RearViewController
 * - 2 UINavigationController is parent of:
 * - - 2.1 FrontViewController
 *
 * In the second scenario a MapViewController is contained inside of a UINavigationController.
 * And the UINavigationController is contained inside of a SWRevealViewController. Thus the
 * following hierarchy is created:
 *
 * - SWRevealViewController is parent of:
 * - 1 UINavigationController is parent of:
 * - - 1.1 RearViewController
 * - 2 UINavigationController is parent of:
 * - - 1.2 MapViewController
 *
 * In the third scenario a SWRevealViewController is contained directly inside of another.
 * SWRevealController. Thus the following hierarchy is created:
 *
 * - SWRevealViewController is parent of:
 * - 1 UINavigationController is parent of:
 * - - 1.1 RearViewController
 * - 2 SWRevealViewController
 * - - ...
 *
 * The second SWRevealViewController on the third scenario can in turn contain anything.
 * On this example it may recursively contain any of the above, including again the third one
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     [_rearTableView setBackgroundColor:[UIColor clearColor]];
    
    // We determine whether we have a grand parent SWRevealViewController, this means we are at least one level behind the hierarchy
    SWRevealViewController *parentRevealController = self.revealViewController;
    SWRevealViewController *grandParentRevealController = parentRevealController.revealViewController;
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:grandParentRevealController action:@selector(revealToggle:)];
    
    // if we have a reveal controller as a grand parent, this means we are are being added as a
    // child of a detail (child) reveal controller, so we add a gesture recognizer provided by our grand parent to our
    // navigation bar as well as a "reveal" button, we also set
    if ( grandParentRevealController )
    {
        // to present a title, we count the number of ancestor reveal controllers we have, this is of course
        // only a hack for demonstration purposes, on a real project you would have a model telling this.
        NSInteger level=0;
        UIViewController *controller = grandParentRevealController;
        while( nil != (controller = [controller revealViewController]) )
            level++;
        
        NSString *title = [NSString stringWithFormat:@"Detail Level %d", level];
        
        [self.navigationController.navigationBar addGestureRecognizer:grandParentRevealController.panGestureRecognizer];
    
        self.navigationItem.leftBarButtonItem = revealButtonItem;
        self.navigationItem.title = title;
    }
    
    // otherwise, we are in the top reveal controller, so we just add a title
    else
    {
        self.navigationItem.title = @"Master";
    }
    self.tableData = [@[@"Agenda",@"My Agenda",@"Speakers",@"Exhibitors",@"Profile",@"Logout"]mutableCopy];
    self.theme=[NSArray arrayWithObjects:@"agenda.png",@"myagenda.png",@"speaker.png",@"exihiptors.png",@"profile.png",@"logout.png",nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    SWRevealViewController *grandParentRevealController = self.revealViewController.revealViewController;
    grandParentRevealController.bounceBackOnOverdraw = YES;
}


#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
    
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.tableData[indexPath.row];
    //cell.imageView.image=[UIImage imageNamed:[self.theme objectAtIndex:indexPath.row ]];
    
    
    if(indexPath.row==0){
        
        cell.imageView.image =[UIImage imageNamed:@"agenda.png"];
    }else if(indexPath.row==1){
        cell.imageView.image =[UIImage imageNamed:@"myagenda1.png"];
        
     }else if(indexPath.row==2){
    cell.imageView.image =[UIImage imageNamed:@"speaker.png"];
         
     }else if(indexPath.row==3){
         
         cell.imageView.image =[UIImage imageNamed:@"exihiptors.png"];
     }else if(indexPath.row==4){
         cell.imageView.image =[UIImage imageNamed:@"profile.png"];
     }else if(indexPath.row==5){
    cell.imageView.image =[UIImage imageNamed:@"logout1.png"];
     }
    
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setBackgroundView:cell.contentView];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    
    // selecting row
    NSInteger row = indexPath.row;
    
    // if we are trying to push the same row or perform an operation that does not imply frontViewController replacement
    // we'll just set position and return
    
    if ( row == _presentedRow )
    {
        [revealController setFrontViewPosition:FrontViewPositionLeft animated:YES];
        return;
    }
    
    // otherwise we'll create a new frontViewController and push it with animation
    
    UIViewController *newFrontController = nil;
    
    if (row == 0)
    {
        SessionView *session = [[SessionView alloc] init];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:session];
    }
    if (row == 1)
    {
        MyAgenda *m=[MyAgenda new];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:m];
     
        
    }
    else if (row == 2)
    {
        SpeakersView *s=[SpeakersView new];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:s];

        
        
    }
    else if (row == 3)
    {
        ExhibitorView *ex =[ExhibitorView new];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:ex];
        
    
    }
    
    else if ( row == 4 )
    {
        
        UserProfile *u=[UserProfile new];
        newFrontController = [[UINavigationController alloc] initWithRootViewController:u];
        
        
    }else if(row==5){
        FirstPage *w =[FirstPage new];
        NSUserDefaults *def =[NSUserDefaults standardUserDefaults];
        
        [def setBool:NO forKey:@"isLogged"];
        
       // newFrontController = [[UINavigationController alloc] initWithRootViewController:w];
     
        [self presentViewController:w animated:NO completion:nil];
    }
    
    [revealController pushFrontViewController:newFrontController animated:YES];
    
    _presentedRow = row;  // <- store the presented row
    
}



@end