//  UserProfile.m
//  CocoapodDemo
//  Created by Rana on 2/22/17.


#import "UserProfile.h"
#import <ZXingObjC/ZXingObjC.h>
#import "DatabaseManager.h"
#import "AFNetworking.h"
#import <UIImage+AFNetworking.h>
#import <UIImageView+AFNetworking.h>
#import "DatabaseManager.h"
#import "Reachability.h"
#import "SWRevealViewController.h"
@interface UserProfile ()

@property DatabaseManager *db;
@property int con;
@end

@implementation UserProfile

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //*******************Menu Button Function***********/
    
    
    SWRevealViewController *revealController = [self revealViewController];
    
    [self.navigationController.navigationBar addGestureRecognizer:revealController.panGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reveal-icon.png"]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    
    
#pragma mark - Example Code
    
    
    
    /**************************************/
    
    
    _res =[User sharedInstance];
    _db =[DatabaseManager sharedinstance];
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        
        _con=0;
      
        
    }else{
        
        _con=1;
    
        
    }
    
    
    
    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//    bgImageView.frame = self.view.bounds;
//    [self.view addSubview:bgImageView];
//    [self.view sendSubviewToBack:bgImageView];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    
   // [_userID setText:[NSString stringWithFormat:@"%d", [[_res idd] integerValue]]];
    //[_date setText:[_res birthDate]];
    //[_code setText:[_res code]];
    [_email setText:[_res email]];
    NSString *f=[_res firstName];
    NSString *u=[f stringByAppendingString:@" "];
    NSString *m=[u stringByAppendingString:[_res midName]];
    NSString *y=[m stringByAppendingString:@" "];
    NSString *l=[y stringByAppendingString:[_res lastName]];
    [_fname setText:l];
    printf("%s",[l UTF8String]);
   // [_fname setText:[_res firstName]];
   // [_lname setText:[_res lastName]];
    //[_country setText:[_res country_name]];
   // [_mname setText:[_res midName]];
    //[_gender setText:[_res gender]];
   // [_city setText:[_res city_name]];
    [_company setText:[_res comp_name]];
    [_tit setText:[_res titlee]];

    
//   NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_res img_url]]];
//   UIImage *i = [UIImage imageWithData:d];
// _im.image = i;
    
   // [_im sd_setImageWithURL:[NSURL URLWithString:[_res img_url].lowercaseString]];
    
    
    [_imageview setImage:[UIImage imageWithData:_res.img]];
   
    if(_con==1){
    
    NSString *fileName = [_res img_url];
    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:[_res img_url]]];
    
    [_imageview setImageWithURLRequest:req placeholderImage:[UIImage imageNamed:@"Speaker.png"] success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
        NSLog(@"Loaded successfully");
       
        [_imageview setImage:image];
        
        NSData *imageData = UIImagePNGRepresentation(image);
        
        [_db addImageInUser:_res.idd :imageData];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
      
        [_imageview setImage:[UIImage imageWithData:_res.img]];
        
        NSLog(@"failed loading");
    }];
    

        
    }else{
        
        [_imageview setImage:[UIImage imageWithData:_res.img]];
        
    }

    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *d = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_res img_url]]];
       // dispatch_async(dispatch_get_main_queue(), ^{
//            UIImage *i = [UIImage imageWithData:d];
//            if (i != nil){
//                [_imageview setImage:i];
//            }
//            
//        });
//        
//    });
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:[_res code]
                                  format:kBarcodeFormatQRCode
                                   width:500
                                  height:500
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
       
        
        UIImage* uiImage = [[UIImage alloc] initWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];
        self.codeimage.image=uiImage;
        
        
        
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString *errorMessage = [error localizedDescription];
    }
    

    NSError *erro = nil;
    ZXMultiFormatWriter *write = [ZXMultiFormatWriter writer];
    ZXBitMatrix* resul = [write encode:[_res email]
                                  format:kBarcodeFormatQRCode
                                   width:500
                                  height:500
                                   error:&error];
    if (result) {
        CGImageRef imag = [[ZXImage imageWithMatrix:resul] cgimage];
        
        
        UIImage* uiImag = [[UIImage alloc] initWithCGImage:[[ZXImage imageWithMatrix:resul] cgimage]];
        self.emailcode.image=uiImag;
        
        
        
        // This CGImageRef image can be placed in a UIImage, NSImage, or written to a file.
    } else {
        NSString *errorMessage = [erro localizedDescription];
    }

    
    
//    
//       NSString *ext = [fileName pathExtension];
//    printf("%s", [ext UTF8String]);
    
    
    
    
//    
//    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadWithURL:[NSURL URLWithString:[_res img_url]] options:0 progress:^(NSInteger receivedSize, long long expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        
//        if(image){
//            _im.image = image;
//            NSString *localKey = [NSString stringWithFormat:@"Item-%d", i];
//            [[SDImageCache sharedImageCache] storeImage:image forKey:localKey];
//        }
//        
//    }];
    
//    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:@"http://vignette1.wikia.nocookie.net/sweeneytodd/images/5/57/Mrs._Lovett.jpg"] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
//        
//        if (image && finished) {
//            // Cache image to disk or memory
//
//            UIImage *i = [UIImage imageWithData:data];
//            _im.image = i;
//            [[SDImageCache sharedImageCache] storeImage:image forKey:@"myKey" toDisk:YES];
//        }
//    }];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mycontact:(id)sender {
    if (_secondview.hidden){
        _secondview.hidden = false;
    } else {
        _secondview.hidden = true;
    }
}
@end
