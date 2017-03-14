//
//  SpeakerOne.m
//  CocoapodDemo
//
//  Created by JETS on 2/28/17.
//  Copyright © 2017 JETS. All rights reserved.
//

#import "SpeakerOne.h"
#import "Reachability.h"

@interface SpeakerOne ()



@property int con;
@end

@implementation SpeakerOne

- (void)viewDidLoad {
    [super viewDidLoad];
   // [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
   // self.view.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage       imageNamed:@"background.png"]];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {

        _con=0;
    }else{
        
        _con=1;
        
    }
    
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
    bgImageView.frame = self.view.bounds;
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
   
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated{
  
//    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    printf("%s",[[_s fName] UTF8String]);
     printf("%s",[[_s middleName] UTF8String]);
    NSString *f=[_s fName];
    NSString *u=[f stringByAppendingString:@" "];
    NSString *m=[u stringByAppendingString:[_s middleName]];
    NSString *y=[m stringByAppendingString:@" "];
    NSString *l=[y stringByAppendingString:[_s lName]];
    
    
    //[_label4 setText:[_s lName]];
   // [_labelm setText:[_s middleName]];
    [_labeln setText:l];
    [_label2 setText:[_s titlee]];
    [_label3 setText:[_s companyName]];
    [_textview  setText:[_s biography]];
  
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_s imageURL]]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            UIImage *i = [UIImage imageWithData:d];
//            if (i != nil){
//                [_imageview setImage:i];
//            }
//            
//        });
//        
//    });

    
    
    
    
    [_imageview setImage:[UIImage imageWithData:_s.img]];
  
    
    
    
    
    
    _imageview.layer.masksToBounds=YES;
    
    _imageview.layer.borderColor =[UIColor orangeColor].CGColor;
    
    _imageview.layer.borderWidth=1;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
