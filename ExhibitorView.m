//
//  ExhibitorView.m
//  CocoapodDemo
//
//  Created by JETS on 2/28/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "ExhibitorView.h"
#import "MyCustomCell.h"
#import "NetworkManager.h"
#import "JETSNetworkDelegate.h"
#import "Exhibitors.h"
#import "SWRevealViewController.h"
#import "DatabaseManager.h"
#import "Reachability.h"
#import "AFNetworking.h"
#import <UIImage+AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "UIView+Toast.h"
#import "User.h"

@interface ExhibitorView (){
    NSMutableString *myURL;
    UIActivityIndicatorView *activity;
}
@property int con;
@property DatabaseManager *db;

@end

@implementation ExhibitorView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_myTableView setBackgroundColor:[UIColor clearColor]];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    // self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.backgroundColor = [UIColor orangeColor];
    //self.refreshControl.tintColor = [UIColor whiteColor];
    self.refreshControl.tintColor = [UIColor greenColor];
    
    [self.refreshControl addTarget:self
                            action:@selector(refreshdata)
                  forControlEvents:UIControlEventValueChanged];
    [self.myTableView    addSubview: _refreshControl];
    
    _db=[DatabaseManager sharedinstance];
    
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
    [myURL appendString:@"http://www.mobiledeveloperweekend.net/service/getExhibitors?userName="];
    [myURL appendString:_uu.email];
    NSString *serviceName=@"getExhibitors";
    NSString *serviceURL = myURL;
    [activity startAnimating];
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        //no connection
        
        _myList =[_db getAllExhibitors];
        
        _con=0;
        
        [self.myTableView reloadData];
        

        
    }else{
    
    printf("there is Connection");
        
        
        
    [self connectToService:serviceName WithURL:serviceURL];
    [self.view makeToastActivity:CSToastPositionCenter]; 
        
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_myList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil){
        [tableView registerNib:[UINib nibWithNibName:@"MyCustomCell" bundle:nil] forCellReuseIdentifier:@"myCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    }
    
    cell.myLabel1.text = [[_myList objectAtIndex:indexPath.row] comp_name];
    cell.myLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    cell.myLabel1.numberOfLines = 0;
    [cell.myLabel1 sizeToFit];
    
    cell.myLabel2.text  = [[_myList objectAtIndex:indexPath.row] email];
    cell.myLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    cell.myLabel2.numberOfLines = 0;
    [cell.myLabel2 sizeToFit];
     
   
    if(_con==1){
        
        NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[[_myList objectAtIndex:indexPath.row] img_url]]];
        
        [cell.myImage setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"exihiptors.png"] success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
            NSLog(@"Loaded successfully");
            [cell.myImage setImage:image];
            NSData *imageData = UIImagePNGRepresentation(image);
            
            [_db addImageInExihibtors :[[_myList objectAtIndex:indexPath.row] idd] :imageData];
            

            //            NSMutableArray *imagesspeaker=[NSMutableArray new];
            //            imagesspeaker[indexPath.row]=imageData;
            //            printf("ddd");
            
            
            
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
            NSLog(@"failed loading");
        }];
        
        
        
        
    }else if([[_myList objectAtIndex:indexPath.row] img]!=nil){
        
        
        NSData*d = [[_myList objectAtIndex:indexPath.row] img];
        cell.myImage.image=[UIImage imageWithData:d];
        
    }else{
        cell.myImage.image = [UIImage imageNamed:@"exihiptors.png"];
        
    }

    
    
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setBackgroundView:cell.contentView];
    
    
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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

-(void)handle:(NSData *)dataRetreived :(NSString *)serviceName : (int)check{
    printf("mmmmmmmmm");
    if ([serviceName isEqualToString:@"getExhibitors"]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
       
        if(check==1){
            
            _con=1;
        
        if([[dict objectForKey:@"status"] isEqualToString:@"view.success"]){
            // Success
            printf("success");
            NSArray *result = [dict objectForKey:@"result"];
            for (int i=0; i<result.count; i++){
               
                
                NSDictionary *dd = [result objectAtIndex:i];
                Exhibitors *s = [Exhibitors new];
                [s setIdd:[[dd objectForKey:@"id"] stringValue]];
                [s setAddress:[dd objectForKey:@"companyAddress"]];
                [s setEmail:[dd objectForKey:@"email"]];
                [s setCountry_name:[dd objectForKey:@"countryName"]];
                //edited
                [s setCity_name:[dd objectForKey:@"cityName"]];
                [s setComp_name:[dd objectForKey:@"companyName"]];
                [s setPhons:[dd objectForKey:@"phones"]];
                [s setMobiles:[dd objectForKey:@"mobiles"]];
                [s setAbout:[dd objectForKey:@"companyAbout"]];
                [s setFax:[dd objectForKey:@"fax"]];
                [s setContact_name:[dd objectForKey:@"contactName"]];
                [s setContact_title:[dd objectForKey:@"contactTitle"]];
                //edited
                [s setComp_url:[dd objectForKey:@"companyUrl"]];
                [s setImg_url:[dd objectForKey:@"imageURL"]];
                [_myList addObject:s];
                printf("%s \n", [[dd objectForKey:@"companyName"] UTF8String]);
                printf("%s \n", [[[_myList objectAtIndex:i] comp_name] UTF8String]);
                printf("%s \n", [@"-------------------" UTF8String]);
                

                
                
                
                
            }
            
           
            
            [self.view hideToastActivity];
             [self.myTableView reloadData];
        
            [_db deleteAllExhibitors];
            
            [_db addExhibitors:_myList];
            
        }else {
            // Failed
            printf("failed");
            [myURL setString:@""];
        }
            
        }else{
            // no connection
           
            _con=0;
            
            _myList =[_db getAllExhibitors];
            
            [self.view hideToastActivity];
            [self.myTableView reloadData];
            
            
            
        }
            
            
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSURL *url = [NSURL URLWithString:[[_myList objectAtIndex:indexPath.row] comp_url]];
    
    NSString  *stringurl=url.absoluteString;
    if( [stringurl rangeOfString:@"http://www."].location != NSNotFound)
    {
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
    else{
        
        /*
        NSString *message = @"not valid url";
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil                                                            message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        toast.backgroundColor=[UIColor redColor];
        [toast show];
        int duration = 1;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{                [toast dismissWithClickedButtonIndex:0 animated:YES];            });
        
        */
        
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageColor = [UIColor whiteColor];
        [self.view makeToast:@"Ivalid URL"
                    duration:2.0
                    position:CSToastPositionBottom
                       style:style];
        
        
        printf("not valid url");
        
        
        
    }
    
    
    
}

- (void)refreshdata
{
    //    // Reload table data
    //[self.myTableView reloadData];
    // check network connection
    
    
    NSString *serviceName=@"getExhibitors";
    NSString *serviceURL = myURL;
    
    [self connectToService:serviceName WithURL:serviceURL];
    
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
