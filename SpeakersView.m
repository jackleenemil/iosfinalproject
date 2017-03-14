//  SpeakersView.m
//  CocoapodDemo
//  Created by Rana on 2/24/17.

#import "SpeakersView.h"
#import "MyCustomCell.h"
#import "NetworkManager.h"
#import "JETSNetworkDelegate.h"
#import "Speaker.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import <UIImage+AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "Reachability.h"
#import "SpeakerOne.h"
#import "User.h"
#import "UIView+Toast.h"
@interface SpeakersView (){
    NSMutableString *myURL;
    UIActivityIndicatorView *activity;
    SpeakerOne *speak;
    //NSCache *_imageCache;
}


@property int con;

@end

@implementation SpeakersView

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [_myTableView setBackgroundColor:[UIColor clearColor]];
    ////////
    self.refreshControl = [[UIRefreshControl alloc] init];
    // self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.backgroundColor = [UIColor orangeColor];
    //self.refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor greenColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshdata)
                  forControlEvents:UIControlEventValueChanged];
    [self.myTableView    addSubview: _refreshControl];
    
    //////////
    
    //*******************Menu Button Function***********/
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    
#pragma mark - Example Code
    
    
    
    /**************************************/
    
    _uu=[User sharedInstance];
    _myList = [NSMutableArray new];
    myURL = [NSMutableString new];
    _db =[DatabaseManager sharedinstance];
    [myURL appendString:@"http://www.mobiledeveloperweekend.net/service/getSpeakers?userName="];
    [myURL appendString:_uu.email];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
    
        //no connection
        
        _myList =[_db getAllSpeakers];
        
        [self.myTableView reloadData];
    
        
    }else{
    
        
    NSString *serviceName=@"getSpeakers";
    NSString *serviceURL = myURL;
    [activity startAnimating];
    [self connectToService:serviceName WithURL:serviceURL];

      [self.view makeToastActivity:CSToastPositionCenter];
        
    }
        
        
        
}

-(void)viewWillAppear:(BOOL)animated{
    //self.myTableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"speaker.png"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_myList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil){
        [tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
        cell.myImage.image = [UIImage imageNamed:@"Speaker.png"];
        
    }
    else{
        cell.myImage.image = [UIImage imageNamed:@"Speaker.png"];
    }

       Speaker *sp= [_myList objectAtIndex:indexPath.row];
    
    NSMutableString *str =[NSMutableString new];
    
    [str appendString:sp.fName];
    [str appendString:@" "];
    [str appendString:sp.lName];
    cell.myLabel1.text = str ;
    cell.myLabel2.text  = [[_myList objectAtIndex:indexPath.row] titlee];
    cell.myLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    cell.myLabel2.numberOfLines = 0;
    [cell.myLabel2 sizeToFit];

    
    // this rana's work
    
    
    if(_con==1){
        
        NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[[_myList objectAtIndex:indexPath.row] imageURL]]];
        
        [cell.myImage setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"Speaker.png"] success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
            NSLog(@"Loaded successfully");
            
            [cell.myImage setImage:image];
            
            NSData *imageData = UIImagePNGRepresentation(image);
            [[_myList objectAtIndex:indexPath.row ]setImg:imageData];
           
            [_db addImageInSpeaker :[[_myList objectAtIndex:indexPath.row] idd] :imageData];
            
            //            NSMutableArray *imagesspeaker=[NSMutableArray new];
            //            imagesspeaker[indexPath.row]=imageData;
            //            printf("ddd");
            
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
            NSLog(@"failed loading");
        }];
    
        
        
        
    }else if([[_myList objectAtIndex:indexPath.row] img]!=nil){
        
        
       NSData*d = [[_myList objectAtIndex:indexPath.row] img];
        cell.myImage.image=[UIImage imageWithData:d];
        
           
    }
    
    
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setBackgroundView:cell.contentView];
    
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[self view] endEditing:YES];
}

-(void)connectToService :(NSString*) serviceName WithURL :(NSString*) serviceURLString {
    NSURL *url = [NSURL URLWithString:serviceURLString];
    NetworkManager *network = [NetworkManager new];
    [network setNetworkDelegate: self];
    [NetworkManager connect:url:serviceName:network];
}

-(void)handle:(NSData *)dataRetreived :(NSString *)serviceName :(int)check{
    if ([serviceName isEqualToString:@"getSpeakers"]) {
        
        if(check==1){
        
            _con=1;
            
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
        
        if([[dict objectForKey:@"status"] isEqualToString:@"view.success"]){
            
            
            [_db deleteAllSpeakers];
            // Success
            printf("success");
            NSArray *result = [dict objectForKey:@"result"];
            for (int i=0; i<result.count; i++){
                NSDictionary *dd = [result objectAtIndex:i];
                Speaker *s = [Speaker new];
                                
                [s setIdd:[[dd objectForKey:@"id"] stringValue] ];
                [s setFName:[dd objectForKey:@"firstName"]];
                [s setLName:[dd objectForKey:@"lastName"]];
                [s setCompanyName:[dd objectForKey:@"companyName"]];
                [s setTitlee:[dd objectForKey:@"title"]];
                [s setMobiles:[dd objectForKey:@"mobiles"]];
                [s setPhones:[dd objectForKey:@"phones"]];
                [s setMiddleName:[dd objectForKey:@"middleName"]];
                [s setBiography:[dd objectForKey:@"biography"]];
                [s setImageURL:[dd objectForKey:@"imageURL"]];
                //edit
                [s setGender:[[dd objectForKey:@"gender"] stringValue]];
                [_myList addObject:s];
                printf("%s \n", [[dd objectForKey:@"firstName"] UTF8String]);
                printf("%s \n", [[[_myList objectAtIndex:i] fName] UTF8String]);
                printf("%s \n", [@"-------------------" UTF8String]);
                
            
            }
            
            
            
            [_db deleteAllSpeakers];
            
            [_db addSpeakers:_myList];
            
            [self.view hideToastActivity];

            [self.myTableView reloadData];
        }
        else {
            // Failed
            printf("failed");
            [myURL setString:@""];
        }
            
       
        
        }else{
        /// no connection
            
            _con=0;
            _myList =[_db getAllSpeakers];
            
            [self.view hideToastActivity];

            [self.myTableView reloadData];
            
            
        }
            
            
    }
}

///////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    speak=[SpeakerOne  new];
    
   // [self presentViewController:speak  animated:YES completion:nil];
    [self.navigationController pushViewController:speak animated:NO];
    
    [speak setS:[_myList objectAtIndex:indexPath.row]];
    
    
}





//////////////////
- (void)refreshdata
{
    //    // Reload table data
   // [self.myTableView reloadData];
    NSString *serviceName=@"getSpeakers";
    NSString *serviceURL = myURL;
    [activity startAnimating];
    [self connectToService:serviceName WithURL:serviceURL];
    [self.view makeToastActivity:CSToastPositionCenter]; 

    // End the refreshing
    if (self.refreshControl) {
        
        //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        //        [formatter setDateFormat:@"MMM d, h:mm a"];
        //        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        //        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
        //                                                                    forKey:NSForegroundColorAttributeName];
        //        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        //        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}
////////////////

@end
