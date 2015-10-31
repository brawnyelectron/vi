import UIKit
import CoreData

class SettingsViewController: UITableViewController {
  
  // current language
  @IBOutlet var langSet: UILabel!
  // Array of all the switches on the component
  @IBOutlet var settings: Array<UISwitch>?
  
  // Memory warning handle
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  // Table view handling. group header.
  override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
    let headerView = view as! UITableViewHeaderFooterView
    headerView.textLabel!.textColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    
    if let font = UIFont(name: "Lato-Regular", size: 18.0){
      headerView.textLabel?.font = font
    }
  }
  
  // on load
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // table styling
    self.tableView.allowsSelection = false
    self.tableView.backgroundColor = UIColor(red: 243.0/255, green: 243.0/255, blue: 243.0/255, alpha: 1)
    
    // persistent data
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDel.managedObjectContext
    //let entity = NSEntityDescription.entityForName("Settings", inManagedObjectContext: context)
    //let langEnt = NSEntityDescription.entityForName("Language", inManagedObjectContext: context)

    do {
      // For all settings (array of UISwitch), set them to value according to setting data
      for setting in settings! {
        let search = NSFetchRequest(entityName: "Settings")
        search.returnsObjectsAsFaults = false
        // All switches are referenced by number. Modify matchSetting to customize settings
        search.predicate = NSPredicate(format: "name == %@", self.matchSetting(setting.tag))
        let results:NSArray = try context.executeFetchRequest(search)
        setting.setValue(results[0].valueForKey("status"), forKey: "on")
      }
      
//      let langMan = LanguageManager()
//      let langname = langMan.getCurrentLang()
      langSet.text = "    >"
      
    } catch {
      print("ERROR: Either we failed to save asdfwefgaesgef")
    }
  }
  
  // Reference DataInitalizer and tags on storyboard
  func matchSetting(ID: NSInteger) -> NSString {
    switch ID {
    case 1:
      return "alwaysListen"
    case 2:
      return "UIsound"
    case 3:
      return "autoUpdate"
    case 4:
      return "notifyUpdate"
    case 5:
      return "responseVoiceOnOff"
    default:
      return "error: no such settings"
    }
  }
  
  @IBAction func switchListener(sender: UISwitch) {
    let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let context:NSManagedObjectContext = appDel.managedObjectContext
    //let entity = NSEntityDescription.entityForName("Settings", inManagedObjectContext: context)
    let request = NSFetchRequest(entityName: "Settings")
    request.returnsObjectsAsFaults = false;
    request.predicate = NSPredicate(format: "name == %@", self.matchSetting(sender.tag))
    do {
      let results:NSArray = try context.executeFetchRequest(request)
      results[0].setValue(sender.on, forKey: "status")
      try context.save()
    } catch {
      print("ERROR: Couldn't find requested setting or failed to save modified data")
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

  }
  
  @IBAction func TriggerForm(sender: AnyObject) {
    self.performSegueWithIdentifier("languages", sender: self)
  }
}