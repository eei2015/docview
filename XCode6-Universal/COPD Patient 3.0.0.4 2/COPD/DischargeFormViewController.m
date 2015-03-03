//
//  DischargeFormViewController.m
//  COPD
//
//  Created by Abbas Agha on 15/05/13.
//  Copyright (c) 2013 TKInteractive. All rights reserved.
//

#import "DischargeFormViewController.h"
#import "Content.h"
#import "DischargeFormDetailViewController.h"
@interface DischargeFormViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableView;
    NSMutableArray *filteredArray;
}
@property(nonatomic,retain)UITableView *tableView;
-(void)clickButton:(id)sender;
@end

@implementation DischargeFormViewController
@synthesize tableView,formTypeArray,parentController,iMedications,pMedications;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.tableView.delegate = nil;
	self.tableView.dataSource = nil;
	self.tableView = nil;
    self.formTypeArray=nil;
    self.parentController=nil;
    self.pMedications=nil;
    self.iMedications=nil;
    [super dealloc];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[[UIImageView alloc] initWithImage: [UIImage imageNamed: @"bg@2x.png"]] autorelease];
   
    
	// Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // Jatin Chauhan 27-Nov-2013
    
//    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    self.tableView.frame = CGRectMake(65, 50, 640, 832);

    // -Jatin Chauhan 27-Nov-2013    
	[self.view addSubview:self.tableView];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickButton:(id)sender
{
    UIButton *btn=(UIButton*)sender;
    if (!self.parentController)
    {
        return;
    }
    DischargeFormDetailViewController *vc=[[[DischargeFormDetailViewController alloc] init] autorelease];
    vc.formType=btn.tag;
    vc.pMedications=[NSMutableArray arrayWithArray:self.pMedications];
    [self.parentController pushViewController:vc animated:YES];

}
- (UILabel *)titleLabel
{
    UILabel* l = [[[UILabel alloc] initWithFrame:CGRectMake(40, 20, 300, 60)] autorelease]; // (20,0,300,30)
    l.font = [UIFont boldSystemFontOfSize:34]; // 17 Jatin Chauhan 28-Nov-2013
    l.backgroundColor = [UIColor clearColor];
    l.textColor = [UIColor whiteColor];
    l.shadowColor = [UIColor blackColor];
    l.shadowOffset = CGSizeMake(0, 1);
    return l;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table
{ 
	return 1;
}

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section
{

	if (section == 0)
	{
		return @"Discharge Forms: ";
	}

    return nil;
}



// Jatin Chauhan 28-Nov-2013
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 90;
}
// -Jatin Chauhan 28-Nov-2013




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;// 55 - Jatin Chauhan 28-Nov-2013
}
- (UIView *)tableView:(UITableView *)table viewForHeaderInSection:(NSInteger)section
{
    UILabel * l = [self titleLabel];
    l.text = [self tableView:table titleForHeaderInSection: section];
    
    UIView* v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 70)] autorelease]; //(0,0,320,35) Jatin Chauhan 28-Nov-2013
    v.backgroundColor = [UIColor clearColor];
    [v addSubview: l];
    
    return v;
}



- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{

    if (section==0) {
        
        [filteredArray release];
        filteredArray=[[NSMutableArray alloc] init];
        for (int i=1; i<self.formTypeArray.count; i++) {
            DischargeFormType *dft=(DischargeFormType*)[self.formTypeArray objectAtIndex:i];
            if (!dft.DFormStatus==FALSE) {
                [filteredArray addObject:dft];
            }
        } 
        return filteredArray.count;

    }
    return  nil;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
	{
        DischargeFormType *dft=(DischargeFormType*)[filteredArray objectAtIndex:indexPath.row];
        if (!dft.DFormStatus==FALSE) {
            NSString *strTitle=dft.DFormTitle;
            
            
            UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.backgroundColor = [UIColor clearColor];
            
            
            // Jatin Chauhan 28-Nov-2013
            
//  UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
            
            
            UIView *backView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,560,500)] autorelease];
            
            // -Jatin Chauhan 28-Nov-2013
            
            backView.backgroundColor = [UIColor clearColor];
            cell.backgroundView = backView;
     
            
            NSLog(@"view x = %0.2f",self.view.frame.origin.x);
            NSLog(@"view y = %0.2f",self.view.frame.origin.y);
            NSLog(@"view widht = %0.2f",self.view.frame.size.width);
            NSLog(@"view height = %0.2f",self.view.frame.size.height);

            
            
            UIButton *formButton = [UIButton buttonWithType:UIButtonTypeCustom];
            formButton.frame = CGRectMake(-20, 0, 560, 60); // (0,0,250,45)
            [formButton setBackgroundImage:[UIImage imageNamed:@"blue-btn"] forState:UIControlStateNormal];
            [formButton setTitle: strTitle forState:UIControlStateNormal];
            
            [formButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [formButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [formButton setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.5] forState:UIControlStateNormal];
            formButton.titleLabel.shadowOffset = CGSizeMake(1, 0);
            formButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];//14
            formButton.tag=[dft.DFormId intValue];
            [formButton addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
            
            

            [cell.contentView addSubview:formButton];
            return cell;
        }
        
        
		
        
	}
	return nil;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
	{
            }

}

@end
