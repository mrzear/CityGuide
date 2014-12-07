//
//  LaunchViewController.m
//  CityGiude
//
//  Created by Dmitry Kuznetsov on 15/11/14.
//  Copyright (c) 2014 Appsgroup. All rights reserved.
//

#import "LaunchViewController.h"
#import "SyncEngine.h"
#import "Constants.h"

@implementation LaunchViewController{
    NSDictionary *_downloadDict;
    NSString *_filePath;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.statusView.layer.cornerRadius = kImageViewCornerRadius;
    self.progressBar.progress = 0.0f;
    
    [SyncEngine sharedEngine].delegate = self;
    
    self.statusView.hidden = YES;
    
    [self checkNewDataOnServer];
    
}

#pragma mark - Status Label
-(void)setUpdateStatusText:(NSString *)statusLabelText withSubstatus:(NSString *)substatusLabelText{
    [self.statusLabel setText:statusLabelText];
    [self.substatusLabel setText:substatusLabelText];
}

#pragma mark - Check new data
-(void)checkNewDataOnServer{
    [[SyncEngine sharedEngine] downloadJSONDataFromServer];
}

-(void)errorDownloadJSONFromServer{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertError
                                                    message:kAlertJSONError
                                                   delegate:self
                                          cancelButtonTitle:kAlertLater
                                          otherButtonTitles:kAlertRepeat, nil];
    [alert show];
}

-(void)successCheckNewData:(NSDictionary*)jsonData{
    
    NSNumber *time = [jsonData objectForKey:@"time"];
    [[SyncEngine sharedEngine] setTimeStamp:time];
    
    NSNumber *code = [jsonData objectForKey:@"code"];
    
    if(code.integerValue == 0){
        _downloadDict = jsonData;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertUpdateData
                                                        message:kAlertUpdateDataMessage
                                                       delegate:self
                                              cancelButtonTitle:kAlertNo
                                              otherButtonTitles:kAlertYes, nil];
        [alert show];
    }
    else{
        [self startMainScreen];
    
    }
}

#pragma mark - Error Update Data
-(void)errorUpdateDataFromServer{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertError
                                                    message:kAlertUpdateError
                                                   delegate:self
                                          cancelButtonTitle:kAlertLater
                                          otherButtonTitles:kAlertRepeat, nil];
    [alert show];
}

#pragma mark - Alert Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"alertView: %@", alertView.message);
    
    if([alertView.message isEqualToString:kAlertJSONError]){
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [self startMainScreen];
        }
        else{
            [self checkNewDataOnServer];
        }
    }
    else if([alertView.message isEqualToString:kAlertUpdateDataMessage] || [alertView.message isEqualToString:kAlertUpdateError]){
        if (buttonIndex == [alertView cancelButtonIndex]) {
            [self startMainScreen];
        }
        else{
            self.statusView.hidden = NO;
            [[SyncEngine sharedEngine] downloadZipFile:[_downloadDict objectForKey:@"data"]];
        }
    }
}

#pragma mark - Main Screen
-(void)startMainScreen{

    [self performSegueWithIdentifier:@"segueFromLaunchToDrawer" sender:self];
}

#pragma mark - Map Cache
-(void)startCacheMap{
    [[SyncEngine sharedEngine] downloadMapCache];
}

#pragma mark - Download Progress
-(void)setProgressValueMb:(NSNumber*)totalRead totalBytesExpected:(NSNumber*)totalBytesExpected{
    self.progressBar.progress = totalRead.floatValue / totalBytesExpected.floatValue;
    self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@", totalRead, totalBytesExpected];
}

-(void)setProgressValue:(NSNumber*)totalRead totalBytesExpected:(NSNumber*)totalBytesExpected{
    self.progressBar.progress = totalRead.floatValue / totalBytesExpected.floatValue;
    self.progressLabel.text = [NSString stringWithFormat:@"%@ / %@", totalRead, totalBytesExpected];
}




@end
