#import "BaseQuestionController.h"

@implementation BaseQuestionController
@synthesize record, index,questionsViewController, config = _config, tableView = _tableView;
@synthesize question,pRecord,patientRecordSet;

- (id)initWithConfig:(NSDictionary *)config
{
    self = [super initWithNibName: nil bundle: nil];
    if (self) 
    {
        self.config = config;
    }
    return self;
}
- (id)initWithQuestion:(Questions *)ques
{
    self = [super initWithNibName: nil bundle: nil];
    if (self)
    {
        self.question = ques;
    }
    return self;
}
- (void)dealloc
{
    [_tableView release];
    [_config release];
    self.record = nil;
    self.question=nil;
    self.patientRecordSet=nil;
    self.pRecord=nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - loading

- (UIFont *)titleFont
{
    
    // Jatin Chauhan 23-Nov-2013
    
    //    return [UIFont boldSystemFontOfSize: 19];
    
        return [UIFont boldSystemFontOfSize: 38];
    
    // Jatin Chauhan 23-Nov-2013
    
}

- (UILabel*)labelForSection:(NSInteger)section
{
    
    // Jatin Chauhan 23-Nov-2013
  
    //UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 305, [self tableView: nil heightForHeaderInSection: section])] autorelease];

   UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 550, [self tableView: nil heightForHeaderInSection: section])] autorelease];
   
    // Jatin Chauhan 23-Nov-2013

    
    label.font = [self titleFont];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.text = [self titleForHeaderAtSection: section];
    label.numberOfLines = 0;
   
    
    
    // Akhil - 28-Nov-2013
    
    
    
   // NSArray* foo = [self titleForHeaderAtSection: section];
//    NSString* str_1 = [foo objectAtIndex: 0];
    
    
    NSString* str_1 =  [self titleForHeaderAtSection: section];
    
    NSLog(@"first string=%@",str_1);
    
    label.frame = CGRectMake(20, 20, 550, 155);
    
    label.text = str_1;
    
    CGSize maxLabelSize1 = CGSizeMake(300,9999);
    
    CGSize expectedLabelSize1 = [str_1 sizeWithFont:label.font
                                  constrainedToSize:maxLabelSize1
                                      lineBreakMode:label.lineBreakMode];
 
    CGRect newFrame1 = label.frame;
    newFrame1.size.height = expectedLabelSize1.height;
     label.frame = newFrame1;
   
    [label sizeToFit];
    
   // -Akhil - 28-Nov-2013
    
    
    
    
    return label;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self tableViewBased])
    {
      //  self.tableView = [[[UITableView alloc] initWithFrame: self.view.bounds style: UITableViewStyleGrouped] autorelease];
        
        
        
        self.tableView = [[[UITableView alloc] initWithFrame: CGRectMake(0, 0, 640, 832) style: UITableViewStyleGrouped] autorelease];

        
        
        NSLog(@"view x = %0.2f",self.view.frame.origin.x);
        NSLog(@"view y = %0.2f",self.view.frame.origin.y);
        NSLog(@"view widht = %0.2f",self.view.frame.size.width);
        NSLog(@"view height = %0.2f",self.view.frame.size.height);
        
        
//        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.tableView.backgroundColor = nil;
        self.tableView.backgroundView = nil;
        self.tableView.scrollEnabled = [self scrollEnabled];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.layer.borderWidth=1;
//        self.tableView.layer.borderColor = [[UIColor redColor]CGColor];
        [self.view addSubview: self.tableView];
    }

    else
    {

        UILabel * header = [self labelForSection: 0];
        [self.view addSubview: header];
    }
}


- (void)viewDidUnload
{
    self.tableView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - overrides

- (NSString *)helpUrl
{
    return @"";
}

- (BOOL)tableViewBased
{
    return NO;
}

- (NSString *)titleForHeaderAtSection:(NSInteger)section
{
    return @"";
}

- (BOOL)scrollEnabled
{
    return NO;
}

- (BOOL)canGoNext
{
    return YES;
}


- (NSString *)errorText
{
    return @"";
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGSize sz = [[self titleForHeaderAtSection: section] sizeWithFont: [self titleFont] constrainedToSize: CGSizeMake(305, INT_MAX)];
    return sz.height + 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView* v = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [self tableView: tableView heightForHeaderInSection: section])] autorelease];
    [v addSubview: [self labelForSection: section]];
    
    return v;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
