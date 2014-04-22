//
//  ProfileViewController.m
//  Foodies
//
//  Created by Lucas Chwe on 3/26/14.
//  Copyright (c) 2014 Lucas Chwe. All rights reserved.
//

#import "ProfileViewController.h"
#import "TabBarController.h"
#import "LandingTableViewController.h"
#import <Parse/Parse.h>
#import "Foodie.h"
#import <QuartzCore/QuartzCore.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIColor+colorPallete.h"


@interface ProfileViewController () <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (strong, nonatomic) PFUser *me;
@property (strong, nonatomic) UIImage *profileImage;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (nonatomic) BOOL imagePickerDidAppear;


- (IBAction)logOutTapped:(id)sender;
- (IBAction)editImageTapped:(id)sender;
- (IBAction)saveTapped:(id)sender;
- (IBAction)cancelTapped:(id)sender;

@end

@implementation ProfileViewController

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
    
    // style navbar title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor foodiesColor];
    [titleLabel setText:@"Edit Profile"];
    [titleLabel setFont:[UIFont fontWithName:@"Avenir Book" size:20.0]];
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height/2;
    self.profileImageView.layer.masksToBounds = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editImageTapped:)];
    imageTap.numberOfTapsRequired = 1;
    [self.profileImageView addGestureRecognizer:imageTap];
    
    self.usernameField.delegate = self;
    self.emailField.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // reset info in case a new user logged in
    self.me = [PFUser currentUser];
    if (self.imagePickerDidAppear) {
        self.imagePickerDidAppear = NO;
    } else {
        [self cancelTapped:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logOutTapped:(id)sender {
    [Foodie logOut];
    
    LandingTableViewController *modalVC = [self.storyboard instantiateViewControllerWithIdentifier:@"logInController"];
    [self presentViewController:modalVC animated:YES completion:nil];
    modalVC.delegate = (TabBarController *)self.tabBarController;
    
}

- (IBAction)editImageTapped:(id)sender {
    UIActionSheet *imageEditAction = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose From Photos", nil];
    [imageEditAction showFromTabBar:self.tabBarController.tabBar];
}

- (IBAction)saveTapped:(id)sender {
    // make api call
    if (![self.usernameField.text isEqualToString:self.me.username]) {
        self.me.username = self.usernameField.text;
    }
    if (![self.emailField.text isEqualToString:self.me.email]) {
        self.me.email = self.emailField.text;
    }
    if (![self.profileImage isEqual:self.profileImageView.image]) {
        NSString *imageName = [NSString stringWithFormat:@"%@-%f.png", [Foodie getUserId], [[NSDate date] timeIntervalSince1970]];
        PFFile *imageFile = [PFFile fileWithName:imageName data:UIImagePNGRepresentation(self.profileImageView.image)];
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [self.me setObject:imageFile forKey:@"thumb"];
                [self.me saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    [self finishEdit];
                }];
            }
        }];
    } else {
        [self.me saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self finishEdit];
        }];
    }
}

- (IBAction)cancelTapped:(id)sender {
    self.usernameField.text = self.me.username;
    self.emailField.text = self.me.email;
    [self.profileImageView setImage:self.profileImage];
    PFFile *profileImageFile = [self.me objectForKey:@"thumb"];
    [profileImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            self.profileImage = [UIImage imageWithData:data];
            [self.profileImageView setImage:self.profileImage];
        }
    }];
    [self finishEdit];
}

#pragma mark - Text field methods

- (void)textFieldDidChange
{
    if (![self.usernameField.text isEqualToString:self.me.username] || ![self.emailField.text isEqualToString:self.me.email]) {
        [self beginEdit];
    } else {
        [self finishEdit];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Image methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    imagePicker.allowsEditing = NO;
    
    // set up the source
    if (buttonIndex == 0) {
        // "Take Photo" was pressed
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == 1){
        // "Choose from album" was pressed
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    if (buttonIndex != 2) {
        // present picker
        self.imagePickerDidAppear = YES;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
        // ghetto hackjob cropping
        
        double x = 0;
        double y = 0;
        if (image.size.height > image.size.width){
            x = (image.size.width - image.size.width) / 2.0;
            y = (image.size.height - image.size.width) / 2.0;
        } else {
            x = (image.size.width - image.size.height) / 2.0;
            y = (image.size.height - image.size.height) / 2.0;
        }
        CGRect cropRect = CGRectMake(x, y, image.size.width, image.size.width);
        CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
        UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
        
        // reduce size of image to 300x300 due to file size issues
        CGSize newSize = CGSizeMake(300,300);
        UIGraphicsBeginImageContext(newSize);
        [croppedImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
        UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        self.profileImageView.image = [[UIImage alloc]initWithCGImage:compressedImage.CGImage scale:1.0 orientation:image.imageOrientation];
        [self beginEdit];
    }
}

#pragma mark - View controller methods

- (void)beginEdit
{
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.saveButton;
}

- (void)finishEdit
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self.emailField resignFirstResponder];
    [self.usernameField resignFirstResponder];
}

@end
