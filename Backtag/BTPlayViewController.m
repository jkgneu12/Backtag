//
//  BTPlayViewController.m
//  Backtag
//
//  Created by James George on 9/28/13.
//  Copyright (c) 2013 James George. All rights reserved.
//

#import "BTPlayViewController.h"

#import "BTCreateViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface BTPlayViewController ()
{
    NSInteger _pictureToggle;
}

@end

@implementation BTPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    if(self.imageView.image == nil) {
        [self takePicture];
    }
    [self showNavButtons];
}

- (void)showNavButtons
{
    if(self.imageView.image != nil) {
        UIBarButtonItem *useButton = [[UIBarButtonItem alloc] initWithTitle:@"Use" style:UIBarButtonItemStylePlain target:self action:@selector(useImage:)];
        self.mainViewController.navigationController.topViewController.navigationItem.rightBarButtonItem = useButton;
        
        UIBarButtonItem *retakeButton = [[UIBarButtonItem alloc] initWithTitle:@"Retake" style:UIBarButtonItemStylePlain target:self action:@selector(takePicture)];
        self.mainViewController.navigationController.topViewController.navigationItem.leftBarButtonItem = retakeButton;
    }
}

- (void)takePicture{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Choose a photo source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Photo Library", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.delegate = self;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex < 2){
        _pictureToggle = buttonIndex;
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = _pictureToggle == 0 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
        imagePicker.allowsEditing = NO;
        imagePicker.delegate = self;
        [self presentViewController:imagePicker animated:YES completion:^{
            
        }];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        self.imageView.image = image;
        [self showNavButtons];

        //        if (_newMedia)
        //            UIImageWriteToSavedPhotosAlbum(image,
        //                                           self,
        //                                           @selector(image:finishedSavingWithError:contextInfo:),
        //                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
}
-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //_addingPictureToGame = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)useImage:(id)sender
{
    BTCreateViewController *createController = [[BTCreateViewController alloc] initWithNibName:@"BTCreateViewController" bundle:nil];
    createController.image = self.imageView.image;
    createController.mainViewController = self.mainViewController;
    [self.mainViewController.navigationController pushViewController:createController animated:YES];
    
}

@end
