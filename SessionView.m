//
//  SessionView.m
//  CocoapodDemo
//
//  Created by JETS on 3/2/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "SessionView.h"
#import "MyCustomCell.h"
#import "NetworkManager.h"
#import "JETSNetworkDelegate.h"
#import "Session.h"
#import "Reachability.h"
#import "SWRevealViewController.h"
#import "SessionOne.h"
#import "User.h"
#import "UIView+Toast.h"
#import "UILabel+HTML.h"
@interface SessionView (){
    NSMutableString *myURL;
    UIActivityIndicatorView *activity;
    
    SessionOne  *sessionone;
    
}
@property int day;

@end

@implementation SessionView




//- (IBAction)pushExample:(id)sender
//{
//    UIViewController *stubController = [[UIViewController alloc] init];
//    stubController.view.backgroundColor = [UIColor whiteColor];
//    [self.navigationController pushViewController:stubController animated:YES];
//}


//////////////////
- (void)refreshdata
{
    //    // Reload table data
    //[self.myTableView reloadData];
    // check network connection

    
    NSString *serviceName=@"getSessions";
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

- (void)viewDidLoad {
    [super viewDidLoad];
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
    _db =[DatabaseManager sharedinstance];
    [_myTableView setDelegate:self];
    [_myTableView setDataSource:self];
    _myList = [NSMutableArray new];
    _allDays = [NSMutableArray new];
    _day1List = [NSMutableArray new];
    _day2List = [NSMutableArray new];
    _day3List = [NSMutableArray new];
    myURL = [NSMutableString new];
    [_myTableView setBackgroundColor:[UIColor clearColor]];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
       
        //no connection
        _myList =[_db getAllSessions];
        
        if(_myList != nil){
            printf("inn");
            
            for(int i ;i<_myList.count;i++){
                
                Session *s =[_myList objectAtIndex:i];
                 s.speakers=[_db getAllSeSpeakers:s.idd];
                
                if([s.day isEqualToString:@"1"]){
                    [_day1List addObject:s];
                    
                }else if ([s.day isEqualToString:@"2"]){
                    [_day2List addObject:s];
                    
                    
                }else{
                    [_day3List addObject:s];
                    
                }
                
                
            }
            
            
        }
        
        
        [self.myTableView reloadData];
        
        
        
    } else {
        printf("There IS internet connection");
    
    
    
    [myURL appendString:@"http://www.mobiledeveloperweekend.net/service/getSessions?userName="];
        [myURL appendString:_uu.email];
    
    NSString *serviceName=@"getSessions";
    NSString *serviceURL = myURL;
    [activity startAnimating];
        
        
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
    //////////////
    
    
    
    NSString * htmlString = [[_myList objectAtIndex:indexPath.row] name];
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    cell.myLabel1.attributedText=attrStr;
    cell.myLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    cell.myLabel1.numberOfLines = 0;
    [cell.myLabel1 sizeToFit];
    
    
    
       // [cell.myLabel1 setHtml:[[_myList objectAtIndex:indexPath.row] name]];
        
        cell.myLabel2.text = [[_myList objectAtIndex:indexPath.row] locationn];
        cell.myLabel2.lineBreakMode = NSLineBreakByWordWrapping;
        cell.myLabel2.numberOfLines = 0;
        [cell.myLabel2 sizeToFit];
    
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"hh:mm a"];
        NSTimeInterval intervalValue1 = [[[_myList objectAtIndex:indexPath.row] startDate] doubleValue]/1000;
        NSTimeInterval intervalValue2 = [[[_myList objectAtIndex:indexPath.row] endDate] doubleValue]/1000;
        
        NSMutableString *label3 = [NSMutableString new];
        [label3 appendString:[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:intervalValue1]]];
        [label3 appendString:@" - "];
        [label3 appendString:[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:intervalValue2]]];
        cell.myLabel3.text = label3;
        
        
        Session *s =[_myList objectAtIndex:indexPath.row];
        
    
    switch(_day){
            
        case 0:
        
        if(indexPath.row<[_day1List count]){
            
            if([s.type isEqualToString:@"Session"]){
                
                UIImage *sessionImage=[UIImage imageNamed:@"session13.png"];
                cell.myImage.image=sessionImage;
                
            }else if([s.type isEqualToString:@"Break"]){
                
                UIImage *breakImage=[UIImage imageNamed:@"breakicon.png"];
                cell.myImage.image=breakImage;
                
            }else if([s.type isEqualToString:@"Workshop"]){
                UIImage *workImage=[UIImage imageNamed:@"workshop13.png"];
                cell.myImage.image=workImage;
                
                
            }else{
                UIImage *hac=[UIImage imageNamed:@"hacathon13.png"];
                cell.myImage.image=hac;
                
            }
            
            
        }else if(indexPath.row<[_day2List count]+[_day1List count]){
            
            if([s.type isEqualToString:@"Session"]){
                
                UIImage *sessionImage=[UIImage imageNamed:@"session14.png"];
                cell.myImage.image=sessionImage;
                
            }else if([s.type isEqualToString:@"Break"]){
                
                UIImage *breakImage=[UIImage imageNamed:@"breakicon.png"];
                cell.myImage.image=breakImage;
                
            }else if([s.type isEqualToString:@"Workshop"]){
                UIImage *workImage=[UIImage imageNamed:@"workshop14.png"];
                cell.myImage.image=workImage;
                
                
            }else{
                UIImage *hac=[UIImage imageNamed:@"hacathon14.png"];
                cell.myImage.image=hac;
                
            }
            
            
            
            
        }else{
            
            
            if([s.type isEqualToString:@"Session"]){
                
                UIImage *sessionImage=[UIImage imageNamed:@"session15.png"];
                cell.myImage.image=sessionImage;
                
            }else if([s.type isEqualToString:@"Break"]){
                
                UIImage *breakImage=[UIImage imageNamed:@"breakicon.png"];
                cell.myImage.image=breakImage;
                
            }else if([s.type isEqualToString:@"Workshop"]){
                UIImage *workImage=[UIImage imageNamed:@"workshop15.png"];
                cell.myImage.image=workImage;
                
                
            }else{
                UIImage *hac=[UIImage imageNamed:@"hacathon15.png"];
                cell.myImage.image=hac;
                
            }
            
            
            
            
        }
        
        
        break;
        
        case 1:
            
            if([s.type isEqualToString:@"Session"]){
                
                UIImage *sessionImage=[UIImage imageNamed:@"session13.png"];
                cell.myImage.image=sessionImage;
                
            }else if([s.type isEqualToString:@"Break"]){
                
                UIImage *breakImage=[UIImage imageNamed:@"breakicon.png"];
                cell.myImage.image=breakImage;
                
            }else if([s.type isEqualToString:@"Workshop"]){
                UIImage *workImage=[UIImage imageNamed:@"workshop13.png"];
                cell.myImage.image=workImage;
                
                
            }else{
                UIImage *hac=[UIImage imageNamed:@"hacathon13.png"];
                cell.myImage.image=hac;
                
            }

            
        break;
            
            
        case 2:
            
            if([s.type isEqualToString:@"Session"]){
                
                UIImage *sessionImage=[UIImage imageNamed:@"session14.png"];
                cell.myImage.image=sessionImage;
                
            }else if([s.type isEqualToString:@"Break"]){
                
                UIImage *breakImage=[UIImage imageNamed:@"breakicon.png"];
                cell.myImage.image=breakImage;
                
            }else if([s.type isEqualToString:@"Workshop"]){
                UIImage *workImage=[UIImage imageNamed:@"workshop14.png"];
                cell.myImage.image=workImage;
                
                
            }else{
                UIImage *hac=[UIImage imageNamed:@"hacathon14.png"];
                cell.myImage.image=hac;
                
            }
            
 
            
         
        break;
            
            
        
        case 3:
            
            if([s.type isEqualToString:@"Session"]){
                
                UIImage *sessionImage=[UIImage imageNamed:@"session15.png"];
                cell.myImage.image=sessionImage;
                
            }else if([s.type isEqualToString:@"Break"]){
                
                UIImage *breakImage=[UIImage imageNamed:@"breakicon.png"];
                cell.myImage.image=breakImage;
                
            }else if([s.type isEqualToString:@"Workshop"]){
                UIImage *workImage=[UIImage imageNamed:@"workshop15.png"];
                cell.myImage.image=workImage;
                
                
            }else{
                UIImage *hac=[UIImage imageNamed:@"hacathon15.png"];
                cell.myImage.image=hac;
                
            }
            
            
            
            
        break;
            
            
            
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

-(void)handle:(NSData *)dataRetreived :(NSString *)serviceName :(int)check{
    if(check==1){
    
    if ([serviceName isEqualToString:@"getSessions"]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
        
        if([[dict objectForKey:@"status"] isEqualToString:@"view.success"]){
            // Success
            printf("success");
            NSDictionary *result = [dict objectForKey:@"result"];
            NSArray *agendas = [result objectForKey:@"agendas"];
            
            NSDictionary *day1 = [agendas objectAtIndex:0];
            _date1 = [[day1 objectForKey:@"date"] stringValue] ;
            printf("%s",[_date1 UTF8String]);
            
            NSArray *sess1 = [day1 objectForKey:@"sessions"];
            for (int i1=0; i1<sess1.count; i1++){
              
                NSDictionary *d1 = [sess1 objectAtIndex:i1];
                Session *s1 = [Session new];
                [s1 setName:[d1 objectForKey:@"name"]];
                [s1 setLocationn:[d1 objectForKey:@"location"]];
                [s1 setIdd:[[d1 objectForKey:@"id"] stringValue]];
                [s1 setDesc:[d1 objectForKey:@"description"]];
                
                NSArray *speakers=[NSArray new];
                speakers = [d1 objectForKey:@"speakers"];
                NSMutableArray *mySpeakers = [NSMutableArray new];
                
                if(speakers==(NSArray*)[NSNull null]){
                    Speaker *ns=[Speaker new];
                    [mySpeakers addObject:ns];
                    
                    [s1 setSpeakers:mySpeakers];
                }
                else
                {
                    
                    
                    
                    
                    for (int j=0; j<speakers.count; j++){
                        NSDictionary *dd = [speakers objectAtIndex:j];
                        Speaker *s = [Speaker new];
                        [s setIdd:[[dd objectForKey:@"id"]stringValue]];
                        [s setFName:[dd objectForKey:@"firstName"]];
                        [s setLName:[dd objectForKey:@"lastName"]];
                        [s setCompanyName:[dd objectForKey:@"companyName"]];
                        [s setTitlee:[dd objectForKey:@"title"]];
                        [s setMobiles:[dd objectForKey:@"mobiles"]];
                        [s setPhones:[dd objectForKey:@"phones"]];
                        [s setMiddleName:[dd objectForKey:@"middleName"]];
                        [s setBiography:[dd objectForKey:@"biography"]];
                        [s setImageURL:[dd objectForKey:@"imageURL"]];
                        [s setGender:[[dd objectForKey:@"gender"]stringValue]];
                        [mySpeakers addObject:s];
                    }
                    [s1 setSpeakers: mySpeakers];
                    
                }
                [s1 setStatus:[[d1 objectForKey:@"status"]stringValue]];
                [s1 setStartDate:[[d1 objectForKey:@"startDate"]stringValue]];
                [s1 setEndDate:[[d1 objectForKey:@"endDate"]stringValue]];
                [s1 setType:[d1 objectForKey:@"sessionType"]];
                [s1 setIsLiked:[d1 objectForKey:@"liked"]];
                s1.day=@"1";
                NSString *t =[d1 objectForKey:@"sessionTags"];
                if(t ==(NSString*)[NSNull null]){
                    [s1 setSessionTag :@" "];
                }
                else
                {
                    [s1 setSessionTag:t] ;
                    
                }
                
                [_day1List addObject:s1];
                [_myList addObject:s1];
            
            
            }
            
            NSDictionary *day2 = [agendas objectAtIndex:1];
             _date2 = [[day2 objectForKey:@"date"] stringValue];
            NSArray *sess2 = [day2 objectForKey:@"sessions"];
            for (int i1=0; i1<sess2.count; i1++){
                
                NSDictionary *d1 = [sess2 objectAtIndex:i1];
                Session *s1 = [Session new];
                [s1 setName:[d1 objectForKey:@"name"]];
                [s1 setLocationn:[d1 objectForKey:@"location"]];
                [s1 setIdd:[[d1 objectForKey:@"id"]stringValue]];
                [s1 setDesc:[d1 objectForKey:@"description"]];
                
                NSArray *speakers=[NSArray new];
                speakers = [d1 objectForKey:@"speakers"];
                NSMutableArray *mySpeakers = [NSMutableArray new];
                
                if(speakers==(NSArray*)[NSNull null]){
                    Speaker *ns=[Speaker new];
                    [mySpeakers addObject:ns];
                    
                    [s1 setSpeakers:mySpeakers];
                }
                else
                {
                    
                    
                    
                    
                    for (int j=0; j<speakers.count; j++){
                        NSDictionary *dd = [speakers objectAtIndex:j];
                        Speaker *s = [Speaker new];
                        [s setIdd:[[dd objectForKey:@"id"]stringValue]];
                        [s setFName:[dd objectForKey:@"firstName"]];
                        [s setLName:[dd objectForKey:@"lastName"]];
                        [s setCompanyName:[dd objectForKey:@"companyName"]];
                        [s setTitlee:[dd objectForKey:@"title"]];
                        [s setMobiles:[dd objectForKey:@"mobiles"]];
                        [s setPhones:[dd objectForKey:@"phones"]];
                        [s setMiddleName:[dd objectForKey:@"middleName"]];
                        [s setBiography:[dd objectForKey:@"biography"]];
                        [s setImageURL:[dd objectForKey:@"imageURL"]];
                        [s setGender:[[dd objectForKey:@"gender"]stringValue]];
                        [mySpeakers addObject:s];
                    }
                    [s1 setSpeakers: mySpeakers];
                    
                }
                
                [s1 setStatus:[[d1 objectForKey:@"status"]stringValue]];
                [s1 setStartDate:[[d1 objectForKey:@"startDate"]stringValue]];
                [s1 setEndDate:[[d1 objectForKey:@"endDate"]stringValue]];
                [s1 setType:[d1 objectForKey:@"sessionType"]];
                [s1 setIsLiked:[d1 objectForKey:@"liked"]];
                s1.day=@"2";
                NSString *t =[d1 objectForKey:@"sessionTags"];
                if(t ==(NSString*)[NSNull null]){
                    [s1 setSessionTag :@" "];
                }
                else
                {
                    [s1 setSessionTag:t] ;
                    
                }
                
                
                
                [_day2List addObject:s1];
                [_myList addObject:s1];

            
            
            }
            
            NSDictionary *day3 = [agendas objectAtIndex:2];
            _date3 = [[day3 objectForKey:@"date"] stringValue];
            NSArray *sess3 = [day3 objectForKey:@"sessions"];
            for (int i1=0; i1<sess3.count; i1++){
               
                NSDictionary *d1 = [sess3 objectAtIndex:i1];
                Session *s1 = [Session new];
                [s1 setName:[d1 objectForKey:@"name"]];
                [s1 setLocationn:[d1 objectForKey:@"location"]];
                [s1 setIdd:[[d1 objectForKey:@"id"]stringValue]];
                [s1 setDesc:[d1 objectForKey:@"description"]];
                NSArray *speakers=[NSArray new];
                speakers = [d1 objectForKey:@"speakers"];
                NSMutableArray *mySpeakers = [NSMutableArray new];
                
                if(speakers==(NSArray*)[NSNull null]){
                    Speaker *ns=[Speaker new];
                    [mySpeakers addObject:ns];
                    
                    [s1 setSpeakers:mySpeakers];
                }
                else
                {
                    for (int j=0; j<speakers.count; j++){
                        NSDictionary *dd = [speakers objectAtIndex:j];
                        Speaker *s = [Speaker new];
                        [s setIdd:[[dd objectForKey:@"id"]stringValue]];
                        [s setFName:[dd objectForKey:@"firstName"]];
                        [s setLName:[dd objectForKey:@"lastName"]];
                        [s setCompanyName:[dd objectForKey:@"companyName"]];
                        [s setTitlee:[dd objectForKey:@"title"]];
                        [s setMobiles:[dd objectForKey:@"mobiles"]];
                        [s setPhones:[dd objectForKey:@"phones"]];
                        [s setMiddleName:[dd objectForKey:@"middleName"]];
                        [s setBiography:[dd objectForKey:@"biography"]];
                        [s setImageURL:[dd objectForKey:@"imageURL"]];
                        [s setGender:[[dd objectForKey:@"gender"]stringValue]];
                        [mySpeakers addObject:s];
                    }
                    [s1 setSpeakers: mySpeakers];
                    
                }
                [s1 setStatus:[[d1 objectForKey:@"status"]stringValue]];
                [s1 setStartDate:[[d1 objectForKey:@"startDate"]stringValue]];
                [s1 setEndDate:[[d1 objectForKey:@"endDate"]stringValue]];
                [s1 setType:[d1 objectForKey:@"sessionType"]];
                [s1 setIsLiked:[d1 objectForKey:@"liked"]];
                s1.day=@"3";
                NSString *t =[d1 objectForKey:@"sessionTags"];
                if(t ==(NSString*)[NSNull null]){
                    [s1 setSessionTag :@" "];
                }
                else
                {
                    [s1 setSessionTag:t] ;
                    
                }
                
                [_day3List addObject:s1];
                [_myList addObject:s1];

                
                
            }
            
            _allDays=_myList ;
            [_db deleteAllSessions];
           [_db addSessions:_myList];
            
            [self.view hideToastActivity];
            [self.myTableView reloadData];
            
            [_db deleteAllSeSpeaker];
            for(int k=0;k<[_myList count];k++){
                Session *ss=[Session new];
                ss=_myList[k];
                
                if(ss.speakers!=nil){
                
                bool check2=[_db addSeSpeakers: ss.speakers :ss.idd];
                
                }
            }
            
            for(int l=0;l<[_myList count];l++){
                Session *ss=[Session new];
                ss=_myList[l];
                NSMutableArray *all2=[_db getAllSeSpeakers:ss.idd];
                Speaker *defs=[Speaker new];
                defs=all2[0];
                if([defs.idd isEqual:@"nel"])
                {
                   
                    ss.speakers=[NSMutableArray new];
                    printf("no speakers for session:%d \n",l);
                    
                }
                
                
            }
            

            
        }
        else {
            // Failed
            printf("failed");
            [myURL setString:@""];
        }
    
    
    }
        
    }else{
        
        //no connection
        
        _myList =[_db getAllSessions];
         
        _allDays =_myList;
        if(_myList != nil){
            printf("inn");
            
            for(int i=0 ;i<_myList.count;i++){
            
            Session *s =[_myList objectAtIndex:i];
                s.speakers=[_db getAllSeSpeakers:s.idd];
           
                if([s.day isEqualToString:@"1"]){
                    [_day1List addObject:s];
                
                }else if ([s.day isEqualToString:@"2"]){
                    [_day2List addObject:s];

                
                }else{
                    [_day3List addObject:s];
                
                }
            
        
            }
            
            
            }
        
        [self.view hideToastActivity];
        [self.myTableView reloadData];
        

    }
    

}


////////////////////

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    sessionone=[SessionOne  new];
    printf("the select f");
   
    [sessionone setSv:self];
    [sessionone setWhichOne:YES];
    [sessionone setS:[_myList objectAtIndex:indexPath.row]] ;
    
    
    [self.navigationController pushViewController:sessionone animated:YES];

    
    //[self presentViewController:sessionone animated:YES completion:nil];
    
    
    
    
    
}





/////////////////////




-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    switch (item.tag) {
        case 10:
            _myList = _allDays;
            _day=0;
            [_myTableView reloadData];
            
            break;
            
        case 11:
            _myList = _day1List;
            _day=1;

            [_myTableView reloadData];
                        break;
            
        case 12:
            _myList = _day2List;
            _day=2;
            [_myTableView reloadData];
            
            break;
            
        case 13:
            _myList = _day3List;
            _day=3;
            [_myTableView reloadData];
            
            break;
    }

}


@end
