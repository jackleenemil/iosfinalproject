//
//  SessionOne.m
//  CocoapodDemo
//
//  Created by JETS on 3/6/17.
//  Copyright © 2017 JETS. All rights reserved.
//
#import "Speaker.h"
#import "SessionOne.h"
#import "NetworkManager.h"
#import "DatabaseManager.h"
#import "JETSNetworkDelegate.h"
#import "MyCustomCell.h"
#import "SpeakerOne.h"
#import "AFNetworking.h"
#import <UIImage+AFNetworking.h>
#import <UIImageView+AFNetworking.h>

@interface SessionOne ()
{
    NSMutableString *myURL;
     UIActivityIndicatorView *activity;
    NSArray *mySpeakers;
    SpeakerOne * speak;
    
    
}
@property DatabaseManager *db;

@property int con;


@end

@implementation SessionOne

- (void)viewDidLoad {
    [super viewDidLoad];
     [_mytableview setBackgroundColor:[UIColor clearColor]];
    _db =[DatabaseManager sharedinstance];
    _uu =[User sharedInstance];
    [_mytableview     setDelegate:self];
    [_mytableview setDataSource:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)connectToService :(NSString*) serviceName WithURL :(NSString*) serviceURLString {
    NSURL *url = [NSURL URLWithString:serviceURLString];
    NetworkManager *network = [NetworkManager new];
    [network setNetworkDelegate: self];
    [NetworkManager connect:url:serviceName:network];
}

- (void)viewWillAppear:(BOOL)animated{
    
    if([[_s status] intValue]==0)
    {
        
        [_favourite setBackgroundImage:[UIImage imageNamed:@"sessionnotadded.png"] forState:UIControlStateNormal];
    }else if ([[_s status] intValue]==1)
    {
        [_favourite setBackgroundImage:[UIImage imageNamed:@"sessionpending.png"] forState:UIControlStateNormal];
    }else if ([[_s status] intValue]==2)
    {
        [_favourite setBackgroundImage:[UIImage imageNamed:@"sessionapproved.png"] forState:UIControlStateNormal];
    }
    
    
    NSAttributedString * attrSt = [[NSAttributedString alloc] initWithData:[[_s name] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _name.attributedText=attrSt;
    
    
    [_name setFont:[_name.font fontWithSize:20 ]];
    
    _name.lineBreakMode = NSLineBreakByWordWrapping;
    _name.numberOfLines = 0;
    
    [_name setTextAlignment:UITextAlignmentCenter];
    
    
    
    
    [_location setText:[_s locationn]];
    
  //  [_name setText:[_s name]];
    printf("%s",[[_s name] UTF8String]);
    printf("%s",[[_s status] UTF8String]);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"hh:mm a"];
    NSTimeInterval intervalValue1 = [[_s startDate] doubleValue]/1000;
    NSTimeInterval intervalValue2 = [[_s endDate] doubleValue]/1000;
    
    NSMutableString *label3 = [NSMutableString new];
    [label3 appendString:[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:intervalValue1]]];
    [label3 appendString:@" - "];
    [label3 appendString:[dateFormat stringFromDate:[NSDate dateWithTimeIntervalSince1970:intervalValue2]]];
    [_enddate setText:label3];
    
    
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[[_s desc] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    _descrip.attributedText=attrStr;
    mySpeakers=[_s    speakers];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"EE d LLLL"];  // here replace your format dd.MM.yyyy
   
    if(_whichOne){
    
    
    switch ([[_s day] intValue]) {
        case 1:
        {
            NSTimeInterval interval1 = [[_sv date1] doubleValue]/1000;
            [_day setText:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval1]]];
            break;
        }
        case 2:
        {
            NSTimeInterval interval2 = [[_sv date2] doubleValue]/1000;
            [_day setText:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval2]]];
            break;
        }
        case 3:
        {
            NSTimeInterval interval3 = [[_sv date3] doubleValue]/1000;
            [_day setText:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval3]]];
            break;
        }    
        default:
            break;
    }
    
    
    }else{
        
        
        switch ([[_s day] intValue]) {
            case 1:
            {
                NSTimeInterval interval1 = [[_mg date1] doubleValue]/1000;
                [_day setText:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval1]]];
                break;
                
            }case 2:
            {
                NSTimeInterval interval1 = [[_mg date2] doubleValue]/1000;
                [_day setText:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval1]]];
                break;            }
            case 3:
            {
                NSTimeInterval interval1 = [[_mg date1] doubleValue]/1000;
                [_day setText:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval1]]];
                break;
            }
                
                
                
            default:
                break;
        }

        
        
    }
    
    
    
    
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)Prressbutton:(id)sender {
    
    if([[_s status] intValue]==0)
    {
        
        [_favourite setBackgroundImage:[UIImage imageNamed:@"sessionnotadded.png"] forState:UIControlStateNormal];
    }else if ([[_s status] intValue]==1)
    {
        [_favourite setBackgroundImage:[UIImage imageNamed:@"sessionpending.png"] forState:UIControlStateNormal];
    }else if ([[_s status] intValue]==2)
    {
        [_favourite setBackgroundImage:[UIImage imageNamed:@"sessionapproved.png"] forState:UIControlStateNormal];
    }
    
    
    myURL = [NSMutableString new];
    NSString *str=@"http://www.mobiledeveloperweekend.net/service/registerSession?userName=";
    NSString *r=[str stringByAppendingString:_uu.email];
    
   // NSString *a=[str stringByAppendingString:eng.medhat.cs.h@gmail.com];
    NSString *b=[r stringByAppendingString:@"&sessionId="];
    NSString *c=[b stringByAppendingString:[_s idd]];
    NSString *d=[c stringByAppendingString:@"&enforce=false"];
     NSString *e=[d stringByAppendingString:@"&status="];

    NSString *f=[e stringByAppendingString:[_s status]];
    [myURL appendString:f];
    
    NSString *serviceName=@"registerSession";
    NSString *serviceURL = myURL;
    [self connectToService:serviceName WithURL:serviceURL];
  

}

-(void)handle:(NSData *)dataRetreived :(NSString *)serviceName : (int) m{
    
    if(m==1){
    
    if ([serviceName isEqualToString:@"registerSession"]) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataRetreived options:0 error:nil];
         NSDictionary *result = [dict objectForKey:@"result"];
        NSString *status=[result objectForKey:@"status"] ;
        NSString *oldsessionid=[result objectForKey:@"oldSessionId"];
        
        if([oldsessionid intValue]==0)
        {
            if([status intValue]==0)
            {
               
                [_favourite setBackgroundImage:[UIImage imageNamed:@"sessionnotadded.png"] forState:UIControlStateNormal];
            }else if ([status intValue]==1)
            {
               [_favourite setBackgroundImage:[UIImage imageNamed:@"sessionpending.png"] forState:UIControlStateNormal];
            }else if ([status intValue]==2)
            {
               [_favourite setBackgroundImage:[UIImage imageNamed:@"sessionapproved.png"] forState:UIControlStateNormal];
            }
            
        }

    }
        
    }else{
        
        
        
    }
    
    
    
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
        Speaker *sp=[mySpeakers objectAtIndex:indexPath.row] ;
        
        
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:[speak imageURL]]];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIImage *i = [UIImage imageWithData:d];
//                if (i != nil){
//                    cell.myImage.image =i;
//                    
//                }
//                
//            });
//            
//        });
//
     NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:sp.imageURL]];
    
    [cell.myImage setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"Speaker.png"] success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
        NSLog(@"Loaded successfully");
        
       [cell.myImage setImage:image];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        
        [sp setImg:imageData];
        
        [_db addImageInSpeaker :[[mySpeakers objectAtIndex:indexPath.row] idd] :imageData];
        
        //            NSMutableArray *imagesspeaker=[NSMutableArray new];
        //            imagesspeaker[indexPath.row]=imageData;
        //            printf("ddd");
        
        
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
        NSLog(@"failed loading");
    }];

    
    
    
    
    printf("%s",[[[mySpeakers objectAtIndex:indexPath.row] fName] UTF8String]);
    
    NSString *f=[[mySpeakers objectAtIndex:indexPath.row] fName];
    NSString *u=[f stringByAppendingString:@" "];
    NSString *m=[u stringByAppendingString:[[mySpeakers objectAtIndex:indexPath.row]middleName]];
    NSString *y=[m stringByAppendingString:@" "];
    NSString *l=[y stringByAppendingString:[[mySpeakers objectAtIndex:indexPath.row] lName]];
cell.myLabel1.text = l;
    
    
        //cell.myLabel1.text = [[mySpeakers objectAtIndex:indexPath.row] fName];
        cell.myLabel2.text  = [[mySpeakers objectAtIndex:indexPath.row] titlee];
        cell.myLabel2.lineBreakMode = NSLineBreakByWordWrapping;
        cell.myLabel2.numberOfLines = 0;
        [cell.myLabel2 sizeToFit];

        
        
        
        //cell.myImage.image = [UIImage imageNamed:@"Speaker.png"];
      //  cell.myImage.image=[[mySpeakers objectAtIndex:indexPath.row] ];
    
    
    cell.backgroundColor = [UIColor clearColor];
    [cell setBackgroundView:cell.contentView];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    speak=[SpeakerOne  new];
    
    // [self presentViewController:speak  animated:YES completion:nil];
    [self.navigationController pushViewController:speak animated:NO];
    
    [speak setS:[mySpeakers objectAtIndex:indexPath.row]];
    
    
}

    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    printf("%d",[mySpeakers count]);
    return [mySpeakers count];
}

@end
