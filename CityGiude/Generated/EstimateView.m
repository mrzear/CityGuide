//
//  EstimateView.m
//  ChildBook
//
//  Created by Dmitry Kuznetsov on 30/03/14.
//  Copyright (c) 2014 Appsgroup. All rights reserved.
//

#import "EstimateView.h"
#import "iLink.h"
#import "Constants.h"
#import "UIImageView+AFNetworking.h"
#import "PlaceDetailViewController.h"
#import "DiscountDetailViewController.h"
#import "DBWork.h"
#import "ActivityView.h"

@implementation EstimateView

@synthesize imageBkg, imageShare;
@synthesize btnNever, btnEstimate, btnLater;
@synthesize lblSubTitle, lblTitle;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imageBkg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageBkg.contentMode = UIViewContentModeScaleAspectFill;
        self.imageBkg.clipsToBounds = YES;
        
        [self.imageBkg setBackgroundColor:[UIColor blackColor]];
        self.imageBkg.alpha = 0.7f;
        [self addSubview:self.imageBkg];
        
//        self.imageShare = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"social_bkg"]];
//        CGFloat ih = self.imageShare.frame.size.height;
//        CGFloat iw = self.imageShare.frame.size.width;
//        CGFloat vh = frame.size.height;
//        CGFloat vw = frame.size.width;
        
        self.imageShare = [[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 90, 90)];
        self.imageShare.layer.cornerRadius = kImageViewCornerRadius;
        self.imageShare.layer.masksToBounds = YES;
        self.imageShare.image = [UIImage imageNamed:@"no_photo"];
        [self addSubview:self.imageShare];
//        
//        
//        
        self.btnNever = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - 10 - 20, 25, 20, 20)];
        [self.btnNever setBackgroundColor:[UIColor whiteColor]];
        [self.btnNever setImage:[UIImage imageNamed:@"fileclose"] forState:UIControlStateNormal];
        [self.btnNever addTarget:self action:@selector(buttonNeverPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.btnNever.layer.cornerRadius = kImageViewCornerRadius;
        self.btnNever.layer.masksToBounds = YES;
        [self addSubview:self.btnNever];
        
        //==== add labels ===
        self.lblTitle = [[UILabel alloc] initWithFrame: CGRectMake(110, 25, 170, 90)];
        
        [self.lblTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:15]];
        self.lblTitle.textAlignment = NSTextAlignmentLeft;
        //[self.lblTitle setText:@"Oh this is it"];
        [self.lblTitle setNumberOfLines:0];
        [self.lblTitle setTextColor:[UIColor whiteColor]];
        //[self.lblTitle sizeToFit];
        [self addSubview:self.lblTitle];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(alertViewTap:)];
        [self addGestureRecognizer:tap];
//
//        self.btnLater = [[UIButton alloc] initWithFrame:CGRectMake(self.imageShare.frame.origin.x, self.imageShare.frame.origin.y + self.imageShare.frame.size.height - 88, self.imageShare.frame.size.width, 44)];
//        //        [self.btnCancel setBackgroundImage:img forState:UIControlStateNormal];
//        [self.btnLater setTitle:@"Позже" forState:UIControlStateNormal];
//        [self.btnLater setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.btnLater addTarget:self action:@selector(buttonLaterPressed:) forControlEvents:UIControlEventTouchUpInside];
//        
//        //self.btnLater.layer.borderWidth = 1.0f;
//        //self.btnLater.layer.borderColor = [[UIColor grayColor] CGColor];
//        
//        [self addSubview:self.btnLater];
//        
//        self.btnEstimate = [[UIButton alloc] initWithFrame:CGRectMake(self.imageShare.frame.origin.x, self.imageShare.frame.origin.y + self.imageShare.frame.size.height - 132, self.imageShare.frame.size.width, 44)];
//        [self.btnEstimate setTitle:@"Оценить" forState:UIControlStateNormal];
//        [self.btnEstimate setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//        [self.btnEstimate addTarget:self action:@selector(buttonEstimatePressed:) forControlEvents:UIControlEventTouchUpInside];
//
//        [self addSubview:self.btnEstimate];
//        
//        // ==== add break line ======
//        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageShare.frame.origin.x, self.imageShare.frame.origin.y + self.imageShare.frame.size.height - 88, self.imageShare.frame.size.width, 1)];
//        img.image = [UIImage imageNamed:@"breakline"];
//        [self addSubview:img];
//        
//        UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageShare.frame.origin.x, self.imageShare.frame.origin.y + self.imageShare.frame.size.height - 45, self.imageShare.frame.size.width, 0.5)];
//        img2.image = [UIImage imageNamed:@"breakline"];
//        [self addSubview:img2];
//        

//        
//        self.lblSubTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.imageShare.frame.origin.x, self.imageShare.frame.origin.y + 35, self.imageShare.frame.size.width, 25)];
//        [self.lblSubTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
//        self.lblSubTitle.textAlignment = NSTextAlignmentCenter;
//        self.lblSubTitle.text = @"Будем рады вашей оценке!";
//        [self.lblSubTitle setBackgroundColor:[UIColor clearColor]];
//        [self addSubview:self.lblSubTitle];

    }
    return self;
}


-(IBAction)buttonNeverPressed:(id)sender{
    
    //[[BooksData shared] setRatingStatus:[NSNumber numberWithInt:-1]];
    [self hideWithAnimation:YES];
}

-(IBAction)buttonLaterPressed:(id)sender{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *ratingArray = [userDefaults objectForKey:@"ratingArray"];
    NSNumber *rate = ratingArray.firstObject;
    
    if(rate.intValue == -20){
        //[[BooksData shared] setRatingStatus:[NSNumber numberWithInt:-1]];
    }
    else{
        //[[BooksData shared] setRatingStatus:[NSNumber numberWithInt:-20]];
    }
    
    
    [self hideWithAnimation:YES];
}

-(IBAction)buttonEstimatePressed:(id)sender{
    
//    NSURL *url;
    
    [[iLink sharedInstance] iLinkOpenRatingsPageInAppStore];
    
//    if(NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_6_1){
//        url = [NSURL URLWithString:iOS6_RATING_URL];
//    }
//    else{
//        url = [NSURL URLWithString:iOS7_RATING_URL];
//    }
//    [[UIApplication sharedApplication] openURL:url];
    
    //[[BooksData shared] setRatingStatus:[NSNumber numberWithInt:-1]];
    [self hideWithAnimation:YES];
}

- (void)hideWithAnimation:(BOOL)anAnimation
{
    if (anAnimation)
    {
        [UIView animateWithDuration:0.2
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             self.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             [self removeFromSuperview];
         }];
    }
    else
    {
        [self removeFromSuperview];
    }
}

- (void)showInView:(UIViewController*)aView animated:(BOOL)anAnimated
{
    //CGRect endFrame = aView.frame;
    self.destinationViewController = aView;
    UIView *showView = aView.navigationController.view;
    CGRect endFrame = CGRectMake(showView.frame.size.width/2 - self.frame.size.width/2, 0, self.frame.size.width, self.frame.size.height);
    
    if([self.parentType isEqualToString:@"event"]){
        Discounts *aCategory = [[DBWork shared] getDiscountByID:self.parentID];
        if(aCategory){
            [self setAlertImage:aCategory.image];
        }
    }
    else if([self.parentType isEqualToString:@"place"]){
        Places *aPlace = [[DBWork shared] getPlaceByplaceID:self.parentID];
        if(aPlace){
            [self setAlertImage:aPlace.photo_small];
        }
    }
    
    self.frame = endFrame;
    if (anAnimated)
    {
        self.alpha = 0.0f;
        [UIView animateWithDuration:0.3
                              delay:0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations:^
         {
             self.alpha = 1.0f;
         }
                         completion:^(BOOL finished)
         {
         }];
    }
    
    [showView addSubview:self];
}

-(void)setAlertText:(NSString *)alertText{
    [self.lblTitle setText:alertText];
}

-(void)setAlertImage:(NSString *)alertImageUrl{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", URL_BASE, alertImageUrl];
    NSURL *imgUrl = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"Alert Image: %@", imgUrl);
    //cell.placeImage.image = [UIImage imageNamed:@"default50"];
    [self.imageShare setImageWithURLRequest:[NSURLRequest requestWithURL:imgUrl]
                                      placeholderImage:nil
                                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                   // do image resize here
                                                   // then set image view
                                                   NSLog(@"Alert Image downloaded");
                                                   self.imageShare.image = image;
                                               }
                                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                    
                                                   NSLog(@"Alert Image. Fail to download image");
                                                   // do any other error handling you want here
                                               }];
}

-(void)alertViewTap:(UIGestureRecognizer*)gesture{
    NSLog(@"alertViewTap");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    if([self.parentType isEqualToString:kAttributeParentPlace]){
        if(![self.destinationViewController isKindOfClass:[PlaceDetailViewController class]]){//если я на детальном экране, то просто закрываю PushView
            PlaceDetailViewController *pd = [storyboard instantiateViewControllerWithIdentifier:@"PlaceDetailViewController"];
            Places *aPlace = [[DBWork shared] getPlaceByplaceID:self.parentID];
            if(aPlace){
                pd.aPlace = aPlace;
                [self.destinationViewController.navigationController pushViewController:pd animated:YES];
            }
            else{
                [self presentActivityView];
            }
        }
    }
    else{
        if(![self.destinationViewController isKindOfClass:[DiscountDetailViewController class]]){//если я на детальном экране, то просто закрываю PushView
            DiscountDetailViewController *pd = [storyboard instantiateViewControllerWithIdentifier:@"DiscountDetailViewController"];
            Discounts *aPlace = [[DBWork shared] getDiscountByID:self.parentID];
            if(aPlace){
                pd.aDiscount = aPlace;
                [self.destinationViewController.navigationController pushViewController:pd animated:YES];
            }
            else{
                [self presentActivityView];
            }
        }
    }
    
    [self hideWithAnimation:YES];
    
}

-(void)presentActivityView{
    ActivityView *activity = [[ActivityView alloc] initWithFrame:self.destinationViewController.view.frame andDestinationViewController:self.destinationViewController];
    
    [activity setAlertParentType:self.parentType];
    [activity setAlertParetnID:self.parentID];
    [activity showInView:self.destinationViewController animated:YES];
}

-(void)setAlertParetnID:(NSNumber*)parentID{
    self.parentID = parentID;
}
-(void)setAlertParentType:(NSString*)parentType{
    self.parentType = parentType;
}


@end
